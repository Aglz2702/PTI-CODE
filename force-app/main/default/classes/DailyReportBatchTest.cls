/**
 *  @Name           DailyReportBatchTest
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Test method for DailyReportBatch
**/

@isTest
private class DailyReportBatchTest {
	
	@isTest static void test_method_one() {
		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Contact con = new Contact();
		con.FirstName = 'test';
		con.LastName = 'Tester';
		con.Email = 'correo@test.com';
		con.Type__c = 'TPP';
		con.Role__c = 'Coordinator';

		insert con;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';

		insert wo;

		wo.Cost_center__c = '404';
		wo.Status__c = 'Active';

		update wo;

		Contact_function__c cf1 = new Contact_function__c();

		cf1.Customer__c = testAcc.Id;
		cf1.Work_order__c = wo.Id;
		cf1.Send_daily_email__c = true;
		cf1.Contact__c = con.Id;

		insert cf1;

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

		Inspection_report__c ir = new Inspection_report__c();
		ir.Billable_item__c = bi.Id;
		ir.Part_number__c = partN.Id;
		ir.Defects__c = 20;
		ir.Total_inspected__c	 = 100;
		ir.QTY_Certified__c = 80;
		ir.Quantity__c = 8;
		ir.Date__c = Date.today().addDays(-1);
		ir.Batch__c = '233444';
		ir.Description__c = 'testDescription';
		ir.Shift__c = 'TestShift';
		//ir.Date__c = Date.parse('26/11/2018');

		insert ir;

		Inspection_report__c ir2 = new Inspection_report__c();
		ir2.Billable_item__c = bi.Id;
		ir2.Part_number__c = partN.Id;
		ir2.Defects__c = 20;
		ir2.Total_inspected__c	 = 100;
		ir2.QTY_Certified__c = 80;
		ir2.Quantity__c = 8;
		ir2.Date__c = Date.today().addDays(-2);
		ir2.Batch__c = '233444';
		ir2.Description__c = 'testDescription';
		ir2.Shift__c = 'TestShift';
		//ir2.Date__c = Date.parse('26/11/2018');

		insert ir2;

		Test.startTest();
			DailyReportBatch drb = new DailyReportBatch(true, false);
			Database.executeBatch(drb);
			DailyReportBatch drb2 = new DailyReportBatch(false, true);
			Database.executeBatch(drb2);
		Test.stopTest();
	}
	
	
}