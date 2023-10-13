/**
 *  @Name           TestWorkOrderTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description:   Test method for the Work order trigger and its controller class
**/
@isTest
private class TestWorkOrderTrigger {
	
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
		wo.Status__c = 'Active';

		update wo;

		Work_order__c wo1 = new Work_order__c();
		wo1.Customer__c = testAcc.Id;
		wo1.Status__c = 'Draft';
		wo1.Name = 'ME';

		insert wo1;

		wo1.Cost_center__c = '404';
		wo1.Status__c = 'Active';

		update wo1;

		wo1.Status__c = 'Approved WBS';
		wo1.Project_Id__c = '10101010101';
		update wo1;
	}
	
	
	
}