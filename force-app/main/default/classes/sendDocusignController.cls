/**
 *  @Name           sendDocusignController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Controller class of the send Docusign visualforce, that has the logic to apply the methods described later
**/

public class sendDocusignController { 
	
	//Elements used to obtain data from the Work Order and its contacts
	public String idWO {get;set;}
	public Work_order__c wo {get;set;}
	public Map<String, Contact_function__c> cfMap {get;set;}
	public String contratName {get;set;}
	
	//Booleans for visualization in the component
	public Boolean verifySend {get;set;}
	public Boolean checkCor {get;set;}
	public Boolean checkProcessE {get;set;}
	public Boolean checkFinance {get;set;}
	public Boolean checkQuality {get;set;}
	public Boolean checkSQA {get;set;}

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
	public sendDocusignController() {
		idWO = ApexPages.currentPage().getParameters().get('id');
		cfMap = new Map<String, Contact_function__c>();
		verifySend = false;
		checkCor = false;
		checkProcessE = false;
		checkFinance = false;
		checkSQA = false;
		checkQuality = false;

		wo = [SELECT Id, Name, Account_Name__c, Customer__r.Name, Start_date__c, Project_Id__c, Type__c 
		      FROM Work_order__c WHERE Id =: idWO];

		for( Contact_function__c cf : [SELECT Id, Role__c, Contact_email__c, Contact_type__c, Contact__r.Name FROM Contact_function__c
				  WHERE Work_order__c =: idWO ]){

			if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Process engineer'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Finance' && cf.Contact_type__c == 'Customer'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'SQA'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Coordinator'){
				cfMap.put(cf.Role__c, cf);
			}else if(!cfMap.containsKey(cf.Role__c) && cf.Role__c == 'Quality'){
				cfMap.put(cf.Role__c, cf);
			}

		}

		if(cfMap.containsKey('Coordinator'))
			checkCor = true;
		if(cfMap.containsKey('Process engineer'))
			checkProcessE = true;
		if(cfMap.containsKey('Finance'))
			checkFinance = true;
		if(cfMap.containsKey('SQA'))
			checkSQA = true;
		if(cfMap.containsKey('Quality'))
			checkQuality = true;
	}

	public PageReference SendNow(){
		if(verifySend && checkFinance){
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
			envelope.Subject = 'Work Order Authorization: ' + wo.Name;
			
			//envelope.EmailBlurb = 'This is my new eSignature service,' + ' it allows me to get your signoff without having to fax, ' + 'scan, retype, refile and wait forever';
			String mensaje = 'Dear Customer:\n\nYou are receiving this email due to your company being placed on a 3CPR Level 1 or Level 2 by FCA. As a result, PTI has been instructed to initiate containment process on your behalf. PTI is committed to provide the best class service for your company. Please sign DocuSign with the terms of service within 24 hours of project initiation, it’s a requirement to continue whit the project that has been initiated.\n\n';
			mensaje += 'Thank you for all your support!\n\nThe PTI Team.\n\n——————————————————————————————\n\n';
			mensaje += 'Estimado cliente:\n\nEstá recibiendo este correo electrónico debido a que su empresa se encuentra en un 3CPR Nivel 1 o Nivel 2 por FCA. Como resultado, PTI recibió instrucciones de iniciar un proceso de contención en su nombre. PTI se compromete a proporcionar el mejor servicio de clase para su empresa. Firme DocuSign con los términos del servicio dentro de las 24 horas posteriores al inicio del proyecto, es un requisito continuar con el proyecto que se ha iniciado.\n\n';
			mensaje += 'Gracias por todo su apoyo!\n\nEl equipo de PTI.';
            envelope.EmailBlurb = mensaje;
 
			envelope.AccountId  = accountId;
			envelope.EnvelopeIdStamping = false;
			ContentVersion cv = new ContentVersion();
			

			/**************************************************PRUEBAS DOCUMENTOS SEPARADOS***************************/
			//ContentVersion cvBank = new ContentVersion();
			//ContentVersion cvCertificate = new ContentVersion();

			/*if(wo.Type__c == 'L2'){
				cv = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Policy_2__c 
									AND IsLatest = true LIMIT 1];
				contratName = policies.PolicyName2__c;
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];

				cvCertificate = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Certificate__c 
									AND IsLatest = true LIMIT 1];
				System.debug('Es L2');
			}else if(wo.Type__c == 'L1'){
				cv = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Policy_1__c	
									 AND IsLatest = true LIMIT 1];
				contratName = policies.PolicyName1__c;
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];

				cvCertificate = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Certificate__c 
									AND IsLatest = true LIMIT 1];
				System.debug('Es L1');
			}else{
				cvBank = [SELECT ID, VersionData FROM ContentVersion WHERE ContentDocumentId =: policies.Bank__c 
									AND IsLatest = true LIMIT 1];
			}

			*/			
			// Render the document
			System.debug('Rendering the document');
			PageReference pageRef = new PageReference('/apex/dsPDF');
			pageRef.getParameters().put('id', wo.Id);
			pageRef.getParameters().put('idF', cfMap.get('Finance').Id);
			Blob pdfBlob;
			if(Test.isRunningTest()) {
				pdfBlob = Blob.valueOf('Test');
			} else {
				pdfBlob = pageRef.getContent();
			}
			
			// Document
			/*if(wo.Type__c == 'L2' || wo.Type__c == 'L1'){
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
				envelope.Documents.Document = new DocusignNetApi30.Document[4];
				envelope.Documents.Document[0] = document;
				envelope.Documents.Document[1] = document2;
				envelope.Documents.Document[2] = document3;
				envelope.Documents.Document[3] = document4;
			}else{
				DocusignNetApi30.Document document = new DocusignNetApi30.Document();
				document.ID = 1;
				document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
				document.Name = cadena;
				document.FileExtension = 'pdf';
				DocusignNetApi30.Document document2 = new DocusignNetApi30.Document();
				document2.ID = 2;
				document2.pdfBytes = EncodingUtil.base64Encode(cvBank.VersionData);
				document2.Name = policies.BankInfo__c;
				document2.FileExtension = 'pdf';
				envelope.Documents = new DocusignNetApi30.ArrayOfDocument();
				envelope.Documents.Document = new DocusignNetApi30.Document[2];
				envelope.Documents.Document[0] = document;
				envelope.Documents.Document[1] = document2;
			}

			*/
            
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
			DocusignNetApi30.Recipient recipient2 = new DocusignNetApi30.Recipient();
			DocusignNetApi30.Recipient recipient3 = new DocusignNetApi30.Recipient();
			DocusignNetApi30.Recipient recipient4 = new DocusignNetApi30.Recipient();
			DocusignNetApi30.Recipient recipient5 = new DocusignNetApi30.Recipient();

			if(checkSQA){
				//Signer SQA
				
				recipient1.Type_x = 'Signer';
				recipient1.Email = cfMap.get('SQA').Contact_email__c;
				recipient1.UserName = cfMap.get('SQA').Contact__r.Name;
				recipient1.RequireIDLookup = false;
			}

			if(checkQuality){
				//Signer Customer Quality
				
				recipient2.ID = 3;
				recipient2.Type_x = 'Signer';
				recipient2.RoutingOrder = 3;
				recipient2.Email = cfMap.get('Quality').Contact_email__c;
				recipient2.UserName = cfMap.get('Quality').Contact__r.Name;
				recipient2.RequireIDLookup = false;
			}

			if(checkProcessE){
				//Signer Process engineer
				recipient3.Type_x = 'Signer';
				recipient3.Email = cfMap.get('Process engineer').Contact_email__c;
				recipient3.UserName = cfMap.get('Process engineer').Contact__r.Name;
				recipient3.RequireIDLookup = false;
			}

			if(checkCor){
				//Signer Coordinator PM
				recipient4.Type_x = 'Signer';
				recipient4.Email = cfMap.get('Coordinator').Contact_email__c;
				recipient4.UserName = cfMap.get('Coordinator').Contact__r.Name;
				recipient4.RequireIDLookup = false;
			}
			recipient5.Type_x = 'Signer';
			recipient5.Email = cfMap.get('Finance').Contact_email__c;
			recipient5.UserName = cfMap.get('Finance').Contact__r.Name;
			recipient5.RequireIDLookup = false;


			envelope.Recipients = new DocusignNetApi30.ArrayOfRecipient();
			envelope.Recipients.Recipient = new List<DocusignNetApi30.Recipient>();

			

			/*contador para la posición dependiendo de cuantos contactos anexen*/
			Integer cont = 1;


			if(checkSQA){
				recipient1.ID = cont;
				recipient1.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient1);
				cont++;
			}
			if(checkQuality){
				recipient2.ID = cont;
				recipient2.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient2);
				cont++;
			}
			if(checkProcessE){
				recipient3.ID = cont;
				recipient3.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient3);
				cont++;
			}
			if(checkCor){
				recipient4.ID = cont;
				recipient4.RoutingOrder = cont;
				envelope.Recipients.Recipient.add(recipient4);
				cont++;
			}

			recipient5.ID = cont;
			recipient5.RoutingOrder = cont;
			envelope.Recipients.Recipient.add(recipient5);
			
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

			if(checkSQA){
				DocusignNetApi30.Tab tab1 = new DocusignNetApi30.Tab();
				tab1.Type_x = 'SignHere';
				tab1.RecipientID = cont;
				tab1.DocumentID = 1;
				tab1.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab1.AnchorTabItem.AnchorTabString = '-SQA-';
				tab1.AnchorTabItem.YOffset = -37;
				tab1.AnchorTabItem.XOffset = -30;
				cont++;

				envelope.Tabs.Tab.add(tab1);
			}

			if(checkQuality){
				DocusignNetApi30.Tab tab2 = new DocusignNetApi30.Tab();
				tab2.Type_x = 'SignHere';
				tab2.RecipientID = cont;
				tab2.DocumentID = 1;
				tab2.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab2.AnchorTabItem.AnchorTabString = '-Quality-';
				tab2.AnchorTabItem.YOffset = -37;
				tab2.AnchorTabItem.XOffset = -25;
				cont++;

				envelope.Tabs.Tab.add(tab2);
			}

			if(checkProcessE){
				DocusignNetApi30.Tab tab3 = new DocusignNetApi30.Tab();
				tab3.Type_x = 'SignHere';
				tab3.RecipientID = cont;
				tab3.DocumentID = 1;
				tab3.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab3.AnchorTabItem.AnchorTabString = '-Process engineer-';
				tab3.AnchorTabItem.YOffset = -37;
				tab3.AnchorTabItem.XOffset = -5;
				cont++;

				envelope.Tabs.Tab.add(tab3);
			}

			if(checkCor){
				DocusignNetApi30.Tab tab4 = new DocusignNetApi30.Tab();
				tab4.Type_x = 'SignHere';
				tab4.RecipientID = cont;
				tab4.DocumentID = 1;
				tab4.AnchorTabItem = new DocusignNetApi30.AnchorTab();
				tab4.AnchorTabItem.AnchorTabString = '-Coordinator-';
				tab4.AnchorTabItem.YOffset = -37;
				tab4.AnchorTabItem.XOffset = -25;
				cont++;

				envelope.Tabs.Tab.add(tab4);
			}

			DocusignNetApi30.Tab tab5 = new DocusignNetApi30.Tab();
			tab5.Type_x = 'SignHere';
			tab5.RecipientID = cont;
			tab5.DocumentID = 1;
			tab5.AnchorTabItem = new DocusignNetApi30.AnchorTab();
			tab5.AnchorTabItem.AnchorTabString = '-Finance-';
			tab5.AnchorTabItem.YOffset = -37;
			tab5.AnchorTabItem.XOffset = -25;

			envelope.Tabs.Tab.add(tab5);

			//cont--;

			DocusignNetApi30.Tab tab6 = new DocusignNetApi30.Tab();
			tab6.Type_x = 'Custom';
			tab6.CustomTabType = 'Text';
			tab6.RecipientID = cont;
			tab6.DocumentID = 1;
			tab6.AnchorTabItem = new DocusignNetApi30.AnchorTab();
			tab6.AnchorTabItem.AnchorTabString = '-TAX ID-';
			tab6.AnchorTabItem.YOffset = 0;
			tab6.AnchorTabItem.XOffset = 35;

			envelope.Tabs.Tab.add(tab6);
			
			
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
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Make sure all Roles are marked or check the send field so you can send to sign');
			ApexPages.addMessage(myMsg);
            return null;
		}
	}


}