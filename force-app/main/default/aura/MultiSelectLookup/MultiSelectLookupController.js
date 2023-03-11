({
    // To prepopulate the seleted value pill if value attribute is filled
	doInit : function( component, event, helper ) {
    	$A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
		if( !$A.util.isEmpty(component.get('v.selectedRecords')) ) {
			helper.searchRecordsHelper(component, event, helper, component.get('v.selectedRecords'));
		}
	},

    // When a keyword is entered in search box
	searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
		    helper.searchRecordsHelper(component, event, helper, []);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
	},

    // When an item is selected
	selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
    		var recordsList = component.get('v.recordsList');
            var selectedRecords = component.get('v.selectedRecords') || [];
            var selectedDataObj = component.get('v.selectedDataObj') || [];
    		var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                recordsList[index].isSelected = recordsList[index].isSelected === true ? false : true;
                if(selectedRecords.includes(recordsList[index].value)) {
                    selectedRecords.splice(selectedRecords.indexOf(recordsList[index].value), 1);
                    var ind = selectedDataObj.findIndex(x => x.value === event.currentTarget.id)
                    if(ind != -1) {selectedDataObj.splice(ind, 1)}
                } else {
                	selectedRecords.push(recordsList[index].value);
                    selectedDataObj.push(recordsList[index]);
                }
            }
            component.set('v.recordsList', recordsList);
            component.set('v.selectedRecords', selectedRecords);
            component.set('v.selectedDataObj', selectedDataObj);
        }
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
	},
    assignToGroup : function(component, event, helper, selectedRecords) {       
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var action = component.get('c.assignCriteriaToGroup');
        action.setParams({
            'SelectedGroupIds' : component.get('v.selectedRecords'),
            'assCriteriaId' :  component.get('v.recordId'),
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "This Criteria has been assigned to Selected Groups."
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    removePill : function( component, event, helper ){
        var recordId = event.getSource().get('v.name');
        var recordsList = component.get('v.recordsList');
        var selectedRecords = component.get('v.selectedRecords');
        var selectedDataObj = component.get('v.selectedDataObj');
        
        selectedRecords.splice(selectedRecords.indexOf(recordId), 1);
        var index = selectedDataObj.findIndex(x => x.value === recordId)
        if(index != -1) {
            selectedDataObj.splice(index, 1)
        }
        var ind = recordsList.findIndex(x => x.value === recordId)
        if(ind != -1) {
            recordsList[ind].isSelected = false;
        }
        component.set('v.recordsList', recordsList);
        component.set('v.selectedDataObj', selectedDataObj);
        component.set('v.selectedRecords', selectedRecords);
    },
    
    showRecords : function( component, event, helper ){
        var disabled = component.get('v.disabled');
        if(!disabled && !$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },

    // To close the dropdown if clicked outside the inputbox.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    
})
/*
 Code by CafeForce
 Website: http://www.cafeforce.com
 DO NOT REMOVE THIS HEADER/FOOTER FOR FREE CODE USAGE
*/