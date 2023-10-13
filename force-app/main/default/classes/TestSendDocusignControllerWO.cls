/**
 *  @Name           Test SendDocusign Controller
 *  @Copyright      PTI QCS WITH THE USE OF DOIT
 *  @Author         Emmanuel Gonzaez <egonzalez@ptiqcs.com>
 *  @Description    Test method for the Visualforce "sendDocusign" and its controlling class
**/

@isTest
private class TestSendDocusignControllerWO {
    
    @isTest static void test_method_one() {
		Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

			ContentVersion conv = new ContentVersion(
				Title = 'Penguins',
      			PathOnClient = 'Penguins.pdf',
	        	VersionData = Blob.valueOf('Test Content: '),
	        	IsMajorVersion = true
			);

		insert conv;

		List<ContentDocument> cdList = [SELECT Id FROM ContentDocument LIMIT 1];

		PTI_Policies__c cs = PTI_Policies__c.getOrgDefaults();
		cs.Policy_1__c = cdList[0].Id;
		cs.PolicyName1__c = 'test';
		cs.Policy_2__c = cdList[0].Id;
		cs.PolicyName2__c = 'test';
		cs.Bank__c = cdList[0].Id;
		cs.BankInfo__c = 'testBank';
		cs.Certificate__c = cdList[0].Id;
        cs.Aprobacion__c = cdList[0].Id;
		upsert cs PTI_Policies__c.Id;
        
		


		Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;

		List<Contact> conList = new List<Contact>();
		List<Contact_function__c> cfList = new List<Contact_function__c>();

		Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';

		insert testAcc;

		Contact con1 = new Contact();
		con1.LastName = 'Tester';
		con1.FirstName = 'Test';
		con1.Email = 'con@correo.com';
		con1.Type__c = 'Customer';
		con1.Role__c = 'SQE';
		con1.AccountId = testAcc.Id;

		conList.add(con1);

		Contact con2 = new Contact();
		con2.LastName = 'Tester';
		con2.FirstName = 'Test';
		con2.Email = 'con@correo.com';
		con2.Type__c = 'Customer';
		con2.Role__c = 'Finance';
		con2.AccountId = testAcc.Id;

		conList.add(con2);

		Contact con3 = new Contact();
		con3.LastName = 'Tester';
		con3.FirstName = 'Test';
		con3.Email = 'con@correo.com';
		con3.Type__c = 'Customer';
		con3.Role__c = 'Quality';
		con3.AccountId = testAcc.Id;

		conList.add(con3);

		Contact con4 = new Contact();
		con4.LastName = 'Tester';
		con4.FirstName = 'Test';
		con4.Email = 'con@correo.com';
		con4.Type__c = 'TPP';
		con4.Role__c = 'Process Engineer';
		con4.AccountId = testAcc.Id;

		conList.add(con4);

		Contact con5 = new Contact();
		con5.LastName = 'Tester';
		con5.FirstName = 'Test';
		con5.Email = 'con@correo.com';
		con5.Type__c = 'TPP';
		con5.Role__c = 'Coordinator';
		con5.AccountId = testAcc.Id;

		conList.add(con5);

		insert conList;


		Work_order__c wo = new Work_order__c();
		wo.Customer__c = testAcc.Id;
		wo.Status__c = 'Draft';
		wo.Name = 'ME';
		wo.Start_date__c = System.today();

		insert wo;

		wo.Cost_center__c = '404';
		wo.Project_Id__c = 'A113';
		wo.Status__c = 'Approved WBS';
		wo.Type__c = 'L1';

		update wo;

		Contact_function__c cf1 = new Contact_function__c();
		cf1.Contact__c = con1.Id;
		cf1.Work_order__c = wo.Id;
		cfList.add(cf1);

		Contact_function__c cf2 = new Contact_function__c();
		cf2.Contact__c = con2.Id;
		cf2.Work_order__c = wo.Id;
		cfList.add(cf2);

		Contact_function__c cf3 = new Contact_function__c();
		cf3.Contact__c = con3.Id;
		cf3.Work_order__c = wo.Id;
		//cfList.add(cf3);

		Contact_function__c cf4 = new Contact_function__c();
		cf4.Contact__c = con4.Id;
		cf4.Work_order__c = wo.Id;
		cfList.add(cf4);

		Contact_function__c cf5 = new Contact_function__c();
		cf5.Contact__c = con5.Id;
		cf5.Work_order__c = wo.Id;
		cfList.add(cf5);

		insert cfList;

		Test.startTest();
			ApexPages.currentPage().getParameters().put('id', wo.Id);
			sendDocusignControllerWO sendDS = new sendDocusignControllerWO();
			sendDS.verifySend = true;
			sendDS.SendNow();

			insert cf3;

			ApexPages.currentPage().getParameters().put('id', wo.Id);
			sendDocusignControllerWO sendDS2 = new sendDocusignControllerWO();
			sendDS2.verifySend = true;
			sendDS2.SendNow();

			delete cf2;

			ApexPages.currentPage().getParameters().put('id', wo.Id);
			sendDocusignControllerWO sendDS3 = new sendDocusignControllerWO();
			sendDS3.verifySend = true;
			sendDS3.SendNow();

		Test.stopTest();

	}

}