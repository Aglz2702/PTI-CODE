public class SendQuoteNew {
    
    public String idPresu {get;set;}
    public Quote Presupuestos {get;set;}
    public Map<String, Contact> cfMap {get;set;}
    public Boolean verifySend {get;set;}
    public Boolean checkCOTIZACION {get;set;}
    public ContentVersion consul {get;set;}
    
    public SendQuoteNew() {
        idPresu = ApexPages.currentPage().getParameters().get('id');
        cfMap = new Map<String, Contact>();
        verifySend = false;
        checkCOTIZACION = false;
        
        presupuestos = [SELECT Id, Name,ContactId,Contact.Name,Contact.Email,Start_date__c,QuoteNumber,Account.Name FROM Quote WHERE Id =: idPresu];
        
        if(String.isBlank(presupuestos.ContactId))
        {
            checkCOTIZACION = false;
        }else{
            checkCOTIZACION = true;
        }
        
    }
    
    public PageReference SendNow(){
        try {
            
            PageReference pageRef = new PageReference('/apex/QuoteV2');
            pageRef.getParameters().put('id', presupuestos.Id);
            Blob pdfBlob;
            if(Test.isRunningTest()) {
                pdfBlob = Blob.valueOf('Test');
            } else {
                pdfBlob = pageRef.getContent();
            }
            if(verifySend && checkCOTIZACION){
                
                
                String mensaje = 'Dear:'+ ' ' +presupuestos.Contact.Name+'\n\n';
                mensaje += 'We in PTI QCS are extremely excited about the possibilities that could arise in the near future to demonstrate your company with our capabilities and performance.\n\n';
                mensaje += 'PTI Quality Containment Solutions(“QCS”) is a privately held U.S. based company operating in U.S., Canada, Mexico, China and Korea. QCS core business is to provide warehousing, packaging, labeling, logistics, distribution and rework services to Original Equipment Manufacturers (“OEM’s”) and their respective part suppliers.\n\n';
                mensaje += 'We are currently servicing industry leaders as Stellantis, GM,  Visteon, Lear, Delphi, Dana, AAM, Metaldyne, Benteler (among others) in all cases providing them with products as Tier 1 or Tier 2 being responsible of planning and execution for all logistic functions including bar code labels, error proofing and ASN.\n\n';
                mensaje += 'Our services are top ranked by our existing customers and our proposals are extremely competitive..';
                
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                List<OrgWideEmailAddress> addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'adminsalesforce@ptiqcs.com'];
                if (!addresses.isEmpty()) {
                    semail.setOrgWideEmailAddressId(addresses[0].Id);
                }
                String[] sendingTo = new String[]{presupuestos.Contact.email};
                    semail.setToAddresses(sendingTo);
                String[] sendingTocAdd = new String[]{'kosorio@ptiqcs.com'};
                    semail.setCcAddresses(sendingTocAdd);
                semail.setSubject('QUOTE N°'+ presupuestos.QuoteNumber + ' ' + presupuestos.Account.Name);
                semail.setPlainTextBody(mensaje);
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Quote.pdf');
                efa.setBody(pdfBlob);
                attachments.add(efa);
                semail.setFileAttachments(attachments);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
                
                
            }				
            return new PageReference('/' + presupuestos.Id);
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            ApexPages.addMessages(e);
            return null;
        }
        
    }
}