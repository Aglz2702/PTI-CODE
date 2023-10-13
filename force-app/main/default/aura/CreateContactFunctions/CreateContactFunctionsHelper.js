({
	PicklistValues : function(component) {
		var action = component.get("c.getPicklistValues");
        var opts = [];
        action.setCallback(this, function(data) {
            if (data.getState() == "SUCCESS") {
                var allValues = data.getReturnValue();
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i].Name,
                        value: allValues[i].Id
                    });
                }
                component.find('Type').set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
	},
    getContacts : function(component) {
        var action = component.get("c.getContacts");
        var show = [];
        action.setParams({
            idWO : component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            if (data.getState() == "SUCCESS") {
                var contacts = data.getReturnValue();
                component.set('v.CustomerContact',contacts['Customer']);
                component.set('v.PTIContact',contacts['PTI']);
                //console.log('PTI'+JSON.stringify(contacts['PTI']));
            }
        });
        $A.enqueueAction(action);
    },
    getExisting : function(component) {
        var action = component.get("c.existingContacts");
        var show = [];
        action.setParams({
            idWO : component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            if (data.getState() == "SUCCESS") {
                component.set('v.existing',data.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    ShowContacts : function(component) {
        var show = [];
        if(component.find("Customer").get("v.value")){
            show.push(component.get('v.CustomerContact'));
        }
        if(component.find("PTI").get("v.value")){
            var PTIConts = component.get('v.PTIContact');
            var temp = [];
            var select = component.find('Type').get("v.value");
            console.log('idAcc = '+select)
            for(var i=0; i<PTIConts.length;i++){
                if(PTIConts[i].cont.AccountId == select){
                    //console.log('contact= '+JSON.stringify(PTIConts[i].cont));
                    temp.push(PTIConts[i]);
                }
            }
            show.push(temp);
        }
        component.set('v.ShowContacts',show);
        //console.log('Csutomer= '+JSON.stringify(component.get('v.ShowContacts')[0][0]));
    },
    createFunctionContats : function(component) {
        var listwrapper = component.get('v.ShowContacts');
        var action = component.get("c.saveFunctionContacts");
        var show = [];
        console.log('Hola'+ JSON.stringify(listwrapper));
        action.setParams({
            listW : JSON.stringify(listwrapper),
            idWO : component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            if (data.getState() == "SUCCESS") {
                if(data.getReturnValue()=='ok'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Registros creados',
                        message: 'Se han creado las funciones de contacto',
                        //messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    var navService = component.find("navService");
                    var pageReference = {    
                       "type": "standard__recordPage",
                       "attributes": {
                           "recordId": component.get("v.recordId"),
                           "objectApiName": "Work_order__c",
                           "actionName": "view"
                       }
                    };
                    navService.navigate(pageReference);
                    toastEvent.fire();
                }else{
                    component.set("v.message", data.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    }
})