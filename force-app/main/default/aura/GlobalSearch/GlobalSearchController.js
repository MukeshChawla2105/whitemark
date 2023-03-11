({
    
    doInit: function (component, event, helper) {
        debugger;
        //var customerPhoneNumber = event.currentTarget.textContent; //e.currentTarget.textContent
        //var customerPhoneNumber = component.get("v.CustomerPhoneNumber");
        //var salesforcesiteurl = $A.get("$Label.c.SaleforceSiteUrl");
        var agentUniqueId = component.get("v.agentId");
        component.set('v.options', [
            { id: 'All', label: 'All' },
            { id: 'Account', label: 'Account' },
            { id: 'Lead', label: 'Lead' }
        ]);
            component.set('v.accountColumns', [
            { label: 'Name', fieldName: 'Name',type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'} },
            { label: 'Account Number', fieldName: 'AccountNumber', type: 'text' },
            { label: 'Phone', fieldName: 'Phone', type: 'text' },
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'text' }, 
        ]);
        component.set('v.leadColumns', [
            { label: 'Name', fieldName: 'Name', type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'} } ,
            { label: 'Company', fieldName: 'Company', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'email' }
        ]);
        
    },

    search: function (component, event, helper) {
        //helperhelper.getSearchResultsFromHandler(component, helper);
        //component.set("v.showSearchResults",true);
        debugger;
        helper.showSpinner(component);
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
                helper.hideSpinner(component);
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
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        debugger;
        component.set("v.isModalOpen", false);
        var cmpEvent = component.getEvent("sampleCmpEvent");
                //Set event attribute value
                cmpEvent.setParams({ "message": "SUCCESS" });
                cmpEvent.fire();
    },
    ShowAccRecordDetail : function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.AccountRecordId", recId);
        component.set("v.ShowSearchBox",false);
        component.set("v.showAccountRecordDetails",true);
        component.set("v.ShwRecdetails",true);
        component.set("v.showLeadRecordDetails",false); 
        component.set("v.showSearchResults",false);
        // component.set("v.SelectedOrderRecId",recId);
        // component.set("v.ShowOrderProductsModal",true);
    },

    ShowLeadRecordDetail : function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.LeadRecordId", recId);
        component.set("v.ShowSearchBox",false);
        component.set("v.showLeadRecordDetails",true);
        component.set("v.ShwRecdetails",true);
        component.set("v.showAccountRecordDetails",false);
        component.set("v.showSearchResults",false);
    },

    ShowSearchBoxcmp : function(component, event, helper){
        debugger;
        component.set("v.ShowSearchBox",true);
        component.set("v.showLeadRecordDetails",false);
        component.set("v.showAccountRecordDetails",false);
        component.set("v.showSearchResults",true);
        component.set("v.ShwRecdetails",false);
        //var recId = event.currentTarget.dataset.id;
    },
})