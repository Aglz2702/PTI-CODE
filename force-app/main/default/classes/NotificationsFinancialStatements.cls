global class NotificationsFinancialStatements implements Schedulable{
    global void execute(SchedulableContext sc) {
        List<invoice__c> lstFacturas = [SELECT id,PTI_Invoice_number__c, Creation_date__c, Due_date__c, Purchase_order__r.Name, Total__c, Status__c, Work_order__r.Customer__r.Name,ContactId__r.Email,Work_order__c FROM invoice__c WHERE Status__c <> 'paid' AND Status__c <> 'Cancelled' AND Status__c <> 'SCAP Process' ORDER BY Work_order__r.Customer__c];
        Map<String, List<invoice__c>> mapInvoices = new Map<String, List<invoice__c>>();
        string strOrgId = UserInfo.getOrganizationId();
        string orgInst = URL.getSalesforceBaseUrl().getHost();
        Document logoPti = [Select Id,Name,LastModifiedById from Document where Name = 'Logo pti' limit 1];
        Document flechaId = [Select Id,Name,LastModifiedById from Document where Name = 'flecha' limit 1];
        Document inGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'in grueso' limit 1];
        Document fbGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'fb grueso' limit 1];
        Document webGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'web grueso' limit 1];
        Set<Id> idWO =  new Set<Id>(); 
        for(invoice__c i: lstFacturas){
            idWO.add(i.Work_order__c);
            if(!mapInvoices.containsKey(i.Work_order__r.Customer__c)){
                mapInvoices.put(i.Work_order__r.Customer__c,new List<invoice__c>());
            }
            mapInvoices.get(i.Work_order__r.Customer__c).add(i);
        }
        Map<Id,List<Contact_function__c>> mapCF = new Map<Id,List<Contact_function__c>>();
        for(Contact_function__c cf : [SELECT Id,Contact_email__c, Role__c,Work_order__c FROM Contact_function__c WHERE Work_order__c in  :idWO AND (Role__c='Accounts Payable' OR Role__c='Accounts Payable Mailbox' OR Role__c='Finance')]){
            if(!mapCF.containsKey(cf.Work_order__c)){
                mapCF.put(cf.Work_order__c,new List<Contact_function__c>());
            }
            mapCF.get(cf.Work_order__c).add(cf);
        }
        Messaging.SingleEmailMessage[] messages = New Messaging.SingleEmailMessage[]{};
            OrgWideEmailAddress owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = 'Administrador PTI' LIMIT 1];
        for(String i: mapInvoices.KeySet()){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            String[] ccAddresses = new String[] {'egonzalez@ptiqcs.com','c.bugarini@ptiqcs.com'};
            message.setccAddresses(ccAddresses);
            message.setOrgWideEmailAddressId(owe.Id);
            message.setSubject('Account Statement'+' '+ mapInvoices.get(i)[0].Work_order__r.Customer__r.Name);
            String body = '<table "background-color:#CC242C" width="100%" style="border-color:#CC242C; border-spacing: 0;"><tr>';
            body += '<td style="background-color:#CCCFD1" width="10%" align="right"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+flechaId.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:100px;"/></td><td style="background-color:#CCCFD1" width="90%" align="left"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+logoPti.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:100px;"/></td>';
            body += '</tr></table>';
            body += '<p><FONT FACE="Tahoma" SIZE=2><b>Dear customer</b><br/>See below your Account statement, please provide us the next payment date for open invoices.</FONT></p>';
            body += '<p><FONT FACE="Tahoma" SIZE=2>'+ mapInvoices.get(i)[0].Work_order__r.Customer__r.Name +'</FONT></p>';
            body += '<table align="center">';
            body += '<tr>';
            body += '<td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>Invoice </b></FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>Date</b></FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>Due Date</b></FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>Balance</b></FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>DocCur</b></FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2><b>Purchase Order</b></FONT></td>';
            body += '</tr>';
            
            double grandTotal =0;
            List<String> correos = new List<String>();
            
            for(invoice__c x: lstFacturas){
                if(x.Work_order__r.Customer__c==i){
                    if(mapCF.containsKey(x.Work_order__c)){
                        for(Contact_function__c cf : mapCF.get(x.Work_order__c)){
                            correos.add(cf.Contact_email__c);
                        }
                    }
                    if(x.Work_order__r.Customer__r.Name == mapInvoices.get(i)[0].Work_order__r.Customer__r.Name){
                        body += '<tr>';
                        body += '<td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>'+x.PTI_Invoice_number__c+'</FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>'+x.Creation_date__c.format()+'</FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>'+x.Due_date__c.format()+'</FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>'+'$ '+x.Total__c.format()+'</FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>USD</FONT></td><td width="11%" align="left"><FONT FACE="Tahoma" SIZE=2>'+x.Purchase_order__r.Name+'</FONT></td>';
                        body += '</tr>';
                        grandTotal = grandTotal+x.Total__c;
                    }
                }
            }
            body += '<br/><br/><tr><td><FONT FACE="Tahoma" SIZE=2>Total USD: $ '+grandTotal.format()+'</FONT></td></tr>';
            body += '</table>';
            body += '<p><FONT FACE="Tahoma" SIZE=2>Any question or comment please contact to: c.bugarini@ptiqcs.com Ph. 52 477 324 7064<br/>Thank you!</FONT></p>';
            body += '<table "background-color:#CC242C" width="100%" style="border-color:#CC242C; border-spacing: 0;"><tr>';
            body += '<td style="background-color:#CC242C" width="30%" height="80px" align="right"><a href="https://www.linkedin.com/company/pti-qcs/mycompany/"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+inGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/></a><FONT FACE="Open Sans Light" SIZE=3 color="white">PTI-QCS</FONT></td><td style="background-color:#CC242C" width="30%" height="80px" align="center"><a href="https://www.facebook.com/profile.php?id=100083178526485"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+fbGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/></a><FONT FACE="Open Sans Light" SIZE=3 color="white">PTI QCS México</FONT></td><td style="background-color:#CC242C;" width="30%" height="80px" align="left"><a href="www.ptiqcs.com" style="color: white; text-decoration: none; font-size:15px;"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+webGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/>ptiqcs.com</a></td>';
            body += '</tr></table>';
            message.toAddresses = correos.clone();
            
            message.setHtmlBody(body);
            if(!correos.isEmpty()){
                messages.add(message);
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }
}