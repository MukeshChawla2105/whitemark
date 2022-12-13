({
    doinit: function (component, event, helper) {
        debugger;
        var orderrecId = component.get("v.OrderId");
        helper.getMultiSelectPicklist(component, event, helper);
    },
    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        var cmpEvent = component.getEvent("sampleCmpEvent");
        //Set event attribute value
        cmpEvent.setParams({ "message": "SUCCESS" });
        cmpEvent.fire();
        //component.set("v.isModalOpen", false);
    },
    SubmitHappyCallFeedback: function (component, event, helper) {
        debugger;
        var happycallSelectedValueForJs = component.get("v.happycallSelectedvalues");
        var happycallFeedSelectedValueForJs = component.get("v.happycallFeedSelectedvalues");
        var InterestedProdSelectedValueForJs = component.get("v.InterestedProdSelectedvalues");
        var feedBack = component.get("v.happycallFeedback");
        var orderrecIdForJS = component.get("v.OrderId");

        var action = component.get("c.updateAccountOrder");
        action.setParams({
            orderRecId: orderrecIdForJS,
            HappycallValue: happycallSelectedValueForJs,
            interestedProd: InterestedProdSelectedValueForJs,
            HappycallFeedValues: happycallFeedSelectedValueForJs,
            HappyCallRemark : feedBack
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.InterestedProdSelectedvalues", '');
                component.set("v.happycallSelectedvalues", '');
                component.set("v.happycallFeedSelectedvalues", '');
                var cmpEvent = component.getEvent("sampleCmpEvent");
                cmpEvent.setParams({ "message": "SUCCESS" });
                cmpEvent.fire();

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
})