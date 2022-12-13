({
    getMultiSelectPicklist : function (component, helper) {
        debugger;
        debugger;
        var action = component.get("c.GetPicklistvalue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMapHpyCl = [];
                var fieldMapLossReason = [];
                var InterestedINNewProdut = [];
                var happcallFeed = [];
                
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
                    if(key == 'HpyClFeed'){
                        for(var pickVal in result[key]){
                            happcallFeed.push({label: pickVal, value: result[key][pickVal]});    
                        }
                    }
                    if(key == 'Interestedproduct'){
                        // for (var i = 0; i < result[key].length; i++) {
                        //     plValues.push({
                        //         label: result[i],
                        //         value: result[i]
                        //     });
                        // }
                        for(var pickVal in result[key]){
                            InterestedINNewProdut.push({key: pickVal, value: result[key][pickVal]});    
                        }
                    }
                }
                component.set("v.HpyClOptions", fieldMapHpyCl);
                component.set("v.lossReasonOptions", fieldMapLossReason);
                component.set("v.HappycallFeedOptions", happcallFeed);
                component.set("v.InterestedProductOptions", InterestedINNewProdut);
            }
        });
        $A.enqueueAction(action);
    },

})