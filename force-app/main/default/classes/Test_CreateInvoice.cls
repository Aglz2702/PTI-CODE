/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

@isTest
private class Test_CreateInvoice {
	
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
		con.Role__c = 'Coordinator';
		con.AccountID = testAcc.Id;
		con.Type__c = 'TPP';

		insert con;

		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'MEX-SLW-MAQ-0001';
		wo.Start_date__c = Date.today().addDays(-2);

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

		List<Inspection_report__c> irl =new List<Inspection_report__c>();
		for(integer i=0; i < 2; i++){
			Inspection_report__c ir = new Inspection_report__c();
			ir.Billable_item__c = bi.Id;
			ir.Part_number__c = partN.Id;
			ir.Defects__c = 20;
			ir.Total_inspected__c	 = 100;
			ir.QTY_Certified__c = 80;
			ir.Quantity__c = 8;
			ir.Date__c = System.today().addDays(-1);
			ir.Work_order__c = wo.Id;
			ir.Invoiced__c = False;
			ir.Shift__c = '1';
			ir.Description__c = 'Test Description';
			ir.Batch__c = '12355';
			irl.add(ir);
		}

		insert irl;

		Purchase_order__c po = new Purchase_order__c();
		po.Name = 'Test Name';
		po.Customer__c = testAcc.Id;
		po.Reception_date__c = System.today();
		po.Account_Billable_Contact__c = con.Id;
		po.Total_amount__c = 1000.00;
		po.Status__c = 'Approved';

		insert po;

		PO_assignment__c poa = new PO_assignment__c();
		poa.Work_order__c = wo.Id;
		poa.Purchase_order__c = po.Id;

		insert poa;

		//ApexPages.currentPage().getParameters().put('id',wo.id);
		Test.startTest();
		PageReference pageRef = Page.CreateInvoice;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('Id', wo.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(wo);
		CreateInvoiceController cic = new CreateInvoiceController();
		
		cic.PickOpSelect = bi.Name;
		cic.InsRepList.get(bi.Name).InsRepMap.get(irl[0].Id).Invoiced__c = True;
		cic.All.put(bi.Name,False);
		cic.SelectAll();
		cic.All.put(bi.Name,True);
		cic.SelectAll();
		

		cic.InsRepList.get(bi.Name).InsRepMap.get(irl[0].Id).Invoiced__c = False;
		cic.PickOpSelectUnit = irl[0].Id;
		//cic.SelectUnit();
		cic.InsRepList.get(bi.Name).InsRepMap.get(irl[0].Id).Invoiced__c = True;
		cic.PickOpSelectUnit = irl[0].Id;
		cic.calculate();

		cic.Invoice.Purchase_order__c = '000000000000000000';
		cic.POAssignment();
		cic.Invoice.Purchase_order__c = po.Id;
		cic.POAssignment();

		cic.Invoice.Creation_date__c = System.today();
		cic.Save();
		System.assertNotEquals(null,cic.Invoice.Id);
		Test.stopTest();

	}
	
	
}