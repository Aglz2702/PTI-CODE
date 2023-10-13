/**
 *  @Name           CreatePartNumbersController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/
({
	doInit : function(component, event, helper) {
        var action = component.get("c.getProducts");
        action.setParams({
            WOId : component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            component.set("v.Products", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    addProduct : function(component, event, helper){
        component.set("v.message", '');
        var Products = component.get("v.Products");
        var len = Products.length;
        var idWO = component.get("v.recordId");
        
        for(var j=0;j<len;j++){
        	var rec = Products[j].PartCount;
            Products[j].part.Part_number__c = document.getElementById(rec).value;
        }
        
        var i = len-1;
        var sig = Products[i].PartCount;
        var sig = sig+1;
        var action = component.get("c.Product");
        action.setParams({
            WOId : component.get("v.recordId"),
            cont : sig
        });
        action.setCallback(this, function(data) {
            var holi = data.getReturnValue();
            Products.push(data.getReturnValue());
            component.set("v.Products", Products);
        });
        $A.enqueueAction(action);
    }
    ,
    removePart : function(component, event, helper){
        component.set("v.message", '');
        var Products = component.get("v.Products");
        var selCont = event.getParam("selectedPart");
        var len = Products.length;
        var eliminar;
        for(var j=0;j<len;j++){
        	var rec = Products[j].PartCount;
            Products[j].part.Part_number__c = document.getElementById(rec).value;
            if(selCont.PartCount == rec){
                eliminar = j;
            }
        }
        if(len != 1){
           //var selCont = event.getParam("selectedPart");
           var index = eliminar;
           if (index > -1) {
                Products.splice(index, 1);
           }
           component.set("v.Products",Products);
        }
    }
    ,
    guardar : function(component, event, helper){
        component.set("v.message", '');
        var Products = component.get("v.Products");
        var len = Products.length;
        var idWO = component.get("v.recordId");
        
        for(var j=0;j<Products.length;j++){
            var rec = Products[j].PartCount;
            Products[j].part.Part_number__c = document.getElementById(rec).value;
            if(Products[j].part.Part_number__c==''){
                if(Products.length > 1){
                    var index = j;
                    if (index > -1) {
                        Products.splice(index, 1);
                        j--;
                    }
                    
                }
            }
        }
        if(!(Products.length==1) || !(Products[0].part.Part_number__c == '')){
            var Desc=document.getElementById('DefectDescription').value;
            //var commentsControl = component.find("DefectDescription");
            //var Desc=commentsControl.get("v.value")
            var PDes=document.getElementById('PartDescription').value
            var action = component.get("c.insertParts");
            action.setParams({
                listW : JSON.stringify(Products),
                defect : Desc,
                description : PDes
            });
            action.setCallback(this, function(data) {
                if(data.getReturnValue()=='ok'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Registros creados',
                        message: 'Se han creado los números de partes',
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
            });
            $A.enqueueAction(action);
            
        }else{
            component.set("v.Products",Products);
            component.set("v.message", 'No se puede guardar sin número de partes');
        }
        component.set("v.Products",Products);
    }
    ,
    imprimir : function(component, event, helper) {
        var Products = component.get("v.Products");
        var len = Products.length;
        console.log('Name: '+Products[0].part.Part_number__c);
        console.log('Len: '+len);
    }
})