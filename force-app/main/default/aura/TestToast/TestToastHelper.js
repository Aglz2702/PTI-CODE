({
addDelay : function(component, event, helper){
    window.setTimeout(
        $A.getCallback(function() {
            if(component.isValid()){
                var toastDiv= component.find('toastDiv');
                $A.util.removeClass(toastDiv, "slds-show");
                $A.util.addClass(toastDiv, "slds-hide");
            }
            else{
                console.log('Component is Invalid');
            }
        }), 3000
    );
},

closeToast : function(component){
    console.log('Inside closeToast after delay: '+ component);
    var toastDiv= component.find('toastDiv');
    $A.util.removeClass(toastDiv, "slds-show");
    $A.util.addClass(toastDiv, "slds-hide");
}
})