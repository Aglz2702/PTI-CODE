public class SendContractNew {
    
    public String idWO {get;set;}
    public Work_order__c wo {get;set;}
    public Map<String, Contact_function__c> cfMap {get;set;}
    public Boolean verifySend {get;set;}
    public Boolean verifyFinance {get;set;}
    public List<String> correosCF {get;set;}
    public List<Contact_function__c> ListaFinanzas {get;set;}
    
    public SendContractNew(){
        idWO = ApexPages.currentPage().getParameters().get('id');
        wo = [SELECT Id, Name, Account_Name__c, Customer__r.Name, Start_date__c, Project_Id__c, Type__c FROM Work_order__c WHERE Id =: idWO];
        ListaFinanzas = [SELECT Contact_email__c,Contact__r.Name,Role__c FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c='Finance'];
        if(ListaFinanzas.isEmpty()){
            verifyFinance = false;
        }else{
            verifyFinance = true;
        }
        correosCF = new List<String>();
        List<Contact_function__c> CorreoCF = [SELECT Contact_email__c FROM Contact_function__c WHERE Work_order__c =: idWO ];
        for(Contact_function__c i : CorreoCF){
            correosCF.add(i.Contact_email__c);
        }
    }
    
    public PageReference SendContractNew(){
        try{
            PageReference pageRef = new PageReference('/apex/ContratoPDF');
            pageRef.getParameters().put('id', wo.Id);
            Blob pdfBlob;
            if(Test.isRunningTest()) {
                pdfBlob = Blob.valueOf('Test');
            } else {
                pdfBlob = pageRef.getContent();
            }
            
            if(verifySend && verifyFinance){
                String mensaje = 'Dear Customer:\n\nYou are receiving this email due to your company being placed on a 3CPR Level 1 or Level 2 by FCA. As a result, PTI has been instructed to initiate containment process on your behalf. PTI is committed to provide the best class service for your company. Please sign the PDF with the terms of service within 24 hours of project initiation, it’s a requirement to continue whit the project that has been initiated.\n\n';
                mensaje += 'Thank you for all your support!\n\nThe PTI Team.\n\n——————————————————————————————\n\n';
                mensaje += 'Estimado cliente:\n\nEstá recibiendo este correo electrónico debido a que su empresa se encuentra en un 3CPR Nivel 1 o Nivel 2 por FCA. Como resultado, PTI recibió instrucciones de iniciar un proceso de contención en su nombre. PTI se compromete a proporcionar el mejor servicio de clase para su empresa. Firme el PDF anexo con los términos del servicio dentro de las 24 horas posteriores al inicio del proyecto, es un requisito continuar con el proyecto que se ha iniciado.\n\n';
                mensaje += 'Gracias por todo su apoyo!\n\nEl equipo de PTI.';
                
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                List<OrgWideEmailAddress> addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'adminsalesforce@ptiqcs.com'];
                if (!addresses.isEmpty()) {
                    semail.setOrgWideEmailAddressId(addresses[0].Id);
                }
                //String[] sendingTo = new String[]{correosCF};
                semail.setToAddresses(correosCF);
                String[] sendingTocAdd = new String[]{'kosorio@ptiqcs.com'};
                    semail.setCcAddresses(sendingTocAdd);
                semail.setSubject('Work Order Authorization: ' + wo.Name);
                semail.setPlainTextBody(mensaje);
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(wo.Name+'.pdf');
                efa.setBody(pdfBlob);
                attachments.add(efa);
                semail.setFileAttachments(attachments);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});  
            }				
            return new PageReference('/' + wo.Id);
        }catch(CalloutException e) {
            System.debug('Exception - ' + e );
            ApexPages.addMessages(e);
            return null;
        }
    }   
}