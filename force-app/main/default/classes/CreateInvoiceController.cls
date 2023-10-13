/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/
public with sharing class CreateInvoiceController {

	public Id IdWO {get;set;}
	public Map<String,InsRepClass> InsRepList {get;set;}
	public Work_order__c WorkOrder {get;set;}
	public Invoice__c Invoice {get;set;}
	public Map<String,Boolean> All {get;set;}
	public List<SelectOption> POOptionsG {get;set;}
	public String PickOpSelect {get;set;} 
	public String PickOpSelectUnit {get;set;} 
	public Id POAssig {get;set;} 
	public String PTIBillingName {get;set;}
	public Decimal RemainingAmount {get;set;} 
	public Decimal GlobalTotal {get;set;}
	public Map<Id,Purchase_order__c> POList {get;set;}
	public String ErrorMessage {get;set;}
	public Boolean ShowErrorMessage {get;set;}

	public CreateInvoiceController() {
		IdWO = ApexPages.currentPage().getParameters().get('id');
		WorkOrder = [Select Id, Name, Customer__c, Customer__r.ShippingCity, Customer__r.ShippingCountry, Customer__r.ShippingPostalCode,
			Customer__r.ShippingState, Customer__r.ShippingStreet, Customer__r.BillingCity, Customer__r.BillingCountry, Customer__r.BillingPostalCode,
			Customer__r.BillingState, Customer__r.BillingStreet, Customer__r.IVA_applies__c, Customer__r.Billing_name__c, Cost_center__c
			 From Work_order__c Where Id =: IdWO Limit 1];
		Invoice = new Invoice__c();
		Invoice.Work_order__c = IdWO;
		All = new Map<String,Boolean>();
		InsRepList =  new map<String,InsRepClass>();
		PickOpSelect ='';
		RemainingAmount = 0.0.setScale(2);
		GlobalTotal = 0.0.setScale(2);
		ShowErrorMessage = False;
		ErrorMessage = '';

		List<Inspection_report__c> InsRepListTemp = new List<Inspection_report__c>([Select Id, Name, Invoiced__c, Quantity__c, Part_number__r.Name,
		 	Date__c, Billable_item__r.Unit_cost__c, Billable_item__r.Name, Billable_item__c
		  	From Inspection_report__c Where Work_order__c =: IdWO AND Invoiced__c = False Order By Billable_item__r.Name]);
		List<String> Type = new List<String>();
		for(Inspection_report__c IRL:InsRepListTemp){
			if(!Type.contains(IRL.Billable_item__r.Name)){
				Type.add(IRL.Billable_item__r.Name);
			}
		}
		for(String t:Type){
			if(!InsRepList.containsKey(t)) {
	        	InsRepList.put(t, new InsRepClass());
	       	}
			for(Inspection_report__c IRL:InsRepListTemp){
				if(t == IRL.Billable_item__r.Name){
					InsRepList.get(t).InsRepMap.put(IRL.Id,IRL);
					InsRepList.get(t).UnitPrice = IRL.Billable_item__r.Unit_cost__c;
				}
			}
			if(!All.containsKey(t)) {
				All.put(t, False);
			}
		}
		POOptionsG = POList();
	}

	/**
 		*  Function to show in the picklist of the Purchase order
	**/
	public List<SelectOption> POList(){
		List<PO_assignment__c> poas = [SELECT Id, Purchase_order__c FROM PO_assignment__c WHERE Work_order__c =: IdWO];
		Set<Id> pos = new Set<Id>();
		List<SelectOption> POOptions = new List<SelectOption>();
		POOptions.add(new SelectOption('000000000000000000','---None---'));
		if(!poas.isEmpty()){
			for(PO_assignment__c poa : poas){
				pos.add(poa.Purchase_order__c);
			}
			POList = new Map<Id,Purchase_order__c>([Select Id, Name ,Remaining_amount__c, Payment_terms__c, PTI_billing_name__c From Purchase_order__c 
				Where Id IN: pos AND Remaining_amount__c > 100 AND Status__c = 'Approved']);
			for(Id Idpo:POList.keySet()){
				POOptions.add(new SelectOption(POList.get(Idpo).Id,POList.get(Idpo).Name));
			}
		}
		return POOptions;
	}

	/**
 		*  	Function to select or deselect all inspection records listed by billable item,
 		*	sum or subtraction for the price total of the inspection records selected or deselected
 		*	as well as the addition or subtraction to the global price
	**/
	public void SelectAll(){
		ErrorMessage = '';
		ShowErrorMessage = False;
		for(Id IR:InsRepList.get(PickOpSelect).InsRepMap.keySet()){
			if(All.get(PickOpSelect)){
				if(!InsRepList.get(PickOpSelect).InsRepMap.get(IR).Invoiced__c){
					InsRepList.get(PickOpSelect).InsRepMap.get(IR).Invoiced__c = True;
				}
			}else{
				if(InsRepList.get(PickOpSelect).InsRepMap.get(IR).Invoiced__c){
					InsRepList.get(PickOpSelect).InsRepMap.get(IR).Invoiced__c = False;
				}
			}
		}
	}


	public void calculate(){
		ErrorMessage = '';
		ShowErrorMessage = False;
		GlobalTotal=0.0.setScale(2);
		for(String IRT:InsRepList.keySet()){
			Decimal total = 0.0;
			for(Id IR:InsRepList.get(IRT).InsRepMap.keySet()){
				Decimal sum = 0.0;
				if(InsRepList.get(IRT).InsRepMap.get(IR).Invoiced__c){
					sum = (InsRepList.get(IRT).InsRepMap.get(IR).Quantity__c * InsRepList.get(IRT).InsRepMap.get(IR).Billable_item__r.Unit_cost__c);
						InsRepList.get(IRT).Quantity += InsRepList.get(IRT).InsRepMap.get(IR).Quantity__c;
						total += sum;
						GlobalTotal += sum.setScale(2);
				}
			}
			InsRepList.get(IRT).Total = total.setScale(2);
		}
	}

	/**
 		*  	Function to show the remaining amount of the purchase order selected
	**/
	public void POAssignment(){
		if(Invoice.Purchase_order__c != '000000000000000000'){
			RemainingAmount = POList.get(Invoice.Purchase_order__c).Remaining_amount__c;
			PTIBillingName = POList.get(Invoice.Purchase_order__c).PTI_billing_name__c;
		}else{
			RemainingAmount = 0.0;
		}
	}

	/**
 		*  	Function to create invoice and concepts
	**/
	public PageReference Save(){
		ErrorMessage = '';
		ShowErrorMessage = False;
		Decimal IVA = 0.16;
		PageReference pageRef;
		if(Invoice.Purchase_order__c != '000000000000000000' && Invoice.Creation_date__c != null){
			if(GlobalTotal > 0){
				if(GlobalTotal <= POList.get(Invoice.Purchase_order__c).Remaining_amount__c){
					List<Inspection_report__c> UpdateList = new List<Inspection_report__c>();
					List<Concept__c> CreateConcept = new List<Concept__c>();
					Invoice.Sub_total__c = GlobalTotal;
					Invoice.Customer_billing_name__c = WorkOrder.Customer__r.Billing_name__c;
					Invoice.PTI_billing_name__c = PTIBillingName;
					Invoice.Shipping_city__c = WorkOrder.Customer__r.ShippingCity;
					Invoice.Shipping_country__c = WorkOrder.Customer__r.ShippingCountry;
					Invoice.Shipping_postal_code__c = WorkOrder.Customer__r.ShippingPostalCode;
					Invoice.Shipping_state__c = WorkOrder.Customer__r.ShippingState;
					Invoice.Shipping_street__c = WorkOrder.Customer__r.ShippingStreet;
					Invoice.Billing_city__c = WorkOrder.Customer__r.BillingCity;
					Invoice.Billing_country__c = WorkOrder.Customer__r.BillingCountry;
					Invoice.Billing_postal_code__c = WorkOrder.Customer__r.BillingPostalCode;
					Invoice.Billing_state__c = WorkOrder.Customer__r.BillingState;
					Invoice.Billing_street__c = WorkOrder.Customer__r.BillingStreet;
					Invoice.Cost_center__c	= WorkOrder.Cost_center__c;
					Invoice.Due_date__c = Invoice.Creation_date__c + integer.valueOf(POList.get(Invoice.Purchase_order__c).Payment_terms__c);
					if(WorkOrder.Customer__r.IVA_applies__c){
						Invoice.IVA__c = 16;
						Invoice.Total__c = GlobalTotal+(GlobalTotal*IVA);
					}else{
						Invoice.IVA__c = 0;
						Invoice.Total__c = GlobalTotal;
					}
					Insert Invoice;
					pageRef = new PageReference('/'+Invoice.Id);
					for(String MapPrincial:InsRepList.keySet()){
						Boolean cont = false;
						for(Id MapSecondary:InsRepList.get(MapPrincial).InsRepMap.keySet()){
							if(InsRepList.get(MapPrincial).InsRepMap.get(MapSecondary).Invoiced__c){
								InsRepList.get(MapPrincial).InsRepMap.get(MapSecondary).Invoice__c = Invoice.Id;
								UpdateList.add(InsRepList.get(MapPrincial).InsRepMap.get(MapSecondary));
								InsRepList.get(MapPrincial).InsRepMap.remove(MapSecondary);
								cont = true;
							}
						}
						if(cont){
							Concept__c tempConcept = new Concept__c();
							tempConcept.Name = MapPrincial;
							tempConcept.Quantity__c = InsRepList.get(MapPrincial).Quantity;
							tempConcept.Unit_price__c = InsRepList.get(MapPrincial).UnitPrice;
							tempConcept.Invoice__c = Invoice.Id;
							CreateConcept.add(tempConcept);
						}
					}
					Insert CreateConcept;
					Update UpdateList;
					return pageRef ;
				}else{
					ErrorMessage = Label.Validation_error_1;
					ShowErrorMessage = True;
				}
			}else{
				ErrorMessage = Label.Validation_error_2;
				ShowErrorMessage = True;
			}
		}else{
			ErrorMessage = Label.Validation_error_3;
			ShowErrorMessage = True;
		}
		return null;
	}

	public class InsRepClass{
        public Map<Id,Inspection_report__c> InsRepMap {get;set;}
        public Decimal Total {get;set;}
        public Decimal Quantity {get;set;}
        public Decimal UnitPrice {get;set;}
        public InsRepClass(){
        	InsRepMap = new Map<Id,Inspection_report__c>();
        	Total = 0.0.setScale(2);
        	Quantity = 0.0.setScale(2);
        	UnitPrice = 0.0.setScale(2);
        }
    }
}