/**
 *  @Copyright      PTI QCS with the use of DoIT Cloud
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
**/

public class SendQuotePDFController2 {

	public string idPresu {get;set;}
	public string idFinance {get;set;}
	public List<QuoteLineItem> ParPresu {get;set;}
    
    public Quote Presupuestos {get;set;}
    public Account DetCuenta {get;set;}
    public String Contacto {get;set;}


	//Booleans to verify who is present in the WO (Resident or Supplier's Quality)
	public boolean checkRes {get;set;}
	public Boolean checkCOTIZACION {get;set;}
    
    public Decimal Acumulado {get;set;}

	public Integer tamano_tabla {get;set;}

	/*
		Constructor method that prepares what is necessary to show in the PDF of the Work Order that will be sent to sign
	*/
	public SendQuotePDFController2() {
		checkRes = false;
		checkCOTIZACION = false;
		tamano_tabla = 100;
        
		idPresu = apexpages.currentpage().getparameters().get('id');

		presupuestos = [SELECT Id, Name,Contacto_Envio__c,Intervention_Sites__c,Service_Frecuency__c,Service_Period__c,Service_Description__c,Contact.Name,Email,Start_date__c,Account.Name,GrandTotal,Subtotal,QuoteNumber,Personnel_Requeriments__c,ExpirationDate,AccountId,Payment_Terms__c,Account.Billing_name__c,Account.BillingCountry,Account.BillingCity,Account.BillingState,Account.BillingStreet,Account.BillingPostalCode FROM Quote WHERE Id =: idPresu];
        
        ParPresu = [SELECT Id,Product2Id,ServiceDate,ListPrice,UnitPrice,Quantity,Discount,TotalPrice,Product2.Name FROM QuoteLineItem WHERE QuoteId =: idPresu];
		
        DetCuenta = [SELECT Id,Name,Phone,Customer_keyword__c FROM Account WHERE Id =: presupuestos.AccountId];
	
        Integer cont_contacts = 0;

			checkCOTIZACION = true;

		if(cont_contacts != 0){
			tamano_tabla = 25 * cont_contacts;
		}else{
			tamano_tabla = 0;
		}


	}
    
}