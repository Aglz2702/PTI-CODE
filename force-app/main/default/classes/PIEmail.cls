/**
 *  @Copyright      PTI QCS
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
**/

/**
  * Mail read that SWS sends
**/
global class PIEmail implements Messaging.InboundEmailHandler{
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		String myPlainText= '';
    
    	// Add the email plain text into the local variable 
    	myPlainText = email.plainTextBody;
        System.debug('Cuerpo:: '+myPlainText);
    	String subject = email.subject;
    	try { 
     		List<String> typeSubject = subject.split(' ');
     		String project = subject.split('Project#')[1].split(',')[0];
     		//System.debug(': '  );
     		if(typeSubject.contains('Provider Issue')){
	     		List<Work_order__c> wo = new List<Work_order__c>([Select Id,Provider_Issue__c From Work_order__c Where Project_Id__c =: project limit 1]);
	     		if(!wo.isEmpty()){
	     			
	     			
                    
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