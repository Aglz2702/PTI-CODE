global class NotificationsFinancialStatement implements Database.Batchable<sObject>, Database.AllowsCallouts{
	global String query = 'SELECT PTI_Invoice_number__c,Creation_date__c,Due_date__c,Purchase_order__r.Name,Total__c,Status__c FROM invoice__c WHERE Status__c <> \'paid\' AND Status__c <> \'Cancelled\'';
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
   
   	global void execute(Database.BatchableContext BC, List<Invoice__c> scope) {
		if(!scope.isEmpty()){
            Map<Id, List<String>> wo_emails = new Map<Id, List<String>>();
            //Map<Id, String> wo_nom = new Map<Id, String>();
            Map<Id, Invoice__c> cont_map = new Map<Id, Invoice__c>();
            for(Invoice__c cf : scope){
                if(!wo_emails.containsKey(cf.Work_order__c)){
                    List<String> temp = new List<String>();
                    temp.add('egonzalez@ptiqcs.com');
                    temp.add('c.bugarini@ptiqcs.com');
                    //temp.add(cf.Contact_email__c);
                    wo_emails.put(cf.Work_order__c,temp);
                    cont_map.put(cf.Work_order__c,cf);
                    //wo_nom.put(cf.Work_order__c, cf.Work_order__r.Name);
                }else{
                    wo_emails.get(cf.Work_order__c).add('gggg@gmail.com');
                }
            }
            List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document where Name = 'Logo Rojo' limit 1];
                string strOrgId = UserInfo.getOrganizationId();
                string orgInst = URL.getSalesforceBaseUrl().getHost();
                orgInst = orgInst.substring(0, orgInst.indexOf('.')) + '--c.na53.content.force.com'; //orgInst = 'na14.content.force.com' in my org
                //string strDocUrl = URL.getSalesforceBaseUrl().getProtocol() + '://' + orgInst + '/servlet/servlet.ImageServer?id=' + lstDocument[0].Id + '&oid=' + strOrgId + '&lastMod=' + '1539896494000';
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
                message.setSubject('ACCOUNT STATEMENT + nombre de la cuenta');
                
                String body = '<p>Dear customer <br/>See below your Account statement, please provide us the next payment date for open invoices.</p>';
                body = '<p>Nombre del cliente</p>';
                body = '<p><table><tr><td>Invoice</td><td>Date</td><td>Due Date</td><td>Balance</td><td>DocCur</td>Purchase Order</tr><tr></tr></table></p>';
                body = body + '<img src="' + strDocUrl + '"/>';
                //body = body + '<img src="' + 'https://ptiqcs--sbx01--c.cs63.content.force.com/servlet/servlet.ImageServer?id=0156C000000Es8w&oid=00D6C0000008d3o&lastMod=1537296058000' + '"/>';
                
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