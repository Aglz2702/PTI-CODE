@isTest
private class SendQuoteNewTest {
	
	@isTest static void test_method_one() {
		Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

			ContentVersion conv = new ContentVersion(
				Title = 'Penguins',
      			PathOnClient = 'Penguins.pdf',
	        	VersionData = Blob.valueOf('Test Content: '),
	        	IsMajorVersion = true
			);

		insert conv;


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
        
        Contact cont = new Contact();
        cont.LastName = 'prueba';
        cont.Email = 'prueba@gmail.com';
        
        insert cont;
        system.debug(cont);
        
        Quote presupuestos = new Quote();
        presupuestos.Name = 'Test';
        presupuestos.ContactId = cont.Id;

        presupuestos.Status = 'Draft';
        presupuestos.Start_date__c = System.today();
        presupuestos.OpportunityId = testOp.Id;
        
        insert presupuestos;
        system.debug(presupuestos.Contact.Email);

		Test.startTest();
			ApexPages.currentPage().getParameters().put('id', presupuestos.Id);
			sendQuoteNew sendDS3 = new sendQuoteNew();
			sendDS3.verifySend = true;
			sendDS3.SendNow();

		Test.stopTest();

	}
	
}