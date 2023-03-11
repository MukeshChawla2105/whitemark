({
    doInit : function( component, event, helper ) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.value')) ) {
            helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        }
    },
    
    
    searchRecords : function( component, event, helper ) {
        debugger;
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {

            // var timer = component.get('v.timer');
            // clearTimeout(timer);

            // var timer = setTimeout(function () {
            //     var newlst = [];
            //     helper.searchRecordsHelper(component, event, helper, component.get('v.value'))
            //     clearTimeout(timer);
            //     component.set('v.timer', null);
            // }, 500);

            // component.set('v.timer', timer);
            helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    }, 
    
    
    
})