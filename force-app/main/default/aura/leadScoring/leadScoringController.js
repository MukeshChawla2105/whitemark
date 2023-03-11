({
    doInit : function(component, event, helper) {
        var scoreCardId = component.get("v.selectRecordId");
        var leadId = component.get("v.recordId");
        
        var action = component.get('c.genrateScore');
        action.setParams({
            "LeadId":leadId
        });
        action.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your Score is being Generated"
                });
                toastEvent.fire();
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
        
    }
})