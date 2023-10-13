@isTest
private class Test_QuoteV2 {
	
	@isTest static void test_method_one() {
		// Implement test code
		// 
		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;
        
        Opportunity testOp = new Opportunity();
        testOp.Name = 'Test';
        testOp.StageName = 'Draft';
        testOp.CloseDate = System.today();
        testOp.AccountId = testAcc.Id;
        
        insert testOp;
        
        
        Quote presupuestos = new Quote();
        presupuestos.Name = 'Test';
        presupuestos.Status = 'Draft';
        presupuestos.Start_date__c = System.today();
        presupuestos.OpportunityId = testOp.Id;
        
        insert presupuestos;
            
		Test.startTest();
		PageReference pageRef = Page.QuoteV2;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('id', presupuestos.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(presupuestos);
		SendQuotePDFController2 cic = new SendQuotePDFController2();
		Test.stopTest();
	}
	
}