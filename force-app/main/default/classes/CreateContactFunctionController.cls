/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

public class CreateContactFunctionController {
    
	@AuraEnabled
    public static List<Account> getPicklistValues() {
        List<Account> acc = new List<Account>([Select Id, Name From Account Where Name like 'PTI %']);
        return acc;
    }
    
    @AuraEnabled
    public static Map<String,List<ContacWrapper>> getContacts(id idWO) {
        Map<string,List<ContacWrapper>> contacts = new Map<string,List<ContacWrapper>>();
        List<Contact_function__c> ContFunc = new List<Contact_function__c>([Select id,Contact__c From Contact_function__c Where Work_order__c =: idWO]);
        List<Id> idsExisting = new List<Id>();
        for(Contact_function__c cf:ContFunc){
            idsExisting.add(cf.Contact__c);
        }
        List<Work_order__c> wo = new List<Work_order__c>([Select id,Name,Customer__c From Work_order__c Where id =: idWO Limit 1]);
        List<ContacWrapper> cwCustomer = new List<ContacWrapper>();
        List<Contact> customer = new List<Contact>([Select Id, Name, Type__c, Role__c,Account.Name,AccountId From Contact Where AccountId =: wo[0].Customer__c AND (Id  NOT IN: idsExisting) AND Status__c = 'Active']);
        for(Contact c:customer){
			ContacWrapper cwtemp = new ContacWrapper();
            cwtemp.send = true;
            cwtemp.create = false;
            cwtemp.cont = c;
            cwtemp.woNotification = true;
            cwCustomer.add(cwtemp);
        }
        List<ContacWrapper> cwPTI = new List<ContacWrapper>();
        List<Contact> PTI = new List<Contact>([Select Id, Name, Type__c, Role__c, Email From Contact Where Account.Name like 'PTI %' AND (Id  NOT IN: idsExisting) AND Status__c = 'Active']);
        for(Contact c:PTI){
			ContacWrapper cwtemp = new ContacWrapper();
            cwtemp.send = true;
            cwtemp.create = false;
            cwtemp.cont = c;
            cwtemp.woNotification = true;
            cwPTI.add(cwtemp);
        }
        contacts.put('Customer',cwCustomer);
        contacts.put('PTI',cwPTI);
        return contacts;
    }
    
    @AuraEnabled
    public static String saveFunctionContacts(String listW,Id idWO){
        List<List<ContacWrapper>> WrapperList = (List<List<ContacWrapper>>)JSON.deserialize(listW,List<List<ContacWrapper>>.class);
        List<Contact_function__c> contactFunctions = new List<Contact_function__c>();
        for(List<ContacWrapper> LW:WrapperList){
            for(ContacWrapper w:LW){
                if(w.create == true){
                    Contact_function__c cf = new Contact_function__c();
                    cf.Contact__c = w.cont.Id;
                    cf.Customer__c = w.cont.AccountId;
                    cf.Send_daily_email__c = w.send;
                    cf.Work_order__c = idWO;
                    cf.Send_Notification__c = w.woNotification;
                    contactFunctions.add(cf);
                }
            }
        }
        try{
            insert contactFunctions;
            return 'ok';
        }catch (Exception e){
            return e.getMessage().split(',')[0].split(':')[1] + e.getMessage().split(',')[1].split(':')[2];// + e.getMessage().split(',')[1].split(':')[2];
		}
    }
        
    public class ContacWrapper{
        @AuraEnabled public Boolean create{get;set;}
        @AuraEnabled public Contact cont{get;set;}
        @AuraEnabled public Boolean send{get;set;}
        @AuraEnabled public Boolean woNotification{get;set;}
    }
}