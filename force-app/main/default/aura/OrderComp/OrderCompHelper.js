({
	getPicklistValues: function(component, event) {
        debugger;
        var action = component.get("c.GetPicklistvalue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMapHpyCl = [];
                var fieldMapLossReason = [];
                
                for(var key in result){
                    debugger;
                    if(key == 'HpyCl'){
                        for(var pickVal in result[key]){
                            fieldMapHpyCl.push({key: pickVal, value: result[key][pickVal]});    
                        }
                    }
                    if(key == 'reason'){
                        for(var pickVal in result[key]){
                            fieldMapLossReason.push({key: pickVal, value: result[key][pickVal]});    
                        }
                    }
                }
                component.set("v.HpyClOptions", fieldMapHpyCl);
                component.set("v.lossReasonOptions", fieldMapLossReason);
            }
        });
        $A.enqueueAction(action);
    }
})