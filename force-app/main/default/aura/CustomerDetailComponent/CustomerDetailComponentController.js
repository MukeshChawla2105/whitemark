({
    /*doInit : function (component, event, helper){
        debugger;
        var HashcodeOfLoggedInuser =component.get("v.HashCodeToQueryPhoneList");
        var action = component.get("c.QueryListOfPhoneNumberWithScheduleTime");
        action.setParams({ 
            HashCode : HashcodeOfLoggedInuser 
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var serverresponse = response.getReturnValue();
                component.set("v.ListOfPhonetask", serverresponse);
                component.set("v.ShowPhoneNumberList", true);
                component.set("v.ShowparticularCustomerDetail", false);

            }
        });
        $A.enqueueAction(action);
    },*/
    
    doInit: function (component, event, helper) {
        debugger;
        //var customerPhoneNumber = event.currentTarget.textContent; //e.currentTarget.textContent
        var customerPhoneNumber = component.get("v.CustomerPhoneNumber");

        var agentId = component.get("v.AgentuniqueID");
        //var salesforcesiteurl = $A.get("$Label.c.SaleforceSiteUrl");
        component.set('v.options', [
            { id: 'All', label: 'All' },
            { id: 'Account', label: 'Account' },
            { id: 'Lead', label: 'Lead' },
            { id: 'Opportunity', label: 'Opportunity' },
            { id: 'Contact', label: 'Contact' },
        ]);
            component.set('v.accountColumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Account Number', fieldName: 'AccountNumber', type: 'text' },
            { label: 'Phone', fieldName: 'Phone', type: 'text' },
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'text' }, 
        ]);
        component.set('v.contactColumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'email' },
            { label: 'Mobile', fieldName: 'MobilePhone', type: 'phone' },
        ]);
            component.set('v.oppColumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Stage Name', fieldName: 'StageName', type: 'text' },
            { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
        ]);
        component.set('v.leadColumns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Company', fieldName: 'Company', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'email' }
        ]);
        helper.getMultiSelectPicklist(component, event, helper);
        var action = component.get("c.CustomerRecord");
        
        action.setParams({ 
            PhoneNumber : customerPhoneNumber 
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var serverresponse = response.getReturnValue();
                component.set("v.ShowPhoneNumberList", false);
                component.set("v.ShowparticularCustomerDetail", true);
                if (serverresponse.CustomerAccDetail != undefined) {
                    if (serverresponse.CustomerAccDetail.Id != null && serverresponse.CustomerAccDetail.Id != '' && serverresponse.CustomerAccDetail.Id != undefined) { //ShowAccountHiglightpanel Id
                        if (serverresponse.CustomerAccDetail.FirstName != undefined && serverresponse.CustomerAccDetail.FirstName != null && serverresponse.CustomerAccDetail.LastName != null &&  serverresponse.CustomerAccDetail.LastName != undefined) {
                            var result = (serverresponse.CustomerAccDetail.FirstName.charAt(0)).concat(serverresponse.CustomerAccDetail.LastName.charAt(0));
                            component.set("v.AccounFirstLetters", result);
                            
                        }
                        component.set("v.ShowAccountHiglightpanel", true);
                        component.set("v.AccountDetails", serverresponse.CustomerAccDetail);
                        component.set("v.AccountRecordId", serverresponse.CustomerAccDetail.Id);
                        
                        component.set("v.AccountContact", serverresponse.CustomerAccDetail.Contacts);
                        component.set("v.AccountOpportunities", serverresponse.CustomerAccDetail.Opportunities); //
                        component.set("v.ShowCreateOppButton", true);
                        component.set("v.AccountHistory", serverresponse.CustomerAccHistoryDetail);
                        component.set("v.Accountorders", serverresponse.CustomerAccDetail.Orders);
                        component.set("v.taskList", serverresponse.CustomerAccDetail.Tasks);
                        component.set("v.CallLogList", serverresponse.CustomerAccDetail.Subtask__r);

                        if (serverresponse.CustomerAccDetail.Feedback__c != null && serverresponse.CustomerAccDetail.Feedback__c != undefined) {
                            component.set("v.Feedback", serverresponse.CustomerAccDetail.Feedback__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true); 
                            component.set("v.showSubmitButton", false);
                        } 
                        if (serverresponse.CustomerAccDetail.Interested_Product__c != null && serverresponse.CustomerAccDetail.Interested_Product__c != undefined) {
                            component.set("v.InterestedProduct", serverresponse.CustomerAccDetail.Interested_Product__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true);
                            component.set("v.showSubmitButton", false);
                        }
                        if (serverresponse.CustomerAccDetail.Follow_Up_date__c != null && serverresponse.CustomerAccDetail.Follow_Up_date__c != undefined ) {
                            component.set("v.Followupdate", serverresponse.CustomerAccDetail.Follow_Up_date__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true);
                            component.set("v.showSubmitButton", false);
                        }
                    }
                }
                else if (serverresponse.CustomerLeadDetail != undefined) {
                    if (serverresponse.CustomerLeadDetail.Id != null && serverresponse.CustomerLeadDetail.Id != '' && serverresponse.CustomerLeadDetail.Id != undefined) {
                        if (serverresponse.CustomerLeadDetail.FirstName != undefined && serverresponse.CustomerLeadDetail.FirstName != null && serverresponse.CustomerLeadDetail.LastName != null &&  serverresponse.CustomerLeadDetail.LastName != undefined) {
                            var result = (serverresponse.CustomerLeadDetail.FirstName.charAt(0)).concat(serverresponse.CustomerLeadDetail.LastName.charAt(0));
                            component.set("v.LeadFirstLetters", result);
                            
                        }
                        if ((serverresponse.CustomerLeadDetail.FirstName == undefined || serverresponse.CustomerLeadDetail.FirstName == null ) && serverresponse.CustomerLeadDetail.LastName != null &&  serverresponse.CustomerLeadDetail.LastName != undefined) {
                            var result = serverresponse.CustomerLeadDetail.LastName.charAt(0);
                            component.set("v.LeadFirstLetters", result);
                            
                        }
                        component.set("v.ShowALeadHiglightpanel", true);
                        
                        component.set("v.LeadDetails", serverresponse.CustomerLeadDetail);   
                        component.set("v.AccountRecordId", serverresponse.CustomerLeadDetail.Id);
                        component.set("v.LeadHistory", serverresponse.CustomerLeadHistoryDetail);
                        component.set("v.productList", serverresponse.productIntrestDetails);
                        component.set("v.taskList", serverresponse.CustomerLeadDetail.Tasks);
                        component.set("v.LeadCallLogList", serverresponse.CustomerLeadDetail.Subtask__r);
                        component.set("v.LeadRecId", serverresponse.CustomerLeadDetail.Id);
                        
                        if (serverresponse.CustomerLeadDetail.Feedback_Comments__c != null && serverresponse.CustomerLeadDetail.Feedback_Comments__c != undefined) {
                            component.set("v.Feedback", serverresponse.CustomerLeadDetail.Feedback_Comments__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true); 
                            component.set("v.showSubmitButton", false);
                        } 
                        if (serverresponse.CustomerLeadDetail.Interested_Product__c != null && serverresponse.CustomerLeadDetail.Interested_Product__c != undefined) {
                            component.set("v.InterestedProduct", serverresponse.CustomerLeadDetail.Interested_Product__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true);
                            component.set("v.showSubmitButton", false);
                        }
                        if (serverresponse.CustomerLeadDetail.Follow_Up_date__c != null && serverresponse.CustomerLeadDetail.Follow_Up_date__c != undefined ) {
                            component.set("v.Followupdate", serverresponse.CustomerLeadDetail.Follow_Up_date__c);
                            component.set("v.isdisabledFeedback", true);
                            component.set("v.showEditButton", true);
                            component.set("v.showSubmitButton", false);
                        }

                    }
                    
                }
                component.set("v.ShowCustomerdetails", true);
                component.set("v.ShowProductdetails", false);
                component.set("v.ShowCallScriptdetails", false);
                component.set("v.ShowInventorydetails", false);
                
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
    editDetails: function (component, event, helper) {
        debugger;
        component.set("v.isdisabled", false);
        component.set("v.showSaveButtons", true);
    },
    cancelDetails: function (component, event, helper) {
        debugger;
        component.set("v.isdisabled", true);
        component.set("v.showSaveButtons", false);
    },
    saveDetails: function (component, event, helper) {
        debugger;
        var accDetails =  component.get("v.AccountDetails");
        var action = component.get("c.updateAccRecord");
        
        action.setParams({ 
            accRecord : accDetails,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountDetails",response.getReturnValue());
                component.set("v.isdisabled", true);
                component.set("v.showSaveButtons", false);
                //alert("From server: " + response.getState());
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

    editLeadDetails : function (component, event, helper){
        debugger;
        component.set("v.isdisabledLead", false);
        component.set("v.showLeadSaveButtons", true);

    },
    cancelLeadDetails: function (component, event, helper) {
        debugger;
        component.set("v.isdisabledLead", true);
        component.set("v.showLeadSaveButtons", false);
    },

    saveLeadDetails: function (component, event, helper) {
        debugger;
        var LeadDetails =  component.get("v.LeadDetails");
        var action = component.get("c.UpdateLeadDetails");
        
        action.setParams({ 
            Ldrec : LeadDetails,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LeadDetails",response.getReturnValue());
                component.set("v.isdisabledLead", true);
                component.set("v.showLeadSaveButtons", false);
                //alert("From server: " + response.getState());
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


    handlePastOrder: function (component, event, helper) {
        component.set("v.ShowPastOrder", true);
        component.set("v.ShowPastEnquiry", false);
        component.set("v.ShowNextBestAction", false);
        component.set("v.ShowCallLogs", false);
        component.set("v.ShowRecordHistory", false);
    },
    handlePastEnquiry: function (component, event, helper) {
        component.set("v.ShowPastOrder", false);
        component.set("v.ShowPastEnquiry", true);
        component.set("v.ShowNextBestAction", false);
        component.set("v.ShowCallLogs", false);
        component.set("v.ShowRecordHistory", false);
    },
    HandleNextBestAction: function (component, event, helper) {
        component.set("v.ShowPastOrder", false);
        component.set("v.ShowPastEnquiry", false);
        component.set("v.ShowNextBestAction", true);
        component.set("v.ShowCallLogs", false);
        component.set("v.ShowRecordHistory", false);
    },
    HandleCallLogs: function (component, event, helper) {
        component.set("v.ShowPastOrder", false);
        component.set("v.ShowPastEnquiry", false);
        component.set("v.ShowNextBestAction", false);
        component.set("v.ShowCallLogs", true);
        component.set("v.ShowRecordHistory", false);
    },
    HandleRecordHistory: function (component, event, helper) {
        debugger;
        component.set("v.ShowPastOrder", false);
        component.set("v.ShowPastEnquiry", false);
        component.set("v.ShowNextBestAction", false);
        component.set("v.ShowCallLogs", false);
        component.set("v.ShowRecordHistory", true);
    },
    search: function (component, event, helper) {
        helper.getSearchResultsFromHandler(component, helper);
        //component.set("v.showSearchResults",true);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    showHomePage: function (component, event, helper) {
        component.set("v.ShowCustomerdetails", true);
        component.set("v.ShowProductdetails", false);
        component.set("v.ShowCallScriptdetails", false);
        component.set("v.ShowInventorydetails", false);
    },
    showProductPage: function (component, event, helper) {
        component.set("v.ShowCustomerdetails", false);
        component.set("v.ShowProductdetails", true);
        component.set("v.ShowCallScriptdetails", false);
        component.set("v.ShowInventorydetails", false);
    },
    showCallScriptPage: function (component, event, helper) {
        component.set("v.ShowCustomerdetails", false);
        component.set("v.ShowProductdetails", false);
        component.set("v.ShowCallScriptdetails", true);
        component.set("v.ShowInventorydetails", false);
    },
    showInventorySearchPage: function (component, event, helper) {
        component.set("v.ShowCustomerdetails", false);
        component.set("v.ShowProductdetails", false);
        component.set("v.ShowCallScriptdetails", false);
        component.set("v.ShowInventorydetails", true);
    },
    ShowGlobalSearchOption : function (component, event, helper){
        component.set("v.isModalOpen", true);
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
    
    HandleLeadHistory : function(component, event, helper){
        component.set("v.ShowLeadHistory", true);
        component.set("v.showLeadtaskList", false);
        component.set("v.ShowLeadCallLogs", false);
        component.set("v.ShowProductList", false);
    },
    handleLeadTaskHistory : function(component, event, helper){
        component.set("v.ShowLeadHistory", false);
        component.set("v.showLeadtaskList", true);
        component.set("v.ShowLeadCallLogs", false);
        component.set("v.ShowProductList", false);
    },

    handleLeadCallLogs : function(component, event, helper){
        component.set("v.ShowLeadHistory", false);
        component.set("v.showLeadtaskList", false);
        component.set("v.ShowLeadCallLogs", true);
        component.set("v.ShowProductList", false);
    },

    handleProductList : function(component, event, helper){
        component.set("v.ShowLeadHistory", false);
        component.set("v.showLeadtaskList", false);
        component.set("v.ShowLeadCallLogs", true);
        component.set("v.ShowProductList", true);
    },
    
    SubmitFeedback : function(component, event, helper){
        debugger;
        component.set("v.disablesubmitFeedbackbutton", true);
        
        var feedbackForJS = component.get("v.Feedback");
        var FollowupdateForJS = component.get("v.Followupdate");
        var InterestedProductForJS = component.get("v.InterestedProduct");
        var AccRec = component.get("v.AccountDetails");
        var leadRec = component.get("v.LeadDetails");
        var LossReasonForjs = component.get("v.LossReason"); 
        if (AccRec != undefined && AccRec.Id != undefined && AccRec.Id != null) {
            var AccRecordId = AccRec.Id;
        }
        if (leadRec != undefined && leadRec.Id != undefined && leadRec.Id != null) {
            var AccRecordId = leadRec.Id;
        }
        var action = component.get("c.UpdateFeedback");
        //var action = component.get('c.UpdateFeedback');
        action.setParams({ 
            Feedback : feedbackForJS,
            Followupdate : FollowupdateForJS,
            InterestedProduct : InterestedProductForJS,
            recordId : AccRecordId,
            LossReasonForAPex : LossReasonForjs
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSubmitButton", false);
                component.set("v.showEditButton", true);
                component.set("v.isdisabledFeedback", true);
                
                //alert("From server: " + response.getReturnValue());
                
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

    EditFeedback : function(component, event, helper){
        debugger;
        component.set("v.isdisabledFeedback", false);
        component.set("v.showSubmitButton", true);
        component.set("v.showEditButton", false);
        component.set("v.disablesubmitFeedbackbutton", false);
    },

    CancelSubmitFeedback : function(component, event, helper){
        component.set("v.showSubmitButton", false);
        component.set("v.showEditButton", true);
        component.set("v.isdisabledFeedback", true); 
        //component.set("v.showCancelFeedbackButton", true);

    },

    handleCreateOppModalPopUp : function(component, event, helper){
        component.set("v.ShowCreateOppModalPopUp", true);
    },
    
    markOpportunityasCloseLost : function(component, event, helper){
        debugger;
        component.set("v.disablebutton", true);
        var accRecId = component.get("v.AccountRecordId");
        var LossReasonForJs = component.get("v.LossReason");
        var action = component.get('c.markOppCloseLost');
        
        action.setParams({ 
            accountid :  accRecId,
            LossReason : LossReasonForJs
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ShowCreateOppButton", true);
                component.set("v.ShowOppCloseLostButton", false);
                alert("you have lost this opportunity ");
                
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
    SubmitHappyCallFeedback : function(component, event, helper){
        debugger;
        var happycallSelectedValueForJs = component.get("v.happycallSelectedvalues");
        var happycallFeedSelectedValueForJs = component.get("v.happycallFeedSelectedvalues");
        var InterestedProdSelectedValueForJs = component.get("v.InterestedProdSelectedvalues");
        var AccRec = component.get("v.AccountDetails");
        var AccRecordId = AccRec.Id;
        
        var action = component.get("c.updateAccountOrder");
        //var action = component.get('c.UpdateFeedback');
        action.setParams({ 
            AccountId : AccRecordId,
            HappycallValue : happycallSelectedValueForJs,
            interestedProd : InterestedProdSelectedValueForJs,
            HappycallFeedValues : happycallFeedSelectedValueForJs
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.InterestedProdSelectedvalues", '');
                component.set("v.happycallSelectedvalues", '');
                component.set("v.happycallFeedSelectedvalues", '');
                
                //alert("From server: " + response.getReturnValue());
                
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
    EnableInterestedProduct : function(component, event, helper){
        debugger;
        var happycallSelectedValueForJs = component.get("v.happycallSelectedvalues");
        if (happycallSelectedValueForJs == 'Contacted') {
            component.set("v.enableIntestedProduct", false);
        }
        else{
            component.set("v.InterestedProdSelectedvalues", '');
            component.set("v.enableIntestedProduct", true);
        }
    },
    handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
        
        //Update the Selected Values  
        component.set("v.happycallFeedSelectedvalues", selectedValues);
    },
    
    handleEdit : function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.SelectedOrderRecId",recId);
        component.set("v.ShowEditOrderForHappyCallFeedback",true);
    },
    parentComponentEvent : function(component, event) { 
        //Get the event message attribute
        debugger;
        var message = event.getParam("message"); 
        //Set the handler attributes based on event data 
        if (message== 'SUCCESS') {
            component.set("v.ShowEditOrderForHappyCallFeedback",false); 
            component.set("v.ShowMarkasOppClosedLostModal",false);
            component.set("v.ShowOppProductsModal",false); 
            component.set("v.ShowOrderProductsModal",false);
            component.set("v.isModalOpen",false);
            
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
            
        }
        //component.set("v.eventMessage", message + 'Biswajeet');         
    } ,
    ShowMarkasOppClosedLost : function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.SelectedoppRecId",recId);
        component.set("v.ShowMarkasOppClosedLostModal",true);
    },
    ShowEditOppRecOLI: function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.SelectedoppRecId",recId);
        component.set("v.ShowEditOppWithOLIModal",true);
    },
    
    handleCloseEditOppModal : function(component, event, helper){
        var messagefromChildLWC = event.getParam("Message");
        if (messagefromChildLWC == 'Close') {
            component.set("v.ShowEditOppWithOLIModal",false);
        }
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },

    ShowOppProducts: function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.SelectedoppRecId",recId);
        component.set("v.ShowOppProductsModal",true);
    },

    showOrderLineItem : function(component, event, helper){
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.SelectedOrderRecId",recId);
        component.set("v.ShowOrderProductsModal",true);
    }
    
    //var a = Component.get('c.doInit');
    //$A.enqueueAction(a);  
    
    
})