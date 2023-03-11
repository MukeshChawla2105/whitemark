({
    doinit : function(component, event, helper) {
        debugger;
        var orderID = component.get("v.ProductId");
        
        var action = component.get("c.getPriceBookEntryRecords");
        
        action.setParams({ 
            prodId : orderID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.OrderProductList", result);
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
})