/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

/**
  * Mail read that SWS sends
**/
global class inboundEmail implements Messaging.InboundEmailHandler{
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		String myPlainText= '';
    
    	// Add the email plain text into the local variable 
    	myPlainText = email.plainTextBody;
    	String subject = email.subject;
    	try { 
            System.debug('Cuerpo:: '+myPlainText);
            //[3cpr] Toluca Provider Issue Initiation - 3CPR Provider Issue Project #62017 Issue #1
            //[3cpr] Toluca L1 Exit - 3CPR Project#61020,Supplier:AP PLASMAN INC,Part# 6RP35TRMAC
     		List<String> typeSubject = subject.split(' ');
            //System.debug(': '  );
            if(typeSubject.contains('Exit')){
                String project = subject.split('Project#')[1].split(',')[0];
                List<Work_order__c> wo = new List<Work_order__c>([Select Id,Finished_by_customer__c From Work_order__c Where Project_Id__c =: project limit 1]);
                if(!wo.isEmpty()){
                    System.debug('Cuerpo:: '+myPlainText);
                    wo[0].Finished_by_customer__c = true;
                    update wo;
                }
            }else if(typeSubject.contains('Provider')&&typeSubject.contains('Issue')){
                String project = subject.split('Project #')[1].split(' ')[0];
                List<Work_order__c> wo = new List<Work_order__c>([Select Id,Provider_Issues__c From Work_order__c Where Project_Id__c =: project limit 1]);
                if(!wo.isEmpty()){
                    System.debug('Cuerpo:: '+myPlainText);
                    wo[0].Provider_Issues__c = myPlainText;
                    update wo;
                }
                
            }
    	}
   		catch (QueryException e) {
       		System.debug('Query Issue: ' + e);
   		}
   
	   	// Set the result to true. No need to send an email back to the user 
	   	// with an error message
   		result.success = true;
   		
   		// Return the result for the Apex Email Service
   		return result;
	}
}