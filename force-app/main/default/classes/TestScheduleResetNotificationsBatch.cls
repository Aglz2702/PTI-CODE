@isTest
private class TestScheduleResetNotificationsBatch {
    @isTest
    static void test_method_one() {
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
        con.AccountId = testAcc.Id;

		insert con;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
        wo.Type__c = 'L2';
        wo.Start_date__c = System.today() - 5;
    	wo.Alerta_0__c = true;

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
		ir.Date__c = Date.today();
		ir.Batch__c = '233444';
		ir.Description__c = 'testDescription';
		ir.Shift__c = 'TestShift';

		insert ir;
        
        Purchase_order__c po = new Purchase_order__c();
        po.Name = 'Test PO';
        po.Customer__c = testAcc.Id;
        po.Reception_date__c = System.today();
        po.Account_Billable_Contact__c = con.Id;
        po.Total_amount__c = 5000;
        po.Status__c = 'Approved';
        
        Insert po;
        
        po.Total_amount__c = 5000;
        
        Update po;
        
        PO_assignment__c poa = new PO_assignment__c();
        poa.Purchase_order__c = po.Id;
        poa.Work_order__c = wo.Id;
        
        Insert poa;
        
        Test.startTest();
            String CRON_EXP = '0 0 0 15 3 ? 2030';
            System.schedule('scheduleResetNotificationsBatch', CRON_EXP, new scheduleResetNotificationsBatch());
        Test.stopTest();
    }
}