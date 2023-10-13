/**
*  @Name           dsPDFController
*  @Copyright      PTI QCS
*  @Author         Emmanuel Gonzalez <egonzalez@ptiqcs.com>
*  @Description    Controller of the visualforce page that will be used to generate the PDF that will be sent to sign through Docusign
**/

public class dsPDFController {
    public string idWO {get;set;}
    public Work_order__c wOrder {get;set;}
    public List<Part_number__c> parts {get;set;}
    public List<Billable_item__c> bItems {get;set;}
    public List<Contact_function__c> ListaContactos {get;set;}
    public List<Contact_function__c> ListaFinanzas {get;set;}
    public Integer tamanoLista {get;set;}
    
    public dsPDFController() {
        idWO = apexpages.currentpage().getparameters().get('id');
        wOrder = [SELECT id, Name, Customer__r.Name, Project_Id__c, Type__c, Problem__c, Job_description__c, Start_date__c, 
                  Account_Name__c,Turno__c, Supervisor__c, Inspector__c, Montacargas__c, ImgBuena__c, ImgMalaUno__c, Rate_Definitivo__c, Rate_Estimado__c,Estimated_Rate_Type__c,Shift_Type__c,Account_billable_contact__c, Customer__c, Customer__r.Billing_name__c, Customer__r.BillingStreet, Customer__r.BillingCity,
                  Customer__r.BillingState, Customer__r.BillingPostalCode, Customer__r.BillingCountry
                  FROM Work_order__c WHERE Id =: idWO];
        parts = [SELECT Id, Name, Part_number__c, Defect_description__c FROM Part_number__c WHERE Work_order__c =: idWO];
        bItems = [SELECT Id, Name, Description__c, Billable_item_price_type__c, Unit_cost__c FROM Billable_item__c WHERE Work_order__c =: idWO ];
        ListaContactos = [SELECT Contact_email__c,Contact__r.Name,Role__c FROM Contact_function__c WHERE Work_order__c =: idWO ];
        ListaFinanzas = [SELECT Contact_email__c,Contact__r.Name,Role__c FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c='Quality Manager'];
        tamanoLista = ListaContactos.size();
    }
}