/**
 *  @Name           CreateNewWO
 *  @Copyright      PTI QCS
 *  @Author         Emmanuel Gonzalez Lopez <egonzalez@ptiqcs.com>
 *  @Description    Class control the new WO
**/

public class CreateNewWO {
    
    //Elements used to obtain data from the Work Order and its contacts
	public String idPresu {get;set;}
    public Quote Presupuestos {get;set;}
    public Contact contactos {get;set;}
    
    public CreateNewWO() {
        
        idPresu = ApexPages.currentPage().getParameters().get('id');
        
        presupuestos = [SELECT Id, Name,Contacto_Envio__c,Email,Start_date__c FROM Quote WHERE Id =: idPresu];
        
        
    }

}