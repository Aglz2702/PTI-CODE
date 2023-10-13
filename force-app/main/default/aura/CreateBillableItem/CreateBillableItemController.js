({
	doInit : function(component, event, helper){
        var action = component.get("c.getServices");
        component.set("v.BillableItems",[{'Position': 0}]);
        action.setParams({
            pos : 0
        });
        action.setCallback(this, function(data) {
            var servs=data.getReturnValue();
            var pricetype = [];
            for(var i = 0; i < servs.length; i++){
                 if(pricetype.indexOf(servs[i].servicio.Type__c) < 0){
                    pricetype.push(servs[i].servicio.Type__c);
                 }
            }
            component.set("v.Servs",servs);
            component.set("v.PriceType",pricetype);
        });
        $A.enqueueAction(action);
	},
    addBI : function(component, event, helper){
        component.set("v.message", '');
        var BI = component.get("v.BillableItems");
        var sig = BI[BI.length-1].Position+1;
        
        BI.push({'Position': sig});
        component.set("v.BillableItems",BI);
    },
    handleComponentEvent : function(component, event, helper){
        component.set("v.message", '');
        var TypeEvent = event.getParam("TypeEvent");
        var obj = event.getParam("message");
        var BIList = component.get("v.BillableItems");
        var len = BIList.length;
        //console.log
        if(TypeEvent == "Change"){
            for(var i = 0; i < len; i++){
                if(obj.Position == BIList[i].Position){
                    BIList[i].Type = obj.Type;
                    BIList[i].serviceType = obj.serviceType;
                    BIList[i].Description = obj.Description;
                    //BIList[i].PriceType = obj.PriceType;
                    break;
                }
            }
            component.set("v.BillableItems",BIList);
        }else{
            if(TypeEvent == "Delete"){
                var eliminar;
                for(var i = 0; i < len; i++){
                    if(obj.Position == BIList[i].Position){
                        eliminar = i;
                        break;
                    }
                }
                if(len != 1){
                    if (eliminar > -1) {
                        BIList.splice(eliminar, 1);
                    }
                    component.set("v.BillableItems",BIList);
                }
            }
        }
    },
    Create : function(component, event, helper){
        component.set("v.message", '');
        var BIList = component.get("v.BillableItems");
        for(var j = 0;j < BIList.length; j++){
            if(BIList[j].Type==null || BIList[j].serviceType==null || BIList[j].Type == '' || BIList[j].serviceType == ''){
                if(BIList.length > 1){
                    if (j > -1) {
                        BIList.splice(j, 1);
                        j--;
                    }
                    
                }
            }
        }
        if(!(BIList.length==1) || !(BIList[0].Type == null || BIList[0].serviceType == null || BIList[0].Type == '' || BIList[0].serviceType == '')){
            var servs = component.get("v.Servs");
            console.log('lenServ: '+servs.length);
            console.log('lenBI: '+BIList.length);
            for(var i = 0; i < BIList.length; i++){
                for(var j = 0; j < servs.length; j++){
                    //console.log(BIList[i].Type+' == '+servs[j].servicio.Type__c+'?');
                    //console.log(BIList[i].serviceType+' == '+servs[j].servicio.Name+'?');
                    if(BIList[i].serviceType == servs[j].servicio.Type__c && BIList[i].Type == servs[j].servicio.Name){
                        BIList[i].Unit_cost = servs[j].servicio.Unit_cost__c;
                        BIList[i].PriceType = servs[j].servicio.Price_type__c;
                        console.log('cost '+i+': '+BIList[i].Unit_cost);
                        break;
                    }
                }
            }
            var action = component.get("c.createBI");
            action.setParams({
                listW : JSON.stringify(BIList),
                IdWO : component.get("v.recordId")
            });
            action.setCallback(this, function(data) {
                console.log('datau.u:'+data.getReturnValue())
                if(data.getReturnValue()=='ok'){
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Registros creados',
                        message: 'Se han creado los Billable Items',
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
            //console.log('NO Guarda');
            component.set("v.message", 'At least one list must have name and price type.');
        }
        component.set("v.BillableItems",BIList);
       
    },
})