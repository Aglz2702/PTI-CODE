({    
    handleShowToast : function(component, event, helper) {
        component.find('notifLib').showToast({
            "title": "Notif library Success!",
            "message": "The record has been updated successfully."
        });
    }
})