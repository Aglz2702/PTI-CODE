@isTest
private class Test_CreateContactFunction {
	
	@isTest static void test_method_one() {
		// Implement test code
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;

		List<Account> testAccList = new List<Account>();
		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';
		testAccList.add(testAcc);

		Account testAcc2 = new Account();
		testAcc2.Name = 'PTI Test';
		testAcc2.Customer_keyword__c = 'test id';
		testAccList.add(testAcc2);

		insert testAccList;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		wo.Part_numbers__c = '0000;1111;2222;3333';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		List<Contact> ContactList = new List<Contact>();
		Contact cont = new Contact();
		cont.FirstName = 'Test';
		cont.LastName = 'Test';
		cont.Email = 'Test@test.com';
		cont.Type__c = 'Customer';
		cont.Role__c = 'SQA';
		cont.AccountId = testAccList[0].Id;
		ContactList.add(cont);

		Contact cont2 = new Contact();
		cont2.FirstName = 'Test';
		cont2.LastName = 'Test';
		cont2.Email = 'Test@test.com';
		cont2.Type__c = 'TPP';
		cont2.Role__c = 'Coordinator';
		cont2.AccountId = testAccList[1].Id;
		ContactList.add(cont2);

		Contact cont3 = new Contact();
		cont3.FirstName = 'Test';
		cont3.LastName = 'Test';
		cont3.Email = 'Test@test.com';
		cont3.Type__c = 'Customer';
		cont3.Role__c = 'Finance';
		cont3.AccountId = testAccList[1].Id;
		ContactList.add(cont3);

		Insert ContactList;



		System.assertNotEquals(null,CreateContactFunctionController.getPicklistValues());
		System.assertNotEquals(null,CreateContactFunctionController.getContacts(wo.Id));
		String param ='[[{"cont":{"Id":"'+ContactList[1].Id+'","Name":"'+'Test Test'+'","Type__c":"Customer","Role__c":"SQA","AccountId":"'+ContactList[1].AccountId+'","Account":{"Name":"'+ContactList[1].Account.Name+'","Id":"'+ContactList[1].AccountId+'"}},"create":true,"send":true, "woNotification":true}]]';
		System.assertEquals('ok',CreateContactFunctionController.saveFunctionContacts(param,wo.Id));
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}