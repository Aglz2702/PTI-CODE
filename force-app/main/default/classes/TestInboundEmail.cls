/**
 *  @Name           TestInboundEmail
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description:   Test method for the inbaundEmail class
**/
@isTest
private class TestInboundEmail {
	
	@isTest static void test_method_one() {
		
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'ME';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Project_Id__c = '1234';
		wo.Status__c = 'Approved WBS';

		update wo;

		// create a new email and envelope object
	    Messaging.InboundEmail email = new Messaging.InboundEmail() ;
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	    
	    // setup the data for the email
	    email.subject = '[3cpr] Toluca L1 Exit - 3CPR Project#1234,Supplier:MNP CORPORATION,Part# 06512427AA';
	    email.fromname = 'Test Tester';
	    env.fromAddress = 'sfdcsrini@email.com';

	    inboundEmail ie = new inboundEmail();
	    ie.handleInboundEmail(email, env);
        
        // create a new email and envelope object
	    Messaging.InboundEmail email2 = new Messaging.InboundEmail() ;
	    Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
	    
	    // setup the data for the email
        email2.subject = '[3cpr] Toluca Provider Issue Initiation - 3CPR Provider Issue Project #9999 Issue #1';
	    email2.fromname = 'Test Tester2';
        env2.fromAddress = 'egonzalez@ptiqcs.com';

	    inboundEmail ie2 = new inboundEmail();
	    ie2.handleInboundEmail(email2, env2);
        
        
	}
	
	
}