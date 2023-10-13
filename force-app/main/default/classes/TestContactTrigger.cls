/**
 *  @Name           TestContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Test method for the contact trigger and its controlling class
**/
@isTest
private class TestContactTrigger {
	
	@isTest static void test_method_one() {
		// Implement test code

		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;


		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Contact contactTest = new Contact();
		contactTest.LastName = 'Tester';
		contactTest.FirstName = 'Test';
		contactTest.Status__c = 'Active';
		contactTest.email = 'correo@correo.com';
		contactTest.AccountId = testAcc.Id;

		insert contactTest;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		contactTest.Status__c = 'Inactive';
		update contactTest;

		contactTest.Status__c = 'Active';
		update contactTest;

	}
	
	
}