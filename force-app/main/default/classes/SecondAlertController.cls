/**
 *  @Name           SecondAlertController
 *  @Copyright      PTI QCS with de use of DoIT
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
 *  @Description    Controller class of the send Docusign visualforce, that has the logic to apply the methods described later
**/

public class SecondAlertController{ 
	
	//Elements used to obtain data from the Work Order and its contacts
	public String idWO {get;set;}
	public Work_order__c wo {get;set;}
	public Map<String, Contact_function__c> cfMap {get;set;}
	public String contratName {get;set;}
	
	//Booleans for visualization in the component
	public Boolean verifySend {get;set;}
	public Boolean checkSQM {get;set;}

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
	public SecondAlertController() {
		idWO = ApexPages.currentPage().getParameters().get('id');
		cfMap = new Map<String, Contact_function__c>();
		verifySend = false;
		checkSQM = false;

		wo = [SELECT Id, Name, Account_Name__c, Customer__r.Name, Start_date__c, Project_Id__c, Type__c,Problem__c
		      FROM Work_order__c WHERE Id =: idWO];

		for( Contact_function__c cf : [SELECT Id, Role__c, Contact_email__c, Contact_type__c, Contact__r.Name FROM Contact_function__c
				  WHERE Work_order__c =: idWO ]){

			if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Process engineer'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Finance' && cf.Contact_type__c == 'Customer'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'SQM'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Coordinator'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Quality'){
				cfMap.put(cf.Role__c, cf);
			}

		}

		if(cfMap.containsKey('SQM'))
			checkSQM = true;
	}

	public PageReference SendNow(){
		if(verifySend && checkSQM){
			DocusignNetApi30.APIServiceSoap dsApiSend = new DocusignNetApi30.APIServiceSoap();
			dsApiSend.endpoint_x = webServiceUrl;
			dsApiSend.timeout_x = 60000;

			//Name of document
			String FO = 'WO';
			Integer A1 = wo.Start_date__c.year();
			String MM = (wo.Start_date__c.month() < 10 ) ? '0'+String.valueOf(wo.Start_date__c.month()) : String.valueOf(wo.Start_date__c.month());
			String DD = (wo.Start_date__c.day() < 10 ) ? '0'+String.valueOf(wo.Start_date__c.day()) : String.valueOf(wo.Start_date__c.day());

			String XX = wo.Name;

			String MAY = wo.Project_Id__c;

			String cadena = FO+'-'+XX+'_'+MAY+'_'+A1+'-'+MM+'-'+DD;

			
			//Set Authentication
			String auth = '<DocuSignCredentials><Username>'+ userId
						 +'</Username><Password>' + password
						 + '</Password><IntegratorKey>' + integratorsKey
						 + '</IntegratorKey></DocuSignCredentials>';
			System.debug('Setting authentication to: ' + auth);
			
			dsApiSend.inputHttpHeaders_x = new Map<String, String>();
			dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
			
			DocusignNetApi30.Envelope envelope = new DocusignNetApi30.Envelope();
			envelope.Subject = 'Continuation of Service Approval: ' + wo.Project_Id__c +' ' +' 24hrs Without Purchase Order';
			
			//envelope.EmailBlurb = 'This is my new eSignature service,' + ' it allows me to get your signoff without having to fax, ' + 'scan, retype, refile and wait forever';
			String mensaje = 'Due to Stellantis supplier policies and 3CPR procedure, You are receiving this document because 24 hours have passed and (' +wo.Customer__r.Name+') failed to provide a Purchase order, for inspection requirement to support the project (' +wo.Project_Id__c+').\n';
            mensaje += 'Under the Stellantis policy, if a purchase order is not submitted,  this may result in inspection activity suspension.\n\n';
            mensaje += 'In case that  you need additional assistance, please contact  Customer Success Quezia Carneiro, qcarneiro@ptiqcs.com, ph +524424761402.\n\n';
			mensaje += '\n\n——————————————————————————————\n\n';
			mensaje += 'Debido a las políticas de proveedores de Stellantis y al procedimiento 3CPR, usted está recibiendo este documento porque pasaron 24 horas y (' +wo.Customer__r.Name+') no proporcionó una orden de compra, como requisito de inspección para respaldar el proyecto (' +wo.Project_Id__c+').\n';
			mensaje += 'Según la política de Stellantis, si no se envía una orden de compra, esto puede resultar en la suspensión de la actividad de inspección.\n\n';
            mensaje += 'En caso de que necesite asistencia adicional, comuníquese con Customer Success Quezia Carneiro, qcarneiro@ptiqcs.com, teléfono +524424761402.\n\n';
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
			PageReference pageRef = new PageReference('/apex/SecondPDF');
			pageRef.getParameters().put('id', wo.Id);
			pageRef.getParameters().put('idSQM', cfMap.get('SQM').Id);
			Blob pdfBlob;
			if(Test.isRunningTest()) {
				pdfBlob = Blob.valueOf('Test');
			} else {
				pdfBlob = pageRef.getContent();
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

			if(checkSQM){
				//Signer SQM
				
				recipient1.Type_x = 'Signer';
				recipient1.Email = cfMap.get('SQM').Contact_email__c;
				recipient1.UserName = cfMap.get('SQM').Contact__r.Name;
				recipient1.RequireIDLookup = false;
			}


			envelope.Recipients = new DocusignNetApi30.ArrayOfRecipient();
			envelope.Recipients.Recipient = new List<DocusignNetApi30.Recipient>();

			

			/*contador para la posición dependiendo de cuantos contactos anexen*/
			Integer cont = 1;


			if(checkSQM){
				recipient1.ID = cont;
				recipient1.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient1);
				cont++;
			}
			
			// FIELDS
			DocusignNetApi30.CustomField field = new DocusignNetApi30.CustomField ();
			field.Name = 'DSFSSourceObjectId';
			field.Value = wo.Id;
			field.Show = 'false';
			
			envelope.CustomFields = new DocusignNetApi30.ArrayOfCustomField();
			envelope.CustomFields.CustomField = new DocusignNetApi30.CustomField[1];
			envelope.CustomFields.CustomField[0] = field;
			
			// Tabs
			envelope.Tabs = new DocusignNetApi30.ArrayOfTab();
			envelope.Tabs.Tab = new List<DocusignNetApi30.Tab>();

			cont = 1;

			if(checkSQM){
				DocusignNetApi30.Tab tab1 = new DocusignNetApi30.Tab();
				tab1.Type_x = 'SignHere';
				tab1.RecipientID = cont;
				tab1.DocumentID = 1;
				tab1.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab1.AnchorTabItem.AnchorTabString = '-SQM-';
				tab1.AnchorTabItem.YOffset = -37;
				tab1.AnchorTabItem.XOffset = -30;
				cont++;

				envelope.Tabs.Tab.add(tab1);
			}
			
			
			System.debug('Calling the API');
			try {
				DocusignNetApi30.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
				
				return new PageReference('/' + wo.Id);
			} catch ( CalloutException e) {
				System.debug('Exception - ' + e );
				ApexPages.addMessages(e);
				return null;
			}
		}else{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please verify that the Send to approve box is selected');
			ApexPages.addMessage(myMsg);
            return null;
		}
	}


}