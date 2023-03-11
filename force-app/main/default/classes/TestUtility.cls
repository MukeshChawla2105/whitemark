public class TestUtility {
  
    public static Assignment_Group__c createAssignmentGroup(String Name,Boolean donotConsiderforAssignment,Integer lastAllRRId,Integer lastAlloTo, string Leadstage, integer Maxleadsperday,Integer MaxledfrSelectedstg,integer MiniLedVol){
        Assignment_Group__c assGroupInstance = new Assignment_Group__c();
        assGroupInstance.Do_Not_Consider_For_Lead_Assignment__c = donotConsiderforAssignment;
        assGroupInstance.Last_Allocated_RRid__c	 = lastAllRRId;
        assGroupInstance.Last_Lead_Alloted_To__c = lastAlloTo;
       // assGroupInstance.Lead_Assigning_Criteria__c = LeadAssiCriId;
        assGroupInstance.Lead_Stage__c = Leadstage;
        assGroupInstance.Max_Lead_Per_Day__c = Maxleadsperday;
        assGroupInstance.Lead_Stage_Exceed_Count__c= MaxledfrSelectedstg;
        assGroupInstance.Minimum_Lead_Volume__c = MiniLedVol;
        assGroupInstance.Name = Name;
         insert assGroupInstance;
        return assGroupInstance;
    }
    public static Assignment_Group_Member__c CreatAssnGroupMember(Boolean Active, string Assingmentgrp, Integer AssigroupId,string Assigrpmbm,Integer MaxLeadsPerDay,Boolean OutofOffice){
       Assignment_Group_Member__c assGroupMemberInstance = new Assignment_Group_Member__c();
          assGroupMemberInstance.Active__c = Active;
          assGroupMemberInstance.Assignment_Group__c = Assingmentgrp;
          assGroupMemberInstance.Assignment_Id__c = AssigroupId;
          assGroupMemberInstance.Group_Member__c = Assigrpmbm;
          assGroupMemberInstance.Max_Lead_Per_Day__c = MaxLeadsPerDay;
          assGroupMemberInstance.Out_Of_Office__c = OutofOffice;
        insert assGroupMemberInstance;
        return assGroupMemberInstance;
         }
    Public static Error_Master__c  CheckErrorMaster(String Name,string Brand,string Capacitysize,string category,string colour,string errordiscrp,string features, string intrefId,Boolean isActive,string model,Integer mrp){
       Error_Master__c AssErrorMaster = new  Error_Master__c();
        AssErrorMaster.Name = Name;
        AssErrorMaster.Brand__c=Brand;
        AssErrorMaster.Capacity_Size__c=Capacitysize;
        AssErrorMaster.Category__c=category;
        AssErrorMaster.Colour__c= colour;
        AssErrorMaster.Error_Description__c	 = errordiscrp;
        AssErrorMaster.Features__c = features;
        AssErrorMaster.Int_Ref_ID__c= intrefId;
        AssErrorMaster.IsActive__c= isActive;
        AssErrorMaster.Model__c= model;
        AssErrorMaster.MRP__c= mrp;

        insert AssErrorMaster;
        return AssErrorMaster;
    } 
    
    Public Static Execption__c CreatException (string className, string MethodName, string ExceptionMsg){
       Execption__c	 AssException = new Execption__c();
        AssException.Class_Name__c = className;
        AssException.Method_Name__c= MethodName;
        AssException.Ececption_Message__c = ExceptionMsg;
        insert AssException;
        return AssException;
        
    }
    Public Static Franchisee__c CreatingFranchise (String Name,string GstNo,string OwnerMdName,string OwnerAddr,string StreetAddr,string Pincode,string SAPCode,string since,String Location){
        Franchisee__c AssFranchise = New Franchisee__c();
        AssFranchise.Name = Name;
       
        AssFranchise.GST_No__c= GstNo;
        AssFranchise.Owner_MD_Name__c= OwnerMdName;
       
        AssFranchise.Owner_Address__c = OwnerAddr;
        AssFranchise.Street_Address__c = StreetAddr;
        AssFranchise.Pin_Code__c = Pincode;
        AssFranchise.SAP_Code__c = SAPCode;
        AssFranchise.Since__c = since;
       
        AssFranchise.Location__c= Location;
        insert AssFranchise;
        return AssFranchise;
         }
    
    Public static User_Tracking__c CreatUserTracking (Datetime checkindttime){
        User_Tracking__c AssUsertrck = New User_Tracking__c();
        AssUsertrck.Checkin_Datetime__c = checkindttime;
         insert AssUsertrck;
         return AssUsertrck;

    }
    Public static Warehouse__c CreateWarehouse (string Name,string city,string location,string pincode,string state,string streetAdd){
       Warehouse__c WarehouseInstance = New  Warehouse__c();
        WarehouseInstance.Name =  Name;
        WarehouseInstance.City__c= city;
        WarehouseInstance.Location__c = location;
        WarehouseInstance.Pin_Code__c= pincode;
        WarehouseInstance.State__c = state;
        WarehouseInstance.Street_Address__c=streetAdd;
        
        insert WarehouseInstance;
        return WarehouseInstance;
    }
    Public static Shift_Assignment__c ShiftAssignment (string agent,integer sequence,string shiftManager){
      Shift_Assignment__c AssShift = New   Shift_Assignment__c();
        AssShift.Agent__c= agent;
        AssShift.Sequence__c = sequence;
        AssShift.Shift_Manager__c = shiftManager;
        insert AssShift;
        return AssShift;
    }
    }