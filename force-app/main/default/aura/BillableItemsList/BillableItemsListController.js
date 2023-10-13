({
    doInit2 : function(component, event, helper) {
        var opts = [];
        opts.push({
                    class: "optionClass",
                    label: '--- None ---',
                    value: null
                });
        component.find('Type').set("v.options", opts);
    },
    TypeF : function(component, event, helper) {
        var type = component.get("v.Servs");
        var ops = component.find("serviceType");
        var typeView = [];
        typeView.push({
                    class: "optionClass",
                    label: '--- None ---',
                    value: null
                });
        for(var i = 0; i < type.length; i++){
            if(type[i].servicio.Type__c == ops.get("v.value")){
                typeView.push({
                    class: "optionClass",
                    label: type[i].servicio.Name,
                    value: type[i].servicio.Name
                });
            }
        }
        component.find('Type').set("v.options", typeView);
        //this.eventM(component, event, helper);
        
    },
    eventM : function(component, event, helper) {
        console.log("hola");
        var cmpEvent = component.getEvent("cmpEvent");
        var ops1 = component.find("serviceType");
        var ops2 = component.find("Type");
        var ops3 = component.find("Description");
        var tem = {Position:component.get("v.Position"),
                    serviceType: ops1.get("v.value"),
                    Type: ops2.get("v.value"),
                    Description: ops3.get("v.value")
                   };
        cmpEvent.setParams({
            "message" : tem,
            "TypeEvent" : "Change"
        });
        cmpEvent.fire();
    },
    eventDelete : function(component, event, helper) {
        var cmpEvent = component.getEvent("cmpEvent");
        var tem = {
            Position:component.get("v.Position")
                   };
        cmpEvent.setParams({
            "message" : tem,
            "TypeEvent" : "Delete"
        });
        cmpEvent.fire();
    },
    prueba : function(component, event, helper) {
        var ops = component.find("serviceName");
        //console.log('Valor: '+ ops.get("v.value"));
	}
    
})