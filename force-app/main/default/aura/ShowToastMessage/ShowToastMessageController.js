({
    doInit : function(component, event, helper) {
        var action = component.get("c.toastMessage");
        var state = response.getState(); // get the response state
        if(state == 'SUCCESS') {
            alert("state1"+state);
            alert(response.getReturnValue());
            var res = response.getReturnValue();
            var evt = $A.get("e.force:showToast");
            evt.setParams({
                "title" : "success!",
                "message" : "done "
            });
            evt.fire();
        }
         $A.enqueueAction(action);
    }
    })