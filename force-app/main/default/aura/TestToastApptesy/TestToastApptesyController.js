({
	prueba : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        console.log(toastEvent);
                    toastEvent.setParams({
                        title : 'Registros creados',
                        message: 'Se han creado los Billable Items',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
        toastEvent.fire();
        
    }
})