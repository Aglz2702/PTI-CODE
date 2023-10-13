/**
 *  @Name           ctrlDailyReportComponent
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Visualforce component driver that obtains the necessary information to assemble the PDF 
 					preview
**/
public class KOMPDFPreviewController {

	public string idKOM {get;set;}
	public KOM__c KOM {get;set;}
	public List<Part_number__c> parts {get;set;}
	public List<Billable_item__c> bItems {get;set;}
	public List<Contact_function__c> cfList {get;set;}

	public KOMPDFPreviewController() {
		idKOM = ApexPages.currentPage().getParameters().get('idKOM');

		KOM = [SELECT Id, Name,Work_order__c,Project_Description__c,Project_Number__c,Supplier_Plant_Location__c,Creation_Date__c,Cuenta__r.Name,Main_Contact__r.Name,Special_Instructions__c,Additional_Comments__c,Certification_Mark__c,Characteristics_to_inspect__c FROM KOM__c WHERE Id =: idKOM];

        parts = [SELECT Id, Name, Part_number__c, Defect_description__c FROM Part_number__c WHERE Work_order__c =: KOM.Work_order__c];

        bItems = [SELECT Id, Name, Description__c, Billable_item_price_type__c, Unit_cost__c FROM Billable_item__c WHERE Work_order__c =: KOM.Work_order__c ];

       cfList = new List<Contact_function__c>([SELECT Id,Contact__r.Name,Role__c,Contact_type__c,Customer__r.Name FROM Contact_function__c WHERE Work_order__c =: KOM.Work_order__c]);

	}
}