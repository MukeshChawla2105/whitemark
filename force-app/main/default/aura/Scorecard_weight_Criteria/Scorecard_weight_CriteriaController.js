({
    doInit : function(component, event, helper) {
        
        //helper.getScoreWeight(component, event);
        helper.getPicklistValue(component, event);
        
        var action = component.get('c.checkWeightListData');
        $A.enqueueAction(action);
        
    },
    createWeightData : function(component, event, helper) {
        var RowItemList = component.get("v.WrappweicList");
        var length = RowItemList.length;
        var tempObj = {'Name' : '','RelatedObject' : component.get("v.objectName"),'FieldName':['Id'],'fieldValue' : '','MatchingType' : '','MatchingValue' : '','Weight' : '','Score' : '','Id' : ''};
        RowItemList.push(tempObj);    
        component.set("v.WrappweicList", RowItemList);
        helper.getAllFields(component, event, component.get("v.objectName"), length);
     },
     checkWeightListData : function(component, event, helper){
        var RowItemList = component.get("v.WrappweicList");
        if(RowItemList.length === 0){
        	helper.getScoreWeight(component, event);   
        }
    },
    removeRowweight : function(component, event, helper){
        var selectedItem = event.target.name;
        var srt=selectedItem.split("-");
        var action = component.get('c.deleteRowWeight');
            action.setParams({
            "ids":srt[1]
        });
        action.setCallback(this, function(response){
             debugger;
              var state = response.getState();
              if(state === 'SUCCESS'){
                 var AllRowsList = component.get("v.WrappweicList");
                 AllRowsList.splice(srt[0], 1); 
                 component.set("v.WrappweicList", AllRowsList);
              }
         });
      $A.enqueueAction(action);
   },
   selectObjectName : function(component, event, helper){
        var idx = event.target.name;
    	var a= component.get("v.WrappweicList");
        console.log(a);
        var obj= a[idx].RelatedObject;
        helper.getAllFields(component, event, obj, idx);
    },
    selectFieldName : function(component, event, helper){
    	var idx = event.target.name;
    	//var fieldName = component.find("fieldVal").get("v.value");
    	var a= component.get("v.WrappweicList");
    	var fieldName = a[idx].fieldValue;
        helper.getMatchingValue(component, event,fieldName,idx);
    },
    saveWeightCriteria : function(component, event, helper){
        helper.saveScoreWeight(component, event);
    }
})