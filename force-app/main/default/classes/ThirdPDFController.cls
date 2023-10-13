/**
 *  @Copyright      PTI QCS with the use of DoIT Cloud
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
**/

public class ThirdPDFController {

	public string idWO {get;set;}
	public string idFinance {get;set;}
	public Work_order__c wOrder {get;set;}
	public Contact_function__c cFinance {get;set;}
	public List<Part_number__c> parts {get;set;}
    public List<PO_assignment__c> saldos {get;set;}
	public List<Billable_item__c> bItems {get;set;}
	public List<Contact_function__c> cfList {get;set;}

	//Booleans to verify who is present in the WO (Resident or Supplier's Quality)
	public boolean checkRes {get;set;}

	public Boolean checkCor {get;set;}
	public Boolean checkProcessE {get;set;}
	public Boolean checkSQEMGR {get;set;}
    
    public Decimal Acumulado {get;set;}

	public Integer tamano_tabla {get;set;}

	/*
		Constructor method that prepares what is necessary to show in the PDF of the Work Order that will be sent to sign
	*/
	public ThirdPDFController() {
		checkRes = false;
		checkSQEMGR = false;
		checkProcessE = false;
		checkCor = false;
		tamano_tabla = 100;


		idWO = apexpages.currentpage().getparameters().get('id');
		idFinance = apexpages.currentpage().getparameters().get('idSQEMGR');

		wOrder = [SELECT id, Name, Customer__r.Name, Project_Id__c, Type__c, Problem__c, Job_description__c, Start_date__c, 
		          Account_Name__c, Balance_to_be_invoiced__c, Customer__c, Customer__r.Billing_name__c, Customer__r.BillingStreet, Customer__r.BillingCity,
		          Customer__r.BillingState, Customer__r.BillingPostalCode, Customer__r.BillingCountry,Total_cost__c
				  FROM Work_order__c WHERE Id =: idWO];

		parts = [SELECT Id, Name, Part_number__c, Defect_description__c FROM Part_number__c WHERE Work_order__c =: idWO];
        
         saldos = [SELECT Restante_de_OC__c FROM PO_assignment__c WHERE Work_order__c =: idWO AND Purchase_order__r.Status__c = 'Approved'];
       
        Acumulado = 0;
        for(PO_assignment__c POA:saldos)
        {
            Acumulado+=POA.Restante_de_OC__c;
        }
       Acumulado=wOrder.Total_cost__c-Acumulado;
		
        
		bItems = [SELECT Id, Name, Description__c, Billable_item_price_type__c, Unit_cost__c FROM Billable_item__c WHERE Work_order__c =: idWO ];

		cfList = [SELECT Id FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c =: 'Quality'];

		cFinance = [SELECT Id, Role__c, Contact__r.Name FROM Contact_function__c WHERE Id =: idFinance ]; 

		List<Contact_function__c> SQEMGR_list = new List<Contact_function__c>([SELECT Id FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c =: 'SQEMGR']);
		List<Contact_function__c> process_eng_list = new List<Contact_function__c>([SELECT Id FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c =: 'Process engineer']);
		List<Contact_function__c> coordinador_list = new List<Contact_function__c>([SELECT Id FROM Contact_function__c WHERE Work_order__c =: idWO AND Role__c =: 'Coordinator']);

		Integer cont_contacts = 0;

		if(!cfList.isEmpty()){
			checkRes = true;
			cont_contacts++;
		}
		if(!SQEMGR_list.isEmpty()){
			checkSQEMGR = true;
			cont_contacts++;
		}
		if(!process_eng_list.isEmpty()){
			checkProcessE = true;
			cont_contacts++;
		}
		if(!coordinador_list.isEmpty()){
			checkCor = true;
			cont_contacts++;
		}

		if(cont_contacts != 0){
			tamano_tabla = 25 * cont_contacts;
		}else{
			tamano_tabla = 0;
		}


	}
    
}