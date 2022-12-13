({
    getSearchResultsFromHandler: function (component, helper) {
        debugger;
        //var searchInput = component.find("searchInput");
        //var searchValue = searchInput.get("v.value");
        this.showSpinner(component);
        var searchValue = component.get("v.searchKey");
        var sobjectNameifany = component.get("v.selectedValue");
        var action = component.get("c.GlobalSearch");
        var agentUniqueId = component.get("v.agentId");
        action.setParams({
            searchKey: searchValue,
            objectName: sobjectNameifany,
            agentId : agentUniqueId
        });

        // callback that is executed after the server-side action returns
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                var result = response.getReturnValue();
                // SOSL will always return the list in the order they were queried
                if (sobjectNameifany == 'All') {
                    if (result.AccountRecords != undefined && result.leadRecords != undefined ) {

                        component.set("v.accountList", result.AccountRecords);
                        component.set("v.leadList", result.leadRecords);
                    }
                    else {
                        component.set("v.accountList", '');
                        component.set("v.leadList", '');

                    }

                }
                else if (sobjectNameifany == 'Account') {
                    component.set("v.accountList", result.AccountRecords);
                    component.set("v.leadList", '');
                }
                else if (sobjectNameifany == 'Lead') {
                    component.set("v.leadList", result.leadRecords);
                    component.set("v.accountList", '');
                }
                
                if (result.AccountRecords == undefined && result.leadRecords == undefined ) {
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
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})