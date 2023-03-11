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
                var FEMIcallFeed = [];
                
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
                        for(var pickVal in result[key]){
                            InterestedINNewProdut.push({key: pickVal, value: result[key][pickVal]});    
                        }
                    }
                    if(key == 'FEMI Call Status'){
                        for(var pickVal in result[key]){
                            FEMIcallFeed.push({key: pickVal, value: result[key][pickVal]});    
                        }
                    }
                }
                component.set("v.HpyClOptions", fieldMapHpyCl);
                component.set("v.lossReasonOptions", fieldMapLossReason);
                component.set("v.HappycallFeedOptions", happcallFeed);
                component.set("v.InterestedProductOptions", InterestedINNewProdut);
                component.set("v.FemiCallOptions", FEMIcallFeed);
            }
        });
        $A.enqueueAction(action);
    },

    getOrderDetails : function (component, helper){
        debugger;

        var orderrecId = component.get("v.OrderId");
        var action = component.get("c.QueryOrderRec");
        action.setParams({ 
            orderId  : orderrecId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                if (result.Type == 'BFL') {
                    component.set("v.ShowFemicallFeedbackSection", true);
                    component.set("v.ShowHappycallFeedbackSection", false);
                }
                else{
                    component.set("v.ShowHappycallFeedbackSection", true);
                    component.set("v.ShowFemicallFeedbackSection", false);
                }
                component.set("v.OrderDetails", result);
            }
        });
        $A.enqueueAction(action);

    }
})