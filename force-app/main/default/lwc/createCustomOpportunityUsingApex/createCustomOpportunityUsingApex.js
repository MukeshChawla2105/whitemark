import { LightningElement ,track, wire} from 'lwc';
import showProductList from '@salesforce/apex/OpportunityTask.showProductList';
import CreateOpportunityTrail from '@salesforce/apex/OpportunityTask.CreateOpportunity';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';

const columns=[{label:'Product Name',fieldName:'Name'}];

export default class CreateCustomOpportunityUsingApex extends LightningElement {

    @track ModalVisible=false;

    HandlePopUp(){
      this.ModalVisible=true;

    }
    HandleCancel(){
        this.ModalVisible=false;
    }
    closeModal(){
        this.ModalVisible=false;
        eval("$A.get('e.force:refreshView').fire();");
    }
    @track name;
    @track Cdate;
    //@track stageValue;
    @track columns=columns;

    picklistvalue

    @wire(getObjectInfo, {objectApiName:OPPORTUNITY_OBJECT})
    objectInfo

    @wire(getPicklistValues, { recordTypeId:'$objectInfo.data.defaultRecordTypeId', fieldApiName:STAGE_FIELD})
    StagePicklistValues

    
    handleChange(event){
           this.picklistvalue=event.detail.value;
           
    }
   

    HandleChangename(event){
        this.name=event.target.value;

    }
    HandleChangeDate(event){
        this.Cdate=event.target.value;
    }

     OppData={};

    HandleFirstNext(){
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
             this.OppData={
                Oppname:this.name,
                Oppstage:this.picklistvalue,
                oppClosedate:this.Cdate,

            }
            //this.selectedOppData=OppData;
            console.log('Opp Data='+JSON.stringify(this.OppData));

           // eval("$A.get('e.force:refreshView').fire();");

            //console.log('Selected Opp Data='+JSON.stringify(this.selectedOppData));
            if(this.name==null || this.picklistvalue==null || this.Cdate==null ){

                window.alert('Your One Field Is  Empty');
                this.template.querySelector('div.stepOne').classList.remove('slds-hide');
                this.template .querySelector('div.stepTwo') .classList.add('slds-hide');
            }
            
    }

    @track data;

    @track HandleChangeValue;

            HandleProductSearch(event){  
                this.HandleChangeValue=event.target.value;
                showProductList({ProductName:this.HandleChangeValue})
                .then(result=>{
                    this.data=result;
                })
                
                
            }

    // @wire(showProductList)
    //  wiredProduct({data,error}){
    //     if(data){
          
    //         this.data=data;
    //     }
    //     else if(error){
    //         console.log(error);
    //     }
          
    //  }

     HandlePrevious(){
        this.template.querySelector('div.stepOne').classList.remove('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.add('slds-hide');
     }


     @track selectedProducts=[];
     selectedProductId=[];
    
    
     getSelectedValue(event) {
        debugger;
        // var selectedRows=event.detail.selectedRows;
        // if(selectedRows.length>1)
        // {
        //     var el = this.template.querySelector('lightning-datatable');
        //     selectedRows=el.selectedRows=el.selectedRows.slice(1);
        //     event.preventDefault();
        //     return;
        // }
    
        const selectedRows = event.detail.selectedRows;
       
        
        
        for (let i = 0; i < selectedRows.length; i++) {
           //alert('You selected: ' + JSON.stringify(selectedRows[i]));
          
           //selectedProducts.push(selectedRows[i]);
           alert('You selected: ' + selectedRows[i]);

           

           if(!this.selectedProductId.includes(selectedRows[i].Id)){
             
            this.selectedProductId.push(selectedRows[i].Id);

            this.selectedProducts.push(selectedRows[i]);
           
           }

           console.log('selectedProduct='+JSON.stringify(this.selectedProducts));
           //console.log('Selected Product Id='+JSON.stringify(this.selectedProductId));
        }
    }

    

    HandleSecondNext(){
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
       
            if(this.selectedProducts.length <= 0){

                window.alert('Select Any Product');
                this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
                this.template.querySelector('div.stepThree').classList.add('slds-hide');

            }


    }
    HandlethirdPrevious(){
        this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.add('slds-hide');
    }
    FinalValue;
    HandleFinalValueChange(event){
        debugger;
            this.FinalValue=event.target.value;
            this.textid = event.target.dataset.id;
            console.log('The TextId='+this.textid);
        
            console.log('The Final Value='+this.FinalValue);
            let QuoteDetails = this.record;
        let updatesdselectedProducts = [];
        this.selectedProducts.forEach(prod => {
            if (this.textid == prod.Id) {
                
                updatesdselectedProducts.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    Product_List_Price__c: prod.Product_List_Price__c ? prod.Product_List_Price__c : "",
                    MOP_1__c: prod.MOP_1__c ? prod.MOP_1__c : "",
                    MOP_2__c: prod.MOP_2__c ? prod.MOP_2__c : "",
                    Product_Quantity__c: prod.Product_Quantity__c ? prod.Product_Quantity__c:" ",
                    Final_price__c: this.FinalValue ? this.FinalValue : ""
                    
                })
            }


          else{
            updatesdselectedProducts.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    Product_List_Price__c: prod.Product_List_Price__c ? prod.Product_List_Price__c : "",
                    MOP_1__c: prod.MOP_1__c ? prod.MOP_1__c : "",
                    MOP_2__c: prod.MOP_2__c ? prod.MOP_2__c : "",
                    Product_Quantity__c: prod.Product_Quantity__c ? prod.Product_Quantity__c:" ",
                    Final_price__c: prod.Final_price__c ? prod.Final_price__c : ""
                })
            }
        })
        this.selectedProducts = updatesdselectedProducts;
           

    }
    Quantity
    HandleQuantityValueChange(event){
        debugger;
        this.Quantity=event.target.value;
        this.textid = event.target.dataset.id;

        let updatesdselectedProductsQuantity = [];
        this.selectedProducts.forEach(prod => {
            if (this.textid == prod.Id) {
                
                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    Product_List_Price__c: prod.Product_List_Price__c ? prod.Product_List_Price__c : "",
                    MOP_1__c: prod.MOP_1__c ? prod.MOP_1__c : "",
                    MOP_2__c: prod.MOP_2__c ? prod.MOP_2__c : "",
                    Product_Quantity__c: this.Quantity ? this.Quantity:" ",
                    Final_price__c: prod.Final_price__c ? prod.Final_price__c : ""
                })
            }


          else{
            updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    Product_List_Price__c: prod.Product_List_Price__c ? prod.Product_List_Price__c : "",
                    MOP_1__c: prod.MOP_1__c ? prod.MOP_1__c : "",
                    MOP_2__c: prod.MOP_2__c ? prod.MOP_2__c : "",
                    Product_Quantity__c: prod.Product_Quantity__c ? prod.Product_Quantity__c:"",
                    Final_price__c: prod.Final_price__c ? prod.Final_price__c : ""
                })
            }
        })
        this.selectedProducts = updatesdselectedProductsQuantity;
           

    }

    //

    HandleSave(){
        debugger;
        CreateOpportunityTrail({name:this.OppData.Oppname,closeDate:this.OppData.oppClosedate,Stage:this.OppData.Oppstage,Productlist:this.selectedProducts})
        .then(result=>{
            debugger;
          console.log('Result Opp='+result)
          if(result=='SUCCESS'){

            window.alert('SucessFully Created Opportunity');
            this.ModalVisible=false;
            eval("$A.get('e.force:refreshView').fire();");
            
          }

        })
        .catch(error=>{
            console.log(error);

        })
       

        //eval("$A.get('e.force:refreshView').fire();");
         //($A.get("e.force:closeQuickAction").fire());
         //this.dispatchEvent( new CloseActionScreenEvent() );
    }
          
}