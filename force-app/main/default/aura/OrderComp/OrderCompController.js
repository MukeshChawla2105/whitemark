({
    doInit : function(component, event, helper) {
        debugger;
        helper.getPicklistValues(component, event);
        var action = component.get("c.getOrderDetail");
        action.setParams({
            "orderId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {   
                component.set("v.OrderDetail", response.getReturnValue());
            }
            else{
                console.log("Failed with state: " , state);
            } 
        });
        $A.enqueueAction(action); 
    },
    
    SaveSampleDetails : function(Component, helper, event){
        debugger;
        var action = Component.get("c.updateOrder");
        action.setParams({
            'oRecord': OrderDetail,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Sample Line Item(s) have been saved successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            }        
            if(state === "ERROR"){
                var errors= response.getError();
                console.log("ERROR: ", errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Saving Error',
                    message: errors[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    setOptions : function(component, event, helper) {
        debugger;
        helper.getPicklistValues(component, event);
        var action = component.get("c.getOrderDetail");
        action.setParams({
            "orderId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {   
                component.set("v.OrderDetail", response.getReturnValue());
            }
            else{
                console.log("Failed with state: " , state);
            } 
        });
        $A.enqueueAction(action); 
    }
})