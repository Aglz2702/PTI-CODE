global class NotificationsBatchNo0 implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global String query;
	Set<String> ids = new Set<String>();
	List<Contact_function__c> listCF = new List<Contact_function__c>();
	
	//Search the inspection reports and prepare the search for Contact functions to which the report will be sent
	global NotificationsBatchNo0() {

        Set<String> idsWOTemp_Set = new Set<String>();
        List<Inspection_report__c> iReports = new List<Inspection_report__c>([SELECT Id, Work_order__c FROM Inspection_report__c 
        WHERE Date__c = YESTERDAY
        AND (Work_order__r.Status__c = 'Active' OR Work_order__r.Status__c = 'Approved WBS')]);

        if(!iReports.isEmpty()){
			for(Inspection_report__c r : iReports){
				idsWOTemp_Set.add(r.Work_order__c);
            }
        }

        List<PO_assignment__c> poa_list = new List<PO_assignment__c>([
            SELECT Id, Purchase_order__c, Purchase_order__r.Total_amount__c,Work_order__c, Work_order__r.Total_cost__c
            FROM PO_assignment__c WHERE (Work_order__r.Status__c = 'Active' OR Work_order__r.Status__c = 'Approved WBS')
            AND Work_order__r.Total_cost__c > 0 AND Work_order__c IN: idsWOTemp_Set
        ]);
        Map<Id, Decimal> po_total = new Map<Id, Decimal>();
        for(PO_assignment__c poa : poa_list){
            if(!po_total.containsKey(poa.Work_order__c)){
                po_total.put(poa.Work_order__c,poa.Purchase_order__r.Total_amount__c - poa.Work_order__r.Total_cost__c);
            }else{
                po_total.put(poa.Work_order__c, po_total.get(poa.Work_order__c) + poa.Purchase_order__r.Total_amount__c);
            }
            //ids.add(poa.Work_order__c);
        }
        System.debug('po_total:: ' + po_total);
        for(Id pt : po_total.keySet()){
            if(po_total.get(pt) >= 500){
                ids.add(pt);
                System.debug('pt:: ' + pt);
            }
        }
        System.debug('ids:: ' + ids);
        query = 'SELECT Id, Work_order__c, Work_order__r.Name, Work_order__r.Project_Id__c, Contact_email__c FROM Contact_function__c WHERE Work_order__c IN: ids AND Send_Notification__c = true';
	}
	
	//Find the contact functions to which the reports will be sent
	global Database.QueryLocator start(Database.BatchableContext BC) {
    	System.debug('query  ----------------------------'+query);
    	//System.debug('----------------------------'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }

	//Modify a field in the contact functions that triggers a workflow rule that starts the creation of the PDF
   	global void execute(Database.BatchableContext BC, List<Contact_function__c> scope) {
		if(!scope.isEmpty()){
            Map<Id, List<String>> wo_emails = new Map<Id, List<String>>();
            //Map<Id, String> wo_nom = new Map<Id, String>();
            Map<Id, Contact_function__c> cont_map = new Map<Id, Contact_function__c>();
            for(Contact_function__c cf : scope){
                if(!wo_emails.containsKey(cf.Work_order__c)){
                    List<String> temp = new List<String>();
                    //temp.add('qcarneiro@ptiqcs.com'); 
                    temp.add('egonzalez@ptiqcs.com');
                    temp.add('kosorio@ptiqcs.com');
                    temp.add('c.bugarini@ptiqcs.com');
                    temp.add(cf.Contact_email__c);
                    wo_emails.put(cf.Work_order__c,temp);
                    cont_map.put(cf.Work_order__c,cf);
                }else{
                    wo_emails.get(cf.Work_order__c).add(cf.Contact_email__c);
                }
            }
            List<PO_assignment__c> poa_list = new List<PO_assignment__c>([
                SELECT Id, Purchase_order__c, Purchase_order__r.Total_amount__c, Work_order__c, Work_order__r.Total_cost__c, Work_order__r.Name
                FROM PO_assignment__c WHERE Work_order__c IN: wo_emails.keySet()
            ]);
            System.debug('poa_list:: ' + poa_list);
            Map<Id, Decimal> po_total = new Map<Id, Decimal>();
            for(PO_assignment__c poa : poa_list){
                if(!po_total.containsKey(poa.Work_order__c)){
                    po_total.put(poa.Work_order__c,poa.Purchase_order__r.Total_amount__c - poa.Work_order__r.Total_cost__c);
                }else{
                    po_total.put(poa.Work_order__c, po_total.get(poa.Work_order__c) + poa.Purchase_order__r.Total_amount__c);
                }
            }
            List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document where Name = 'Logo Rojo' limit 1];
                string strOrgId = UserInfo.getOrganizationId();
                string orgInst = URL.getSalesforceBaseUrl().getHost();
                orgInst = orgInst.substring(0, orgInst.indexOf('.')) + '--c.na53.content.force.com'; //orgInst = 'na14.content.force.com' in my org
                string strDocUrl;
                if (Test.isRunningTest()){
                    strDocUrl = '';
                } else {
                    strDocUrl = URL.getSalesforceBaseUrl().getProtocol() + '://' + orgInst + '/servlet/servlet.ImageServer?id=' + lstDocument[0].Id + '&oid=' + strOrgId + '&lastMod=' + '1539896494000';
                }
                
				
            Messaging.SingleEmailMessage[] messages = New Messaging.SingleEmailMessage[]{};
                OrgWideEmailAddress owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = 'Administrador PTI' LIMIT 1];
                
            for(Id we : wo_emails.keySet()){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setOrgWideEmailAddressId(owe.Id);
                message.toAddresses = wo_emails.get(we).clone();
                message.setSubject('Purchase Order Status --- Estatus de Orden de Compra');
                
                String body = '<p>Dear supplier, we notify you that related purchase orders received for project/work order <b>'
                    + cont_map.get(we).Work_order__r.Name + '</b> (Project #' + cont_map.get(we).Work_order__r.Project_Id__c + ') has a positive balance of $' + po_total.get(we) 
                    + ' USD. We want to clarify you that this balance is against operation consumption, not against billing.</p> <p>Thank you.</p>';
                
                body = body + '<br/><br/>-------------------------<br/><br/>';
                
                body = body + '<p>Estimado proveedor, le notificamos que las órdenes de compra (relacionadas) recibidas para el proyecto/orden de trabajo <b>'
                    + cont_map.get(we).Work_order__r.Name + '</b> (Proyecto #' + cont_map.get(we).Work_order__r.Project_Id__c + ') tienen un saldo positivo de $' + po_total.get(we) 
                    + ' USD. Queremos aclararle que este saldo es contra el consumo de la operación, no contra la facturación.</p> <p>Gracias.</p>';
               	body = body + '<img src="' + strDocUrl + '"/>';
                message.setHtmlBody(body);
                messages.add(message);
            }
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
		}
		
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
}