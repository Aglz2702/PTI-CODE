@isTest
private class Test_CreatePartNumbers {
	
	@isTest static void test_method_one() {
		// Implement test code
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;
		
		List<Service__c> serv = new List<Service__c>();
		Service__c se = new Service__c();
		se.Name = 'Inspection OT';
		se.Type__c = 'Standard';
		se.Unit_cost__c = 15.5;
		serv.add(se);
		Service__c se2 = new Service__c();
		se2.Name = 'Hotel';
		se2.Type__c = 'Standard';
		se2.Unit_cost__c = 15.5;
		serv.add(se2);
		insert serv;

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		wo.Part_numbers__c = '0000;1111;2222;3333';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		Part_number__c partN = new Part_number__c();
		partN.Name = '1111-Test';
		partN.Part_number__c='1111';
		partN.Work_order__c = wo.Id;

		insert partN;

		System.assertNotEquals(null,CreatePartNumbersController.getProducts(wo.Id));
		System.assertNotEquals(null,CreatePartNumbersController.Product(wo.Id,0));

		List<CreatePartNumbersController.wrapperClass> cncwl = new List<CreatePartNumbersController.wrapperClass>();
		CreatePartNumbersController.wrapperClass cncw = new CreatePartNumbersController.wrapperClass();

		Part_number__c partN2 = new Part_number__c();
		partN2.Name = '9999-Test';
		partN2.Part_number__c='9999';
		partN2.Work_order__c = wo.Id;

		cncw.part = partN2;
		cncw.PartCount = 1;

		cncwl.add(cncw);
		System.assertEquals('ok',CreatePartNumbersController.insertParts(JSON.serialize(cncwl),'Defect Test', 'Description Test'));
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		// Implement test code
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;
		
		List<Service__c> serv = new List<Service__c>();
		Service__c se = new Service__c();
		se.Name = 'Inspection OT';
		se.Type__c = 'Standard';
		se.Unit_cost__c = 15.5;
		serv.add(se);
		Service__c se2 = new Service__c();
		se2.Name = 'Hotel';
		se2.Type__c = 'Standard';
		se2.Unit_cost__c = 15.5;
		serv.add(se2);
		insert serv;

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		wo.Part_numbers__c = '0000';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		Part_number__c partN = new Part_number__c();
		partN.Name = '0000-Test';
		partN.Part_number__c='0000';
		partN.Work_order__c = wo.Id;

		insert partN;

		System.assertNotEquals(null,CreatePartNumbersController.getProducts(wo.Id));
	}
	
}