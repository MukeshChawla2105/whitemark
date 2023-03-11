({
    doinit : function(component, event, helper) {
        var oppID = component.get("v.OpportunityrecordId");
        
        var action = component.get("c.oppLineitemForParticularOPP");
        action.setParams({ 
            opportunityId : oppID
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                component.set("v.OppLineitemList", result);
                //component.set("v.isModalOpen", true);
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

    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        //component.set("v.isModalOpen", false);
        debugger;
        var cmpEvent = component.getEvent("sampleCmpEvent");
                //Set event attribute value
                cmpEvent.setParams({ "message": "SUCCESS" });
                cmpEvent.fire();
     }
})