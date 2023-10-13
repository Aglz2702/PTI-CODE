@isTest
public class TestSendInvoiceController {
    @isTest static void test_method_one() {
        Folder f = [Select Id,Name from Folder WHERE Name='Shared Documents' LIMIT 1];
        
        Document d = new Document();
        d.Name = 'Logo pti';
        d.FolderId = f.Id;
        blob body = blob.valueOf('Test');
        d.Body = body;//EncodingUtil.base64Encode(Blob.valueof('myString'));
        insert d;
        
        Document d2 = new Document();
        d2.Name = 'flecha';
        d2.FolderId = f.Id;
        blob body2 = blob.valueOf('Test');
        d2.Body = body2;//EncodingUtil.base64Encode(Blob.valueof('myString'));
        insert d2;
        
        Document d3 = new Document();
        d3.Name = 'in grueso';
        d3.FolderId = f.Id;
        blob body3 = blob.valueOf('Test');
        d3.Body = body3;//EncodingUtil.base64Encode(Blob.valueof('myString'));
        insert d3;
        
        Document d4 = new Document();
        d4.Name = 'fb grueso';
        d4.FolderId = f.Id;
        blob body4 = blob.valueOf('Test');
        d4.Body = body4;//EncodingUtil.base64Encode(Blob.valueof('myString'));
        insert d4;
        
        Document d5 = new Document();
        d5.Name = 'web grueso';
        d5.FolderId = f.Id;
        blob body5 = blob.valueOf('Test');
        d5.Body = body5;//EncodingUtil.base64Encode(Blob.valueof('myString'));
        insert d5;
        
        Cost_centers__c cc = new Cost_centers__c(Name = '404', Folio__c	 = 'xxx-xxx-xxx-');
		insert cc;
        
        Account testAcc = new Account();
		testAcc.Name = 'Test';
		testAcc.Customer_keyword__c = 'test id';
		insert testAcc;
        
        Contact contacto = new Contact();
        contacto.FirstName = 'Emmanuel';
        contacto.LastName = 'Gonzalez';
        contacto.AccountId = testAcc.Id;
        contacto.Status__c = 'Active';
        contacto.Email = 'egonzalez@ptiqcs.com';
        contacto.Type__c = 'Customer';
        insert contacto;
        
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
        
        Purchase_order__c po = new Purchase_order__c();
        po.Customer__c = testAcc.Id;
        po.Name = 'test';
        po.Payment_terms__c = 30;
        po.Account_Billable_Contact__c = contacto.Id;
        po.Reception_date__c = date.today();
        po.Total_amount__c = 5000;
        po.Status__c = 'Approved';
        insert po;
        
        invoice__c invoice = new invoice__C();
        invoice.Work_order__c = wo.Id;
        invoice.Purchase_order__c = po.Id;
        invoice.Status__c = 'Pending';
        invoice.ContactId__c = contacto.Id;
        invoice.PTI_Invoice_number__c = 'test12';
        insert invoice;
        
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'test12',
                    PathOnClient   = 'test12.PDF',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;

            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = invoice.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        
        Test.startTest();
        
        
        PageReference pageRef = Page.SendInvoice;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('id', invoice.id);
		//ApexPages.StandardController sc = new ApexPages.StandardController(wo);
        SendInvoiceController sendI = new SendInvoiceController();
        sendI.verifySend = true;
        sendI.SendInvoice();
		Test.stopTest();
    
    }
    
}