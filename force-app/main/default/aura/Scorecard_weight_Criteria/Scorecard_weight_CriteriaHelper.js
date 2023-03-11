({
		getAllObjects : function(component, event,index) {
        var wrappWeic = component.get("v.WrappweicList");
        var action = component.get('c.getAllSObjects');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var objectResults = [];
                for(var key in result){
                    objectResults.push({key: key, value: result[key]});
                }
                wrappWeic[index].mapOfObject = objectResults;
                component.set('v.WrappweicList',wrappWeic);
            }else{
                alert('error in response')
            }
        });
        $A.enqueueAction(action);
    },
      getAllFields : function(component, event, objName, index){
        debugger;
        var action = component.get('c.getFieldList');
        action.setParams({'objName': objName});
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === 'SUCCESS'){
            	var result = response.getReturnValue();
                component.set('v.wrapperFields',result);
                var fieldMap =component.get("v.WrappweicList");
                var mapOfField = [];
                for(var i=0; i <=result.length-1;i++){
                	mapOfField.push({key: result[i].api_Name, value: result[i].label});    
                }
                fieldMap[index].FieldName = mapOfField;
                component.set('v.WrappweicList',fieldMap);
            }else{
                alert('Error in Response');
            }
        });
        $A.enqueueAction(action);
    },
    getPicklistValue : function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Scorecard_Weight_Criteria__c',
            field_Api_Name  : 'Matching_Type__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.picklistValueMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    getMatchingValue : function(component, event, fieldName, index){
        var attrval = component.get('v.WrappweicList');
        var wrapperList = component.get("v.wrapperFields");
        var filedType;
        var result =[];
        for(var i=0; i <=wrapperList.length-1;i++){
            if(wrapperList[i].api_Name === fieldName){
                filedType =  wrapperList[i].fielddataType;
                if(wrapperList[i].mapOfPicklist !==null && wrapperList[i].mapOfPicklist !==undefined){
                    result = wrapperList[i].mapOfPicklist;    
                }
            }       
        }
        if(filedType === 'Picklist' || filedType === 'Multi-Picklist'){
            component.set("v.isPicklist",true);
            var industryMap = [];
            for(var key in result){
                industryMap.push({key: key, value: result[key]});
            }
            attrval[index].mapOfPicklistFields = industryMap;
            component.set("v.WrappweicList", attrval);
        }else{
            component.set("v.isPicklist",false);
            //component.set("v.picklistValueOfField", []);
        }
        attrval[index].fieldDataType=filedType;
        var action = component.get('c.getMatchList');
        action.setParams({
            "name": filedType 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                attrval[index].matchTypeList = result;
                component.set("v.WrappweicList", attrval);
            }else{
                alert('Error in Response');
            }
        });
        $A.enqueueAction(action);
    },
    saveScoreWeight : function(component, event){
        debugger;
        var attrval = component.get('v.WrappweicList');
        var validData = component.find('valueVal').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            var params = event.getParam('arguments');
            var callback;
            console.log(params);
            if (params) {
                callback = params.callback;
            }
            var action = component.get("c.createWeightRecord");
            for(var i=0;i<attrval.length;i++){
                delete attrval[i].FieldName;
                delete attrval[i].mapOfObject;
                delete attrval[i].mapOfPicklistFields;
                delete attrval[i].matchTypeList;
            }
            console.log("Json Structure : "+JSON.stringify(attrval));
            action.setParams({"objlist":JSON.stringify(attrval),"ids":component.get('v.parentId')});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    callback(response.getReturnValue());
                }else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
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
        }
    },
    getScoreWeight : function(component, event){
        debugger;
        var action = component.get('c.getRelatedweight');
        action.setParams({"ids":component.get('v.parentId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state ==='SUCCESS'){
                if(response.getReturnValue() !==null && response.getReturnValue() !==undefined){
                    var Exereclst = response.getReturnValue();
                    var fieldList = Exereclst[0].FieldName;
                    var mapOfField = [];
                    
                    for(var key in fieldList){
                        //mapOfField.push({key: key, value: fieldList[key]});
                        mapOfField.push({key: fieldList[key], value:key });
                    }
                    for(var i=0;i<Exereclst.length;i++){
                        Exereclst[i].FieldName=mapOfField;
                    }
                    for(var i=0;i<Exereclst.length;i++){
                        
                        var mapOfPicklist = [];
                        if(Exereclst[i].fieldDataType ==='Picklist' || Exereclst[i].fieldDataType ==='Multi-Picklist'){
                        	var mapOfPicklistFields = Exereclst[i].mapOfPicklistFields;
                            for(var key in mapOfPicklistFields){
                            	mapOfPicklist.push({key: mapOfPicklistFields[key], value:key});   
                            }
                            Exereclst[i].mapOfPicklistFields=mapOfPicklist;    
                        }
                    }
                    component.set("v.WrappweicList",Exereclst);
                }else{
                    var RowItemList = component.get("v.WrappweicList");
                    if(RowItemList.length === 0){
                        var action = component.get('c.createWeightData');
                        $A.enqueueAction(action);    
                    }    
                }
            }else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
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
    }
})