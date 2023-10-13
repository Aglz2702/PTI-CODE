public class SendInvoiceController {
    
    public String idInvoice {get;set;}
    public Invoice__c factura {get;set;}
    public Boolean verifySend {get;set;}
    public Boolean checkINVOICE {get;set;}
    public ContentVersion consul {get;set;}
    
    public SendInvoiceController(){
        idInvoice = ApexPages.currentPage().getParameters().get('id');
        verifySend = false;
        checkINVOICE = false;
        
        factura = [SELECT id,Name,ContactId__c,ContactId__r.email,ContactId__r.Name,PTI_Invoice_number__c,Work_order__r.Name,Purchase_order__r.Name FROM Invoice__c WHERE id=: idInvoice];

        if(String.isBlank(factura.ContactId__c))
        {
            checkINVOICE = false;
        }else{
            checkINVOICE = true;
        }
    }
    
    public PageReference SendInvoice(){
        try {
            if(verifySend && checkINVOICE){
                string strOrgId = UserInfo.getOrganizationId();
                string orgInst = URL.getSalesforceBaseUrl().getHost();
                Document logoPti = [Select Id,Name,LastModifiedById from Document where Name = 'Logo pti' limit 1];
                Document flechaId = [Select Id,Name,LastModifiedById from Document where Name = 'flecha' limit 1];
                Document inGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'in grueso' limit 1];
                Document fbGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'fb grueso' limit 1];
                Document webGrueso = [Select Id,Name,LastModifiedById from Document where Name = 'web grueso' limit 1];
                String mensaje = '<table "background-color:#CC242C" width="100%" style="border-color:#CC242C; border-spacing: 0;"><tr>';
                mensaje += '<td style="background-color:#CCCFD1" width="10%" align="right"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+flechaId.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:100px;"/></td><td style="background-color:#CCCFD1" width="90%" align="left"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+logoPti.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:100px;"/></td>';
                mensaje += '</tr></table>';
                mensaje += '<p><FONT FACE="Tahoma" SIZE=4>Dear customer</FONT></p><br/><br/>';
                mensaje += '<p><FONT FACE="Tahoma" SIZE=4>Attached you will find your recent invoice for quality services.</FONT></p><br/>';
                mensaje += '<p><FONT FACE="Tahoma" SIZE=4>Please confirm the reception of this document and if you have any questions or comments please contact us at: pti_ar@ptiqcs.com Ph. 52 477 324 7064.</FONT></p>';
                mensaje += '<p><FONT FACE="Tahoma" SIZE=4>Thank you!</FONT></p>';
                mensaje += '<p align="center"><FONT FACE="Tahoma" SIZE=4>"If you take care of the customers, business will take care of itself"</FONT></p>';
                mensaje += '<table "background-color:#CC242C" width="100%" style="border-color:#CC242C; border-spacing: 0;"><tr>';
                mensaje += '<td style="background-color:#CC242C" width="30%" height="80px" align="right"><a href="https://www.linkedin.com/company/pti-qcs/mycompany/"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+inGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/></a><FONT FACE="Open Sans Light" SIZE=3 color="white">PTI-QCS</FONT></td><td style="background-color:#CC242C" width="30%" height="80px" align="center"><a href="https://www.facebook.com/profile.php?id=100083178526485"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+fbGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/></a><FONT FACE="Open Sans Light" SIZE=3 color="white">PTI QCS México</FONT></td><td style="background-color:#CC242C;" width="30%" height="80px" align="left"><a href="www.ptiqcs.com" style="color: white; text-decoration: none; font-size:15px;"><img src="https://'+orgInst+'/servlet/servlet.ImageServer?id='+webGrueso.Id+'&oid='+strOrgId+'&lastMod=1537296058000" style="height:50px;"/>ptiqcs.com</a></td>';
                mensaje += '</tr></table>';
                
                consul = [SELECT ID,title,fileType,versiondata FROM ContentVersion where fileType='PDF' and title=:factura.PTI_Invoice_number__c];
                blob WOCFbody = consul.versiondata;
                Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                efa1.setFileName(consul.Title+'.pdf');
                efa1.setBody(WOCFbody);
                
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                List<OrgWideEmailAddress> addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'pti_ar@ptiqcs.com'];
                if (!addresses.isEmpty()) {
                    semail.setOrgWideEmailAddressId(addresses[0].Id);
                }
                String[] sendingTo = new String[]{factura.ContactId__r.email};
                semail.setToAddresses(sendingTo);
                String[] sendingTocAdd = new String[]{'c.bugarini@ptiqcs.com','egonzalez@ptiqcs.com'};
                semail.setCcAddresses(sendingTocAdd);
                semail.setSubject('Invoice '+ factura.PTI_Invoice_number__c+' '+factura.Work_order__r.Name+' '+factura.Purchase_order__r.Name);
                semail.setHtmlBody(mensaje);
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                attachments.add(efa1);
                semail.setFileAttachments(attachments);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
            }				
            return new PageReference('/' + factura.Id);
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            ApexPages.addMessages(e);
            return null;
        }
        
    }

}