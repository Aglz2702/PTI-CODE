/**
 *  @Name           TestContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Test method for the Function contact trigger and its controlling class
**/

@isTest
private class TestContactFunctionTrigger {
	
	@isTest static void test_method01() {
		
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
		contactTest.Type__c = 'Customer';
		contactTest.Role__c = 'SQA';

		insert contactTest;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = contactTest.Id;
		cf2.Customer__c = testAcc.Id;
		cf2.Work_order__c = wo.Id;
		cf2.Send_daily_email__c = true;

		try{
			insert cf2;
			}catch(Exception e){

			}
		

	}
	
	@isTest static void test_method02() {
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
		contactTest.Type__c = 'Customer';
		contactTest.Role__c = 'Finance';

		insert contactTest;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = contactTest.Id;
		cf2.Customer__c = testAcc.Id;
		cf2.Work_order__c = wo.Id;
		cf2.Send_daily_email__c = true;

		try{
			insert cf2;
			}catch(Exception e){

		}
		
	}
	
	@isTest static void test_method03() {
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
		contactTest.Type__c = 'TPP';
		contactTest.Role__c = 'Coordinator';

		insert contactTest;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = contactTest.Id;
		cf2.Customer__c = testAcc.Id;
		cf2.Work_order__c = wo.Id;
		cf2.Send_daily_email__c = true;

		try{
			insert cf2;
			}catch(Exception e){

		}
	}

	@isTest static void test_method04() {
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
		contactTest.Type__c = 'TPP';
		contactTest.Role__c = 'Process engineer';

		insert contactTest;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = contactTest.Id;
		cf2.Customer__c = testAcc.Id;
		cf2.Work_order__c = wo.Id;
		cf2.Send_daily_email__c = true;

		try{
			insert cf2;
			}catch(Exception e){

		}

	}

	@isTest static void test_method05() {
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
		contactTest.Type__c = 'Customer';
		contactTest.Role__c = 'Quality';

		insert contactTest;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		
		insert wo;

		Contact_function__c cf = new Contact_function__c();
		cf.Contact__c = contactTest.Id;
		cf.Customer__c = testAcc.Id;
		cf.Work_order__c = wo.Id;
		cf.Send_daily_email__c = true;

		insert cf;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = contactTest.Id;
		cf2.Customer__c = testAcc.Id;
		cf2.Work_order__c = wo.Id;
		cf2.Send_daily_email__c = true;

		try{
			insert cf2;
			}catch(Exception e){

		}
		
	}
}