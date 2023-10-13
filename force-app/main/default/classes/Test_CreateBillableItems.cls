/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

@isTest
private class Test_CreateBillableItems {
	
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

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		System.assertNotEquals(null,CreateBillableItemController.getServices(0));
		List<CreateBillableItemController.BillableItem> lcbic = new List<CreateBillableItemController.BillableItem>();
		CreateBillableItemController.BillableItem cbic = new CreateBillableItemController.BillableItem();
		cbic.Type = 'Inspection';
		cbic.serviceType = 'Standard';
		cbic.Description = '';
		cbic.Unit_cost = 10.00;
		lcbic.add(cbic);
		System.assertEquals('ok',CreateBillableItemController.createBI(JSON.serialize(lcbic),wo.Id));

	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}