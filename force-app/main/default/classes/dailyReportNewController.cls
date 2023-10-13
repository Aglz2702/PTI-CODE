/**
 *  @Name           ctrlDailyReportComponent
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Visualforce component driver that obtains the necessary information to assemble the PDF 
 					preview
**/
public class dailyReportNewController {

	public String dateRI {get;set;}
	public string idWO {get;set;}
	public Set<Id> partNumberIds {get;set;}
	public Work_order__c workOrder {get;set;}
	public Map<String, List<Inspection_report__c>> inspections {get;set;}
	public Date dateYesterday {get;set;}
	public Map<Id, Part_number__c> partNumbers {get;set;}
    public List<Part_number__c> parts {get;set;}
    public List<Billable_item__c> bItems {get;set;}
    public Work_order__c wOrder {get;set;}

	public dailyReportNewController() {
		idWO = ApexPages.currentPage().getParameters().get('idWO');
		dateRI = ApexPages.currentPage().getParameters().get('date');
		dateYesterday = Date.parse(dateRI);
		workOrder = [SELECT Id, Name, Job_description__c, Problem__c, Global_defects__c, 
		             Global_QTY_Certified__c, Global_standard_hours__c, Global_overtime_hours__c 
		             FROM Work_order__c WHERE Id =: idWO];
        bItems = [SELECT Id, Name, Description__c, Billable_item_price_type__c, Unit_cost__c FROM Billable_item__c WHERE Work_order__c =: idWO ];
        
        wOrder = [SELECT id, Name, Customer__r.Name, Project_Id__c, Type__c, Problem__c, Job_description__c, Start_date__c, 
		          Account_Name__c,Turno__c, Supervisor__c, Inspector__c, Montacargas__c, ImgBuena__c, ImgMalaUno__c, Rate_Definitivo__c, Rate_Estimado__c,Account_billable_contact__c, Customer__c, Customer__r.Billing_name__c, Customer__r.BillingStreet, Customer__r.BillingCity,
		          Customer__r.BillingState, Customer__r.BillingPostalCode, Customer__r.BillingCountry
				  FROM Work_order__c WHERE Id =: idWO];
        parts = [SELECT Id, Name, Part_number__c, Defect_description__c FROM Part_number__c WHERE Work_order__c =: idWO];

		partNumberIds = new Set<Id>();
		inspections = new Map<String, List<Inspection_report__c>>();
		List<Inspection_report__c> ins = new List<Inspection_report__c>();

		ins = [SELECT Part_number__c, Part_number__r.Name,Total_inspected__c, QTY_Certified__c, Total_defects__c, Defects__c,
					  Other_defects__c, Rework__c, Defects_percentage__c, Description__c, Shift__c, Quantity__c, Billable_item__r.Name,
					  Billable_item__r.Billable_Item_Type__c, Date__c, Batch__c FROM Inspection_report__c 
					  WHERE Work_order__c =: idWO AND Date__c =: dateYesterday];
		

		for(Inspection_report__c i : ins){
			if(inspections.containsKey(i.Part_number__c)){
				inspections.get(i.Part_number__c).add(i);
			}else{
				inspections.put(i.Part_number__c, new List<Inspection_report__c>());
				inspections.get(i.Part_number__c).add(i);
			}

			partNumberIds.add(i.Part_number__c);
		}

		partNumbers = new Map<Id, Part_number__c>([SELECT Name, Total_QTY_Certified__c, Total_rework__c, Defect_description__c, 
			                                      Total_inspected__c, Total_defects__c FROM Part_number__c
										          WHERE Id IN: partNumberIds]);
	}
}