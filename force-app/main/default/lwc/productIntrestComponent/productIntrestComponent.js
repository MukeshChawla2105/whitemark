import { LightningElement,api,wire,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProducts from "@salesforce/apex/ProductIntrestController.getProducts";
import saveProductIntrest from '@salesforce/apex/ProductIntrestController.saveListProductIntrest';
import productDetails from '@salesforce/apex/ProductIntrestController.getProductDetails';
import deleteProduct from '@salesforce/apex/ProductIntrestController.deleteProductIntrest';
import LightningAlert from 'lightning/alert';
import LightningConfirm from "lightning/confirm";




export default class lwcDynamicRecordRowsCreation extends NavigationMixin(LightningElement) {
    
    @api leadId = '00Q1m000002Ob9nEAC';
    productOptions = [];
    @api selectedProduct ='';
debugger;

    @api fieldLabel;
    @api disabled = false;
    @track openDropDown = false;
    @track inputValue = "";
    @api placeholder = "";
    @api options;
    @track optionsToDisplay;
    @api value = "";
    @track label = "";
    delaytimeout;
    @api indexValue = '';
    @api productDetailRec = '';
    @api productToDelete = '';


    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        console.log('ItemList---',this.itemList);
        setTimeout(()=>this.selectChildProduct(),3000);
        
    }

    handleGauChange(event){
        debugger;
        this.selectedProduct = event.target.value;
    }

    closeModal() {
        debugger;
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    @wire(getProducts, {selectedleadId:'$leadId'})
    wireProductList({data,error}) {
        debugger;
        if(data) {
          //this.itemList = JSON.parse(data).map(record => ({ id: 0,Quantity:record.Quantity__c,MOP1__c:record.MOP1__c,MOP2__c:record.MOP2__c,total:record.Total__c ,MRP__c:record.MRP__c,productId:record.Product__c }));
         let productRecords = JSON.parse(data);
         if( productRecords.length == 0){
            debugger;
            this.itemList = [{index:0,Quantity__c:"",MOP1__c:"",MOP2__c:"",total:"",MRP__c:"",productId:"" ,Proposed_MRP__c:"",Proposed_Total__c:"" }];
         }else{
            this.itemList = [];
         }
         for(var i=0;i <productRecords.length;i++){
            this.itemList.push({ Id:productRecords[i].Id,index: i,Quantity__c:productRecords[i].Quantity__c,MOP1__c:productRecords[i].MOP1__c,MOP2__c:productRecords[i].MOP2__c,total:productRecords[i].Total__c ,MRP__c:productRecords[i].MRP__c,productId:productRecords[i].Product__c,Proposed_MRP__c:productRecords[i].Proposed_MRP__c,Proposed_Total__c:productRecords[i].Proposed_Total__c })
         }
         this.keyIndex = this.itemList.length;
          this.error = null;
        }else{
            debugger;
            //if (!Array.isArray(data)) {
                if (this.itemList.length <1) {
                    this.itemList.push({index:0,Quantity__c:"",MOP1__c:"",MOP2__c:"",total:"",MRP__c:"",productId:"",Proposed_MRP__c:"",Proposed_Total__c:"" }) 
                }
                  
            //}
            
        }
        if(error) {
          this.productOptions = [];
          this.error = error;
        }
      }

      selectChildProduct(id){
        debugger;
        // this.itemList.forEach(item=>{
        //     debugger;
        //     let childComp = this.template.querySelector('c-custom-lookup-comp[child-prod-id="'+item.productId+'"]');
        //     let cComp = this.template.querySelector("."+item.productId);

        //     if(cComp){
        //         cComp.handelSelectedRecord(item.productId);
        //     }
        //  })
               
      }

keyIndex = 0;
@track itemList = [];

addRow() {
    ++this.keyIndex;
    debugger;
    var newItem = [{index: this.keyIndex,Quantity__c:"",MOP1__c:"",MOP2__c:"",total:"",MRP__c:"",productId:"",Proposed_MRP__c:"",Proposed_Total__c:"" }];
    this.itemList = this.itemList.concat(newItem);
}

deleteProducts(){
    deleteProduct({productId:this.productToDelete})
}

removeRow(event) {
    debugger;
    console.log(this.keyIndex);
    if (this.itemList.length >= 2) {
        // if(this.itemList){
        //     productDetails({ productLineItemId: this.itemList })
        //     .then((result) => {
        //     })
        // }
        if(this.itemList[parseInt(event.target.accessKey)] && this.itemList[parseInt(event.target.accessKey)].Id){
            this.productToDelete = this.itemList[parseInt(event.target.accessKey)].Id;
            this.deleteProducts();
        }
        this.itemList = this.itemList.filter(function (element) {
            return parseInt(element.index) !== parseInt(event.target.accessKey);
        });
    }
}

handleSubmit() {
    let productIntrestedList = [];

       var j = 0;
        debugger;
        for(var i=0;i<this.itemList.length;i++){
            this.itemList[i];

            if ((this.itemList[i].Quantity__c == null  || this.itemList[i].Quantity__c == '') || (this.itemList[i].productId == null || this.itemList[i].productId == '')) {
                j++;
                
            }
            if ((this.itemList[i].Quantity__c != null &&  this.itemList[i].Quantity__c != undefined &&  this.itemList[i].Quantity__c != '') && (this.itemList[i].total != null && this.itemList[i].total != undefined && this.itemList[i].total != '') && (this.itemList[i].productId != null && this.itemList[i].productId != undefined && this.itemList[i].productId != '')  ) {
                productIntrestedList.push({Id:this.itemList[i].Id,Quantity__c:this.itemList[i].Quantity__c,Total__c:this.itemList[i].total,Product__c:this.itemList[i].productId,Lead__c:this.leadId,Proposed_MRP__c:this.itemList[i].Proposed_MRP__c,Proposed_Total__c:this.itemList[i].Proposed_Total__c});
            }
        }
        if (j>0) {
            this.handleAlert('Either Product or Quantity is Empty!!');
        }
        else{
            saveProductIntrest({ productListToInsert: productIntrestedList })
        .then((result) => {
            this.closeModal();
            this.handleConfirm('Product intrest successfully created');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Product intrest successfully created',
                    variant: 'success',
                }),
            );
        })

        }

        
}

lookupRecord(event){
    debugger;
    this.itemList[parseInt(event.target.dataset.index)].MOP1__c =event.detail.selectedRecord.MOP1__c;
    this.itemList[parseInt(event.target.dataset.index)].MOP2__c =event.detail.selectedRecord.MOP2__c;
    this.itemList[parseInt(event.target.dataset.index)].MRP__c =event.detail.selectedRecord.MRP__c; 
    this.itemList[parseInt(event.target.dataset.index)].productId =event.detail.selectedRecord.Id; 

    //alert('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
}

getProductDetailsList(){
    productDetails({ proId: this.selectedProduct })
    .then((result) => {
        debugger;
        this.productDetailRec = result;
        if (this.productDetailRec != null) {
            this.itemList[parseInt(this.indexValue)].MOP1__c =this.productDetailRec.MOP1__c ? this.productDetailRec.MOP1__c : '';
            this.itemList[parseInt(this.indexValue)].MOP2__c = this.productDetailRec.MOP2__c ? this.productDetailRec.MOP2__c : '';
            this.itemList[parseInt(this.indexValue)].MRP__c = this.productDetailRec.MRP__c ? this.productDetailRec.MRP__c : ''; 
            this.itemList[parseInt(this.indexValue)].productId = this.productDetailRec.Id ? this.productDetailRec.Id : ''; 
            
        }
        else{
            this.itemList[parseInt(this.indexValue)].MOP1__c ='';
            this.itemList[parseInt(this.indexValue)].MOP2__c = '';
            this.itemList[parseInt(this.indexValue)].MRP__c = ''; 
            this.itemList[parseInt(this.indexValue)].productId =  ''; 

        }
        
        
    })
    .catch((error) => {
      
    });
    
}

handleprodChange(event){
    debugger;
    this.indexValue = event.target.dataset.index;
    this.selectedProduct = event.target.value;
    this.getProductDetailsList();
   
}

handleProposedMRPChange(event) {
    debugger;
    let index = event.target.dataset.index;
    this.itemList[parseInt(event.target.dataset.index)].Proposed_Total__c =parseInt(this.itemList[parseInt(event.target.dataset.index)].Quantity__c) * event.detail.value;
    this.itemList[parseInt(event.target.dataset.index)].Proposed_MRP__c = event.detail.value;

    //want to get the index as well
}

handleQuantityChange(event) {
    debugger;
    let index = event.target.dataset.index;
    this.itemList[parseInt(event.target.dataset.index)].total =parseInt(this.itemList[parseInt(event.target.dataset.index)].MRP__c) * event.detail.value;
    this.itemList[parseInt(event.target.dataset.index)].Quantity__c = event.detail.value;
    //want to get the index as well
}
async handleAlert(message) {
    await LightningAlert.open({
        message: message,
        theme: "error",
        label: "Alert"
    }).then(() => {
        console.log("###Alert Closed");
    });
}

async handleConfirm(message) {
    await LightningAlert.open({
        message: message,
        theme: "SUCCESS",
        label: "SUCCESS"
    }).then(() => {
        console.log("###Alert Closed");
    });
}




}