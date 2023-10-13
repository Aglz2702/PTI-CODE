/**
 *  @Name           SendQuoteController
 *  @Copyright      PTI QCS with the use of DoIt Cloud
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
 *  @Description    Controller class of the send Docusign visualforce
**/

public class SendQuoteController { 
	
	//Elements used to obtain data from the Work Order and its contacts
	public String idPresu {get;set;}
    public Quote Presupuestos {get;set;}
    public Contact contactos {get;set;}
	public String contratName {get;set;}
    public Map<String, Contact> cfMap {get;set;}
	
	//Booleans for visualization in the component
	public Boolean verifySend {get;set;}
	public Boolean checkCOTIZACION {get;set;}

	//Variables that are obtained from a custom setting
	private DocuSignSetup__c dsSetup = DocuSignSetup__c.getOrgDefaults();
	private PTI_Policies__c policies = PTI_Policies__c.getOrgDefaults();
	private String accountId = dsSetup.AccountId__c; 
	private String userId = dsSetup.UserId__c;
	private String password = dsSetup.Password__c; 
	private String integratorsKey = dsSetup.IntegratorsKey__c; 
	private String webServiceUrl = dsSetup.WebserviceURL__c; 

	/*
		Method constructor that prepares what is necessary to show in the component what is currently used 
		to send the work order to sign
	*/
	public SendQuoteController() {
		idPresu = ApexPages.currentPage().getParameters().get('id');
        cfMap = new Map<String, Contact>();
		verifySend = false;
		checkCOTIZACION = false;

		presupuestos = [SELECT Id, Name,ContactId,Contact.Name,Contact.Email,Start_date__c,QuoteNumber,Account.Name FROM Quote WHERE Id =: idPresu];

        system.debug(presupuestos.Contact.email);
		if(String.isBlank(presupuestos.ContactId))
        {
            checkCOTIZACION = false;
        }else{
            checkCOTIZACION = true;
        }
			
	}

	public PageReference SendNow(){
		if(verifySend && checkCOTIZACION){
			DocusignNetApi30.APIServiceSoap dsApiSend = new DocusignNetApi30.APIServiceSoap();
			dsApiSend.endpoint_x = webServiceUrl;
			dsApiSend.timeout_x = 60000;

			//Name of document
			/* String FO = 'QUOTE';
			Integer A1 = presupuestos.Start_date__c.year();
			String MM = (presupuestos.Start_date__c.month() < 10 ) ? '0'+String.valueOf(presupuestos.Start_date__c.month()) : String.valueOf(presupuestos.Start_date__c.month());
			String DD = (presupuestos.Start_date__c.day() < 10 ) ? '0'+String.valueOf(presupuestos.Start_date__c.day()) : String.valueOf(presupuestos.Start_date__c.day());

			String XX = presupuestos.Name;

			String cadena = FO+'-'+XX+'_'+A1+'-'+MM+'-'+DD;
			*/
            String cadena = 'PTIQCS S DE RL DE CV';
			
			//Set Authentication
			String auth = '<DocuSignCredentials><Username>'+ userId
						 +'</Username><Password>' + password
						 + '</Password><IntegratorKey>' + integratorsKey
						 + '</IntegratorKey></DocuSignCredentials>';
			System.debug('Setting authentication to: ' + auth);
			
			dsApiSend.inputHttpHeaders_x = new Map<String, String>();
			dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
			
			DocusignNetApi30.Envelope envelope = new DocusignNetApi30.Envelope();
			envelope.Subject = 'QUOTE N°'+ presupuestos.QuoteNumber + ' ' + presupuestos.Account.Name;
			
			//envelope.EmailBlurb = 'This is my new eSignature service,' + ' it allows me to get your signoff without having to fax, ' + 'scan, retype, refile and wait forever';
			String mensaje = 'Dear:'+ ' ' +presupuestos.Contact.Name+'\n\n';
            mensaje += 'We in PTI QCS are extremely excited about the possibilities that could arise in the near future to demonstrate your company with our capabilities and performance.\n\n';
            mensaje += 'PTI Quality Containment Solutions(“QCS”) is a privately held U.S. based company operating in U.S., Canada, Mexico, China and Korea. QCS core business is to provide warehousing, packaging, labeling, logistics, distribution and rework services to Original Equipment Manufacturers (“OEM’s”) and their respective part suppliers.\n\n';
            mensaje += 'We are currently servicing industry leaders as Stellantis, GM,  Visteon, Lear, Delphi, Dana, AAM, Metaldyne, Benteler (among others) in all cases providing them with products as Tier 1 or Tier 2 being responsible of planning and execution for all logistic functions including bar code labels, error proofing and ASN.\n\n';
            mensaje += 'Our services are top ranked by our existing customers and our proposals are extremely competitive..';
            envelope.EmailBlurb = mensaje;
 
			envelope.AccountId  = accountId;
			envelope.EnvelopeIdStamping = false;
			ContentVersion cv = new ContentVersion();
			

			/**************************************************PRUEBAS DOCUMENTOS SEPARADOS***************************/
			//ContentVersion cvBank = new ContentVersion();
			//ContentVersion cvCertificate = new ContentVersion();
			
            
            //ALMACENAMIENTO DE CONSULTA QUE DEVUELVE EL NOMBRE DEL ARCHIVO
            //cv = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Aprobacion__c 
									//AND IsLatest = true LIMIT 1];
									//contratName = policies.PolicyName2__c;


			/*if(wo.Type__c == 'L10'){
				cv = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Policy_2__c 
									AND IsLatest = true LIMIT 1];
				contratName = policies.PolicyName2__c;
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];

				cvCertificate = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Certificate__c 
									AND IsLatest = true LIMIT 1];
                

				System.debug('Es L10');
			}else if(wo.Type__c == 'L9'){
				cv = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Policy_1__c	
									 AND IsLatest = true LIMIT 1];
				contratName = policies.PolicyName1__c;
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];

				cvCertificate = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Certificate__c 
									AND IsLatest = true LIMIT 1];
                
                cvAprobacion = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Aprobacion__c 
									AND IsLatest = true LIMIT 1];
				System.debug('Es L9');
			}else{
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];
			}*/
						
			// Render the document
			System.debug('Rendering the document');
			PageReference pageRef = new PageReference('/apex/QuoteV2');
			pageRef.getParameters().put('id', presupuestos.Id);
			//pageRef.getParameters().put('idCOTIZACION', cfMap.get('COTIZACION').Id);
			Blob pdfBlob;
			if(Test.isRunningTest()) {
				pdfBlob = Blob.valueOf('Test');
			} else {
				pdfBlob = pageRef.getContent();
				//pdfBlob = Blob.valueOf('Test');
			}
			
			// Document
			/*if(wo.Type__c == 'L10' || wo.Type__c == 'L9'){
				DocusignNetApi30.Document document = new DocusignNetApi30.Document();
				document.ID = 1;
				document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
				document.Name = cadena;
				document.FileExtension = 'pdf';
				DocusignNetApi30.Document document2 = new DocusignNetApi30.Document();
				document2.ID = 2;
				document2.pdfBytes = EncodingUtil.base64Encode(cv.VersionData);
				document2.Name = contratName;
				document2.FileExtension = 'pdf';
				DocusignNetApi30.Document document3 = new DocusignNetApi30.Document();
				document3.ID = 3;
				document3.pdfBytes = EncodingUtil.base64Encode(cvCertificate.VersionData);
				document3.Name = 'Certificate';
				document3.FileExtension = 'pdf';
				DocusignNetApi30.Document document4 = new DocusignNetApi30.Document();
				document4.ID = 4;
				document4.pdfBytes = EncodingUtil.base64Encode(cvBank.VersionData);
				document4.Name = policies.BankInfo__c;
				document4.FileExtension = 'pdf';
				envelope.Documents = new DocusignNetApi30.ArrayOfDocument();
				envelope.Documents.Document = new DocusignNetApi30.Document[5];
				envelope.Documents.Document[0] = document;
				envelope.Documents.Document[1] = document2;
				envelope.Documents.Document[2] = document3;
				envelope.Documents.Document[3] = document4;
			}else{
				DocusignNetApi30.Document document = new DocusignNetApi30.Document();
				document.ID = 1;
				document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
				document.Name = cadena;
				document.FileExtension = 'pdfs';
				DocusignNetApi30.Document document2 = new DocusignNetApi30.Document();
				document2.ID = 2;
				document2.pdfBytes = EncodingUtil.base64Encode(cvBank.VersionData);
				document2.Name = policies.BankInfo__c;
				document2.FileExtension = 'pdfs';
				envelope.Documents = new DocusignNetApi30.ArrayOfDocument();
				envelope.Documents.Document = new DocusignNetApi30.Document[2];
				envelope.Documents.Document[0] = document;
				envelope.Documents.Document[1] = document2;
			}*/
            
            //CONSTRUCCION DEL PRIMER PDF O PRINCIPAL
            DocusignNetApi30.Document document = new DocusignNetApi30.Document();
				document.ID = 1;
				document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
				document.Name = cadena;
				document.FileExtension = 'pdf';

            //ENVIO DE DOCUMENTOS UNO O VARIOS
			envelope.Documents = new DocusignNetApi30.ArrayOfDocument();
			envelope.Documents.Document = new DocusignNetApi30.Document[2];
			envelope.Documents.Document[0] = document;

			
			/*****************************************AQUI TERMINA DOCUMENTOS AÑADIR LÖGICA PARA DIFERENCIAR*****************/

			// Recipient
			System.debug('getting the contact');

			
			//Sign Finance
			 DocusignNetApi30.Recipient recipient1 = new DocusignNetApi30.Recipient();

			if(checkCOTIZACION){
				//Signer SQEMGR
				
				recipient1.Type_x = 'Signer';
				recipient1.Email = presupuestos.Contact.email;
				recipient1.UserName = presupuestos.Contact.Name;
				recipient1.RequireIDLookup = false;
			}


			envelope.Recipients = new DocusignNetApi30.ArrayOfRecipient();
			envelope.Recipients.Recipient = new List<DocusignNetApi30.Recipient>();

			

			/*contador para la posición dependiendo de cuantos contactos anexen*/
			Integer cont = 1;


			 if(checkCOTIZACION){
				recipient1.ID = cont;
				recipient1.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient1);
				cont++;
			}
			
			// FIELDS
			DocusignNetApi30.CustomField field = new DocusignNetApi30.CustomField ();
			field.Name = 'DSFSSourceObjectId';
			field.Value = presupuestos.Id;
			field.Show = 'false';
			
			envelope.CustomFields = new DocusignNetApi30.ArrayOfCustomField();
			envelope.CustomFields.CustomField = new DocusignNetApi30.CustomField[1];
			envelope.CustomFields.CustomField[0] = field;
			
			// Tabs
			envelope.Tabs = new DocusignNetApi30.ArrayOfTab();
			envelope.Tabs.Tab = new List<DocusignNetApi30.Tab>();

			cont = 1;

			 if(checkCOTIZACION){
				DocusignNetApi30.Tab tab1 = new DocusignNetApi30.Tab();
				tab1.Type_x = 'SignHere';
				tab1.RecipientID = cont;
				tab1.DocumentID = 1;
				tab1.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab1.AnchorTabItem.AnchorTabString = '-COTIZACION-';
				tab1.AnchorTabItem.YOffset = -37;
				tab1.AnchorTabItem.XOffset = -30;
				cont++;

				envelope.Tabs.Tab.add(tab1);
			} 
			
			
			System.debug('Calling the API');
			try {
				DocusignNetApi30.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
				
				return new PageReference('/' + presupuestos.Id);
			} catch ( CalloutException e) {
				System.debug('Exception - ' + e );
				ApexPages.addMessages(e);
				return null;
			}
		}else{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Make sure you have a contact and email to send your quote');
			ApexPages.addMessage(myMsg);
            return null;
		}
	}


}