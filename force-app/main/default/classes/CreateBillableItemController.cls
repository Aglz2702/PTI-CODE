/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

public class CreateBillableItemController {
	@AuraEnabled
    public static List<ServiceName> getServices(integer pos) {
        List<ServiceName> SN = new List<ServiceName>();
        List<Service__c> serv = new List<Service__c>([Select Name,Type__c,Unit_cost__c,Price_type__c From Service__c ORDER BY Name DESC]);
        for(Service__c s:serv){
            ServiceName servTemp = new ServiceName();
            servTemp.servicio = s;
            servTemp.Position = pos;
            SN.add(servTemp);
        }
        return SN;
    }
    
    @AuraEnabled
    public static string createBI(string listW, Id IdWO) {
        List<BillableItem> stageList = (List<BillableItem>)JSON.deserialize(listW,List<BillableItem>.class);
        List<Billable_item__c> ListServ = new List<Billable_item__c>();
        for(BillableItem BI:stageList){
            Billable_item__c temp = new Billable_item__c();
            temp.Name = BI.Type;
            temp.Billable_item_price_type__c = BI.serviceType;
            temp.Unit_cost__c = BI.Unit_cost;
            temp.Description__c = BI.Description;
            temp.Work_order__c = IdWO;
            /*if(BI.Type == 'Inspection' || BI.Type == 'Inspection OT' ||BI.Type == 'Supervisor' || BI.Type == 'Supervisor OT'){
                temp.Billable_Item_Type__c = 'Hourly';
            }else{
                temp.Billable_Item_Type__c = 'Fixed Price';
            }*/
            temp.Billable_Item_Type__c = BI.PriceType;
            ListServ.add(temp);
        }
        try{
            insert ListServ;
            return 'ok';
        }catch (Exception e)
		{
			return e.getMessage().split(',')[1].split(':')[0];
		}
        
    }
    public class BillableItem{
        @AuraEnabled public string Type{get;set;}
        @AuraEnabled public string serviceType{get;set;}
        @AuraEnabled public string Description{get;set;}
        @AuraEnabled public Decimal Unit_cost{get;set;}
        @AuraEnabled public string  PriceType {get;set;}
    }
    
    public class ServiceName{
        @AuraEnabled public Service__c servicio{get;set;}
        @AuraEnabled public integer Position{get;set;}
    }
}