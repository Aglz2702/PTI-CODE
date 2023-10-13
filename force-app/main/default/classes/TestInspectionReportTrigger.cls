/**
 *  @Name           TestInspectionReportTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description:   Test method for the Inspection Reports trigger and its controller class
**/
@isTest
private class TestInspectionReportTrigger {
	
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
		wo.Name = 'MEX-SLW-MAQ-0001';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

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

		List<Inspection_report__c> riList = new List<Inspection_report__c>();

		for(Integer i = 0; i < 200 ; i++){
			Inspection_report__c ir = new Inspection_report__c();
			ir.Billable_item__c = bi.Id;
			ir.Part_number__c = partN.Id;
			ir.Quantity__c = 12;
			ir.Invoiced__c	= true;
			riList.add(ir);
		}
		
		Test.startTest();
			insert riList;
			try{
				delete riList;
			}catch(Exception e){

			}
			
		Test.stopTest();

	}
	
}