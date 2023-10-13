/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/
public class CreatePartNumbersController {

    /**
        *  Obtaining the part numbers from the field of the Work Order
    **/
	@AuraEnabled
    public static List<wrapperClass> getProducts(Id WOId) {
        List<wrapperClass> returnwrapperClass = new  List<wrapperClass> ();
        
        Work_order__c wo = [Select Part_numbers__c,Id From Work_order__c where Id=:WOId];
        string sinEspacios;
        if(wo.Part_numbers__c != null){
            sinEspacios = wo.Part_numbers__c.replace(' ','');
            
        }else{
            sinEspacios = '';
        }
        List<string> noParts = sinEspacios.split(';');
        List<Part_number__c> PartN =  new List<Part_number__c>([Select id,Part_number__c From Part_number__c Where Part_number__c IN:noParts and Work_Order__c=:WOId]);
        integer i = 0;
        
        if(!PartN.isEmpty()){
            for(Part_number__c P:PartN){
                integer j = 0;
                for(String s:noParts){
                    if(P.Part_number__c == s){
                        noParts.remove(j);
                        break;
                    }
                    j++;
                }
            }
        }
        if(!noParts.isEmpty()){
            for(String s:noParts){
                wrapperClass temp = new  wrapperClass();
                Part_number__c newS = new Part_number__c(Part_number__c = s,Work_order__c = WOId);
                temp.part = newS;
                temp.PartCount = i;
                returnwrapperClass.add(temp);
                i++;
            }
        }else{
            wrapperClass temp = new  wrapperClass();
            Part_number__c newS = new Part_number__c(Part_number__c = '',Work_order__c = WOId);
            temp.part = newS;
            temp.PartCount = 0;
            returnwrapperClass.add(temp);
        }
        return returnwrapperClass;
    }
    
    /**
        *  Creation of an empty product
    **/
    @AuraEnabled
    public static wrapperClass Product(Id WOId,Integer cont) {
        wrapperClass temp = new  wrapperClass ();
        Part_number__c newP = new Part_number__c();
        newP.Part_number__c = '';
        newP.Work_order__c = WOId;
        temp.part = newP;
        temp.PartCount = cont;
        return temp;
    }
    
    /**
        *  Creation of Parts Number
    **/
    @AuraEnabled
    public static String insertParts(string listW,string defect, string description) {
        List<wrapperClass> stageList = (List<wrapperClass>)JSON.deserialize(listW,List<wrapperClass>.class);
        List<Part_number__c> ListP = new List<Part_number__c>();
        for(wrapperClass wc:stageList){
            
            if(wc.part.Part_number__c != null || wc.part.Part_number__c != '' || !string.isBlank(wc.part.Part_number__c)){
                system.debug('buuu------'+wc.part.Part_number__c+'|');
                wc.part.name = description + '-' + wc.part.Part_number__c;
                wc.part.Defect_description__c = defect;
                wc.part.Part_description__c = description;
                ListP.add(wc.part);
            }
        }
        try{
            insert ListP;
            return 'ok';
        }catch (Exception e){
            return e.getMessage().split(',')[1].split(':')[0];
		}
        
    }
    
    public class wrapperClass{
        @AuraEnabled public Part_number__c part{get;set;}
        @AuraEnabled public Integer PartCount{get;set;}
    }
}