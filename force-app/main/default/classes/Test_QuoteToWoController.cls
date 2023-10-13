@isTest
private class Test_QuoteToWoController {
	
	@isTest static void test_method_one() {
        
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
        
        Quote Quo = new Quote();
        Quo.Name = 'test';
        Quo.Status ='Draft';
        Quo.Service_Description__c = 'prueba';
        Quo.Subject__c = 'prueba';
		Quo.OpportunityId = testOp.Id;
        
        insert Quo;
        
        
        Contact cont = new Contact();
        cont.LastName = 'prueba';
        cont.Email = 'prueba@gmail.com';
        
        Work_order__c wo = new Work_order__c();
        wo.Name =  testOp.Name;
		wo.Status__c = 'Draft';
        wo.Customer__c =  testOp.AccountId;
        wo.Problem__c = 'Es una Prueba';
        wo.Job_description__c = 'Es una Prueba';

		insert wo;
        
        Test.startTest();
			PageReference pref = Page.QuoteToWO;
			Test.setCurrentPage(pref);
			ApexPages.currentPage().getParameters().put('id', Quo.Id); 
			ApexPages.StandardController sc = new ApexPages.StandardController(Quo);
			QuoteToWOController QuoWO = new QuoteToWOController(sc);
        
        	PageReference pf = QuoWO.Guardar();
		Test.stopTest();
    }
}