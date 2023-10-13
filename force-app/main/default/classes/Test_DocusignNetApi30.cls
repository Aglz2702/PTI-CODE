/**
 *  @Name           TestContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Rodolfo Ramirez <rodolfo@doitcloud.consulting>
 *  @Description    Test method for DocusignNetApi30 class
**/
@isTest
private class Test_DocusignNetApi30 {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30 parentObject = new DocusignNetApi30();
		new DocusignNetApi30.AddressInformation();
		new DocusignNetApi30.AddressInformationInput();
		new DocusignNetApi30.AnchorTab();
		new DocusignNetApi30.ArrayOfAttachment();
		new DocusignNetApi30.ArrayOfCompositeTemplate();
		new DocusignNetApi30.ArrayOfCustomField();
		new DocusignNetApi30.ArrayOfDocument();
		new DocusignNetApi30.ArrayOfDocumentStatus();
		new DocusignNetApi30.ArrayOfEnvelopeEvent();
		new DocusignNetApi30.ArrayOfFormDataXfdfField();
		new DocusignNetApi30.ArrayOfInlineTemplate();
		new DocusignNetApi30.ArrayOfMatchBox();
		new DocusignNetApi30.ArrayOfRecipient();
		new DocusignNetApi30.ArrayOfRecipient1();
		new DocusignNetApi30.ArrayOfRecipientStatus();
		new DocusignNetApi30.ArrayOfServerTemplate();
		new DocusignNetApi30.ArrayOfString();
		new DocusignNetApi30.ArrayOfString1();
		new DocusignNetApi30.ArrayOfTab();
		new DocusignNetApi30.ArrayOfTabStatus();
		new DocusignNetApi30.ArrayOfTemplateReference();
		new DocusignNetApi30.ArrayOfTemplateReferenceFieldDataDataValue();
		new DocusignNetApi30.ArrayOfTemplateReferenceRoleAssignment();
		new DocusignNetApi30.Attachment();
		new DocusignNetApi30.AuthenticationStatus();
		new DocusignNetApi30.CompositeTemplate();
		new DocusignNetApi30.CreateAndSendEnvelope_element();
		new DocusignNetApi30.CreateAndSendEnvelopeResponse_element();
		new DocusignNetApi30.CreateEnvelope_element();
		new DocusignNetApi30.CreateEnvelopeFromTemplates_element();
		new DocusignNetApi30.CreateEnvelopeFromTemplatesAndForms_element();
		new DocusignNetApi30.CreateEnvelopeFromTemplatesAndFormsResponse_element();
		new DocusignNetApi30.CreateEnvelopeFromTemplatesResponse_element();
		new DocusignNetApi30.CreateEnvelopeResponse_element();
		new DocusignNetApi30.CustomField();
		new DocusignNetApi30.DOBInformation();
		new DocusignNetApi30.DOBInformationInput();
		new DocusignNetApi30.Document();
		new DocusignNetApi30.DocumentStatus();
		new DocusignNetApi30.Envelope();
		new DocusignNetApi30.EnvelopeEvent();
		new DocusignNetApi30.EnvelopeInformation();
		new DocusignNetApi30.EnvelopeStatus();
		new DocusignNetApi30.EventNotification();
		new DocusignNetApi30.EventResult();
		new DocusignNetApi30.Expirations();
		new DocusignNetApi30.FormData();
		new DocusignNetApi30.FormDataXfdf();
		new DocusignNetApi30.FormDataXfdfField();
		new DocusignNetApi30.IDCheckInformation();
		new DocusignNetApi30.IDCheckInformationInput();
		new DocusignNetApi30.InlineTemplate();
		new DocusignNetApi30.MatchBox();
		new DocusignNetApi30.Notification();
		new DocusignNetApi30.PDFMetaDataTemplate();
		new DocusignNetApi30.Recipient();
		new DocusignNetApi30.RecipientCaptiveInfo();
		new DocusignNetApi30.RecipientPhoneAuthentication();
		new DocusignNetApi30.RecipientSignatureInfo();
		new DocusignNetApi30.RecipientStatus();
		new DocusignNetApi30.RecipientStatusEsignAgreementInformation();
		new DocusignNetApi30.Reminders();
		new DocusignNetApi30.RequestRecipientFaxToken_element();
		new DocusignNetApi30.RequestRecipientToken_element();
		new DocusignNetApi30.RequestRecipientTokenAuthenticationAssertion();
		new DocusignNetApi30.RequestRecipientTokenClientURLs();
		new DocusignNetApi30.RequestRecipientTokenResponse_element();
		new DocusignNetApi30.RequestSenderToken_element();
		new DocusignNetApi30.RequestSenderTokenResponse_element();
		new DocusignNetApi30.SendEnvelope_element();
		new DocusignNetApi30.SendEnvelopeResponse_element();
		new DocusignNetApi30.ServerTemplate();
		new DocusignNetApi30.SSN4Information();
		new DocusignNetApi30.SSN4InformationInput();
		new DocusignNetApi30.SSN9Information();
		new DocusignNetApi30.SSN9InformationInput();
		new DocusignNetApi30.Tab();
		new DocusignNetApi30.TabStatus();
		new DocusignNetApi30.TemplateReference();
		new DocusignNetApi30.TemplateReferenceFieldData();
		new DocusignNetApi30.TemplateReferenceFieldDataDataValue();
		new DocusignNetApi30.TemplateReferenceRoleAssignment();
		new DocusignNetApi30.VaultingDetails();
		new DocusignNetApi30.VaultingOptions();
	}
	@isTest static void coverCodeForCreateAndSendEnvelope(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.CreateAndSendEnvelope(null));
	}
	@isTest static void coverCodeForCreateEnvelope(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.CreateEnvelope(null));
	}
	@isTest static void coverCodeForCreateEnvelopeFromTemplates(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.CreateEnvelopeFromTemplates(null, null, null, null));
	}
	@isTest static void coverCodeForCreateEnvelopeFromTemplatesAndForms(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.CreateEnvelopeFromTemplatesAndForms(null, null, null));
	}
	@isTest static void coverCodeForRequestRecipientToken(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.RequestRecipientToken(null, null, null, null, null, null));
	}
	@isTest static void coverCodeForRequestSenderToken(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.RequestSenderToken(null, null, null));
	}
	@isTest static void coverCodeForSendEnvelope(){
		Test.setMock(WebServiceMock.class, new DocusignNetApi30MockImpl());
		DocusignNetApi30.APIServiceSoap testObject = new DocusignNetApi30.APIServiceSoap();
		System.assertEquals(null, testObject.SendEnvelope(null, null));
	}
	
}