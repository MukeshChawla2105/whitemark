({
    getSearchResultsFromHandler: function (component, helper) {
        debugger;
        //var searchInput = component.find("searchInput");
        //var searchValue = searchInput.get("v.value");
        var searchValue = component.get("v.searchKey");
        var sobjectNameifany = component.get("v.selectedValue");
        var action = component.get("c.GlobalSearch");
        action.setParams({
            searchKey: searchValue,
            objectName: sobjectNameifany
        });

        // callback that is executed after the server-side action returns
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                // SOSL will always return the list in the order they were queried
                if (sobjectNameifany == 'All') {
                    if (result.length > 0) {
                        component.set("v.accountList", result[0]);
                        component.set("v.contactList", result[1]);
                        component.set("v.oppList", result[2]);
                        component.set("v.leadList", result[3]);
                    }
                    else {
                        component.set("v.accountList", '');
                        component.set("v.contactList", '');
                        component.set("v.oppList", '');
                        component.set("v.leadList", '');

                    }

                }
                else if (sobjectNameifany == 'Account') {
                    component.set("v.accountList", result[0]);
                    component.set("v.contactList", '');
                    component.set("v.oppList", '');
                    component.set("v.leadList", '');
                }
                else if (sobjectNameifany == 'Lead') {
                    component.set("v.leadList", result[0]);
                    component.set("v.accountList", '');
                    component.set("v.contactList", '');
                    component.set("v.oppList", '');
                }
                else if (sobjectNameifany == 'Contact') {
                    component.set("v.contactList", result[0]);
                    component.set("v.leadList", '');
                    component.set("v.accountList", '');
                    component.set("v.oppList", '');
                }
                else if (sobjectNameifany == 'Opportunity') {
                    component.set("v.oppList", result[0]);
                    component.set("v.contactList", '');
                    component.set("v.leadList", '');
                    component.set("v.accountList", '');
                }



                if ((result[0] == undefined) && result[1] == undefined && result[2] == undefined && result[3] == undefined) {
                    component.set("v.showSearchResults", false);
                    component.set("v.emptyWrapper", true);

                }
                else {
                    component.set("v.showSearchResults", true);
                    component.set("v.emptyWrapper", false);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

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