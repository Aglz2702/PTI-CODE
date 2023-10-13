/**
 *  @Name           DailyReportBatchTest
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Test method for DailyReportBatch
**/

@isTest
private class TestCtrlDailyReport {
	
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
		ir.Total_inspected__c = 100;
		ir.QTY_Certified__c = 80;
		ir.Quantity__c = 8;
		ir.Date__c = Date.today().addDays(-1);
		ir.Batch__c = '233444';
		ir.Description__c = 'testDescription';
		ir.Shift__c = 'TestShift';
		//ir.Date__c = Date.parse('26/11/2018');

		insert ir;

		Test.startTest();
			ctrlDailyReportComponent DR = new ctrlDailyReportComponent();
			DR.idWO = wo.id;
			DR.dCheck = true;
			DR.wCheck = false;
			Work_order__c pruwo = DR.getWorkOrder();
			Map<String, List<Inspection_report__c>> IRT = DR.getInspections();
			Date d = DR.getDateYesterday();
			Map<Id, Part_number__c> PNM = DR.getPartNumbers();
			DR.dCheck = false;
			DR.wCheck = true;
			Work_order__c pruwo2 = DR.getWorkOrder();
			Map<String, List<Inspection_report__c>> IRT2 = DR.getInspections();
			Date d2 = DR.getFirstDate();
			Map<Id, Part_number__c> PNM2 = DR.getPartNumbers();
		Test.stopTest();
	}
	
	
}