@isTest
private class Test_dsPDF {
	
	@isTest static void test_method_one() {
		// Implement test code
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		Contact con2 = new Contact();
		con2.LastName = 'Tester';
		con2.FirstName = 'Test';
		con2.Email = 'con@correo.com';
		con2.Type__c = 'Customer';
		con2.Role__c = 'Finance';
		con2.AccountId = testAcc.Id;

		insert con2;

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = con2.Id;
		cf2.Work_order__c = wo.Id;

		insert cf2;

		Billable_item__c bi = new Billable_item__c();
		bi.Name = 'Inspection';
		bi.Unit_cost__c = 11.55;
		bi.Billable_item_price_type__c	= 'Standard';
		bi.Work_order__c = wo.Id;

		insert bi;

		Part_number__c partN = new Part_number__c();
		partN.Name = '11111-Test';
		partN.Part_number__c='1111';
		partN.Work_order__c = wo.Id;

		insert partN;

		Test.startTest();
		PageReference pageRef = Page.dsPDF;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('Id', wo.id);
		pageRef.getParameters().put('idF', cf2.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(wo);
		dsPDFController cic = new dsPDFController();
		Test.stopTest();
	}
	
}