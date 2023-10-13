({
	doInit : function(component, event, helper) {
		helper.PicklistValues(component);
        helper.getContacts(component);
        //helper.getExisting(component);
	},
    SelectedPTI : function(component, event, helper) {
        component.set("v.message", '');
        component.set("v.CheckboxPTI",component.find("PTI").get("v.value"));
        helper.ShowContacts(component);
        //console.log('PTI= '+component.find("PTI").get("v.value"));
        //helper.ShowContacts(component);
    },
    SelectCustomer : function(component, event, helper) {
        component.set("v.message", '');
        helper.ShowContacts(component);
    },
    onPicklistChange : function(component, event, helper) {
        component.set("v.message", '');
        helper.ShowContacts(component);
    },
    save : function(component, event, helper) {
        helper.createFunctionContats(component);
        //console.log('Csutomer= '+JSON.stringify(component.get('v.ShowContacts')[0][0]));
    }
})