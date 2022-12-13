({
    myAction : function(component, event, helper) {
        debugger;
        var activity = component.get("v.activity");
        if (activity.Status == 'Completed') {
            component.set("v.disablebutton",true);
        }
        
    },
    toggleActivity : function(component, event, helper) {
        
        // toggle ‘slds-is-open’ class to expand/collapse activity section
        debugger;
        $A.util.toggleClass(component.find("expId"), "slds-is-open");
        
    },
    openModel : function(component, event, helper) {
        debugger;
        component.set("v.viewInfo",true);
    },
    closeModel : function(component, event, helper) {
        debugger;
        component.set("v.gatherInfo",false);
        component.set("v.viewInfo",false);
    },
    TaskCompleted : function(component, event, helper){
        component.set("v.gatherInfo",true);
    },
    updateTask : function(component, event, helper){
        debugger;
        component.set("v.disablebutton",true);
        var TaskToupdate = component.get("v.activity");
        
        var action = component.get("c.MarktaskCompleted");
        action.setParams({
            activitytask: TaskToupdate
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.activity",response.getReturnValue());
                component.set("v.gatherInfo",false);
                alert("Action is done and Marked as completed!"); 
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    }
    
})