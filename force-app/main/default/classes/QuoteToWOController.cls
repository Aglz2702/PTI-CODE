public class QuoteToWOController {
 
    public Quote Quo {get;set;}
    public Quote presupueto {get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public QuoteToWOController(ApexPages.StandardController stdController) {
        this.Quo = (Quote)stdController.getRecord();
        presupueto = [
            SELECT Id, Name, AccountId, Service_Description__c, Subject__c
            FROM Quote
            WHERE Id =: Quo.Id
        ];
        

    }
    public PageReference Guardar() {
        
        Work_order__c wo = new Work_order__c();
        wo.Name = presupueto.Name;
		wo.Status__c = 'Draft';
        wo.Customer__c = presupueto.AccountId;
        wo.Problem__c = presupueto.Service_Description__c;
        wo.Job_description__c = presupueto.Subject__c;

		insert wo;
        
        PageReference woPage = new ApexPages.StandardController(wo).view();
        woPage.setRedirect(true);
        return woPage;
    }

}