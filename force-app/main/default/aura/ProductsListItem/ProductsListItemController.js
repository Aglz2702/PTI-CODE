/**
 *  @Name           ProductsListItemController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/
({
	deletePart : function(component, event, helper) {
        //console.log('deletePart')
        var event = component.getEvent("deletePart");
        event.setParams({
            'selectedPart':component.get("v.Product")
        });
        event.fire();
    }
})