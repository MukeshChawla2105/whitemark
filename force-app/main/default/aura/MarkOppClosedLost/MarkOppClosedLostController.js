({
    doinit : function(component, event, helper) {
        debugger;
        //helper.getMultiSelectPicklist(component, event, helper);
        var opoortunityId = component.get("v.LossReason");
        var lossoptions = component.get("v.lossreasonoptionsForChild");

    },
    markOpportunityasCloseLost : function(component, event, helper){
        debugger;
        component.set("v.disablebutton", true);
        var oppRecId = component.get("v.OpportunityrecordId");
        var LossReasonForJs = component.get("v.LossReason");
        var action = component.get('c.markOppCloseLost');

        action.setParams({ 
            OpportunityRecid :  oppRecId,
            LossReason : LossReasonForJs
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // component.set("v.ShowCreateOppButton", true);
                // component.set("v.ShowOppCloseLostButton", false);
                alert("you have lost this opportunity ");
                var cmpEvent = component.getEvent("sampleCmpEvent");
                //Set event attribute value
                cmpEvent.setParams({ "message": "SUCCESS" });
                cmpEvent.fire();

            }
            else if (state === "INCOMPLETE") {
               
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
    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpEvent = component.getEvent("sampleCmpEvent");
        //Set event attribute value
        cmpEvent.setParams({ "message": "SUCCESS" });
        cmpEvent.fire();
        //component.set("v.isModalOpen", false);
    },
})