import { LightningElement, track, api, wire } from 'lwc';
import FetchRecentOpportunities from '@salesforce/apex/EditOpportunity.FetchRecentOpportunities';
import showOppLineItem from '@salesforce/apex/EditOpportunity.showOppLineItem';
import showProductListForEdit from '@salesforce/apex/EditOpportunity.showProductListForEdit';
import InsertUpdatedLineItem from '@salesforce/apex/EditOpportunity.InsertUpdatedLineItem';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';


const columns = [{ label: 'Product Name', fieldName: 'Name' },
                { label: 'MRP', fieldName: 'MRP__c' },
                { label: 'MOP1', fieldName: 'MOP1__c' },
                { label: 'MOP1', fieldName: 'MOP2__c' }];
                const DELAY = 300;
export default class EditCustomOpportunityUsingApex extends LightningElement {

    debugger;
    @api OppId;

    @api ResultReturned;

    @track EditCardVisible = true;
    @track HandleInputShow = true;
    @track HandleOppLineItemShow = false;
    @track HandleFirstNext = true;
    @track HandleSecondNext = false;
    @track ShowAddProductButton = false;
    @track HandleUpdateButton = false;
    @track FetchedOppLineItem ;
    HandleOppEdit() {
        debugger;
        this.EditCardVisible = true;

    }

    HandleFirstButton() {
        debugger;

        this.connectedCallback();

        this.HandleInputShow = false;
        this.HandleOppLineItemShow = true;
        this.HandleFirstNext = false;
        this.HandleSecondNext = true;
        this.ShowAddProductButton = true;


    }

    closeModal(event) {
        this.SelectedProductList = [];
        this.EditCardVisible = false;
        const selectEvent = new CustomEvent('CloseEditOppModal', {
            detail: { Message: 'Close' }
        });
        this.dispatchEvent(selectEvent);
        // eval("$A.get('e.force:refreshView').fire();");
    }

    FetchedOppRecord = {};
    @track updatedOpprecord = {};

    

    connectedCallback() {
        debugger;
        FetchRecentOpportunities({ OppRecId: this.OppId })
            .then(result => {

                //this.FetchedOppRecord = Object.assign({}, result);
                this.FetchedOppRecord = result;
                console.log('Fetched Opp=' + JSON.stringify(this.FetchedOppRecord));
            })
            .catch(error => {

                console.log('error=' + error);
            })

        showOppLineItem({ OppRecId: this.OppId })
            .then(result => {
                debugger;
                this.FetchedOppLineItem = result;//Object.assign({}, result);
                //this.FetchedOppLineItem = result;
                console.log('Fetched OppLI=' + JSON.stringify(this.FetchedOppLineItem));

            })
            .catch(error => {

                console.log('error=' + error);
            })

    }

    ChngedOppName;
    HandleChangedInput(event) {
        debugger;
        this.updatedOpprecord = this.FetchedOppRecord;
        this.ChngedOppName = event.target.value;
        var targetname = event.target.name;
        console.log('ChangedName=' + this.ChngedOppName);

        if (event.target.name == 'oppname') {
            if (this.ChngedOppName != this.FetchedOppRecord.Name) {
                
                this.FetchedOppRecord.Name = this.ChngedOppName;
                  console.log('FetchedOppRecord.Name=' + this.FetchedOppRecord.Name);


            }
        }
        else if (event.target.name == 'stagename') {
            if (this.ChngedOppName != this.FetchedOppRecord.StageName) {
                
                //this.updatedOpprecord.StageName = this.ChngedOppName ? this.ChngedOppName : "";
                this.FetchedOppRecord.StageName = this.ChngedOppName;
                //console.log('FetchedOppRecord.Name=' + this.FetchedOppRecord.StageName);
            }
        }
        else if (event.target.name == 'closedatename') {
            if (this.ChngedOppName != this.FetchedOppRecord.CloseDate) {
                //this.updatedOpprecord.CloseDate = this.ChngedOppName ? this.ChngedOppName : "";
                this.FetchedOppRecord.CloseDate = this.ChngedOppName;
                //console.log('FetchedOppRecord.Name=' + this.FetchedOppRecord.CloseDate);
            }

        }

        // console.log('FetchedOppRecord='+);
    }

    @track ProductColumns = columns;

    @track ProductData;

    @track HandleSearchValue;

    @track HandleProductData = false;

    // HandleProductSearchNextAdd(event) {
    //     this.HandleSearchValue = event.target.value;
    //     showProductListForEdit({ ProductName: this.HandleSearchValue })
    //         .then(result => {
    //             this.ProductData = result;
    //         })

    // }


    @track error;

    @track searchText = '';

    @track showSpinner;
    
    typingTimer;
    searchTextHelper = '';
    HandleProductSearchNextAdd(event) {
        debugger;
        this.searchTextHelper = event.target.value;
        window.clearTimeout(this.typingTimer);
        this.typingTimer = setTimeout(() => {
            this.showSpinner = true;
            this.searchText = this.searchTextHelper;
        }, DELAY);
    }

    @wire(showProductListForEdit, { productName: '$searchText' })
    wiredProducts({ error, data }) {
        debugger;
        this.showSpinner = false;
        if (data) {
            this.ProductData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    picklistvalue

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STAGE_FIELD })
    StagePicklistValues


    handleChange(event) {
        this.picklistvalue = event.detail.value;

    }

    HandleAddProduct() {
        this.HandleProductData = true;
        this.HandleOppLineItemShow = false;
        this.ShowAddProductButton = false;
    }

    SelectedProductList = [];

    getSelectedValue(event) {
        debugger;

        for (let i = 0; i < event.detail.selectedRows.length; i++) {
            if(this.SelectedProductList.includes(event.detail.selectedRows[i])){

            }else{
                this.SelectedProductList.push(event.detail.selectedRows[i]);
            }
        }
        //this.SelectedProductList.push(event.detail.selectedRows);
        
        this.SelectedProductList = removeDuplicates(this.SelectedProductList);
        console.log('SelectedProductList=' + JSON.stringify(this.SelectedProductList));
         
     
    }

    removeDuplicates(arr) {
        var unique = [];
        arr.forEach(element => {
            if (!unique.includes(element)) {
                unique.push(element);
            }
        });
        return unique;
    }

    @track ShowProductData = false;
    HandleSecondButton() {
        this.SelectedProductList.sort((a, b) => (a.Name > b.Name) ? 1 : -1);
        this.HandleProductData = false;
        this.HandleOppLineItemShow = true;
        this.ShowProductData = true;
        this.HandleUpdateButton = true;
        this.HandleSecondNext = false;

    }

    //Inserting OpportunityLine Item

    updatedQuantity;
    HandleQuantityValueChange(event) {
        debugger;
        this.updatedQuantity = event.target.value;
        this.textid = event.target.dataset.id;

        let updatesdselectedProductsQuantity = [];
        this.SelectedProductList.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: this.updatedQuantity ? this.updatedQuantity : " ",
                    FinalPrice__c: prod.FinalPrice__c ? prod.FinalPrice__c : ""
                })
            }


            else {
                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: prod.ProductQuantity__c ? prod.ProductQuantity__c : "",
                    FinalPrice__c: prod.FinalPrice__c ? prod.FinalPrice__c : ""
                })
            }
        })
        this.SelectedProductList = updatesdselectedProductsQuantity;
        console.log('SelectedProduct  Quantity=' + JSON.stringify(this.SelectedProductList));


    }

    newFinalValue

    HandleFinalValueChange(event) {
        this.newFinalValue = event.target.value;
        this.textid = event.target.dataset.id;
        console.log('The TextId=' + this.textid);


        let QuoteDetails = this.record;
        let updatesdselectedProducts = [];
        this.SelectedProductList.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProducts.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: prod.ProductQuantity__c ? prod.ProductQuantity__c : " ",
                    FinalPrice__c: this.newFinalValue ? this.newFinalValue : ""

                })
            }


            else {
                updatesdselectedProducts.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: prod.ProductQuantity__c ? prod.ProductQuantity__c : " ",
                    FinalPrice__c: prod.FinalPrice__c ? prod.FinalPrice__c : ""
                })
            }
        })
        this.SelectedProductList = updatesdselectedProducts;
        console.log('SelectedProduct  FinalPrice=' + JSON.stringify(this.SelectedProductList));

    }



    //Updating The Opportunity Line Item

    UpdateOppLineItemQuantity;
    HandleQuantityChange(event) {
        debugger;
        this.UpdateOppLineItemQuantity = event.target.value;
        this.textid = event.target.dataset.id;

        let updatesdselectedProductsQuantity = [];
        this.FetchedOppLineItem.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    UnitPrice: prod.UnitPrice ? prod.UnitPrice : "",
                    ListPrice: prod.ListPrice ? prod.ListPrice : "",
                    Quantity: this.UpdateOppLineItemQuantity ? this.UpdateOppLineItemQuantity : " ",
                    TotalPrice: prod.TotalPrice ? prod.TotalPrice : ""
                })
            }


            else {
                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    UnitPrice: prod.UnitPrice ? prod.UnitPrice : "",
                    ListPrice: prod.ListPrice ? prod.ListPrice : "",
                    Quantity: prod.Quantity ? prod.Quantity : "",
                    TotalPrice: prod.TotalPrice ? prod.TotalPrice : ""
                })
            }
        })
        this.FetchedOppLineItem = updatesdselectedProductsQuantity;
        console.log('Updated OppLineItemList Quantity=' + JSON.stringify(this.FetchedOppLineItem));

    }

    UpdateOppLineItemTotalPrice
    HandleTotalPriceChange(event) {
        debugger;
        this.UpdateOppLineItemTotalPrice = event.target.value;
        this.textid = event.target.dataset.id;

        let updatesdselectedProductsPrice = [];
        this.FetchedOppLineItem.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProductsPrice.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    UnitPrice: prod.UnitPrice ? prod.UnitPrice : "",
                    ListPrice: prod.ListPrice ? prod.ListPrice : "",
                    Quantity: prod.Quantity ? prod.Quantity : "",
                    TotalPrice: this.UpdateOppLineItemTotalPrice ? this.UpdateOppLineItemTotalPrice : ""
                })
            }


            else {
                updatesdselectedProductsPrice.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    UnitPrice: prod.UnitPrice ? prod.UnitPrice : "",
                    ListPrice: prod.ListPrice ? prod.ListPrice : "",
                    Quantity: prod.Quantity ? prod.Quantity : "",
                    TotalPrice: prod.TotalPrice ? prod.TotalPrice : ""
                })
            }
        })
        this.FetchedOppLineItem = updatesdselectedProductsPrice;
        console.log('Updated OppLineItemList TotalPrice=' + JSON.stringify(this.FetchedOppLineItem));


    }


    HandleThirdButton() {
        this.FetchedOppRecord;
        debugger;
        InsertUpdatedLineItem({ GetNewProductList: this.SelectedProductList, UpdateOppLineItem: this.FetchedOppLineItem, UpdatedOpp: this.FetchedOppRecord })
            .then(result => {

                if (result == 'SUCCESS') {
                    // windows.alert('Succesfully Inserted OppLineItem');
                    console.log('FetchedOppRecord AfterUpdate cLICK=' + JSON.stringify(this.FetchedOppRecord));
                    this.ResultReturned == 'SUCCESS';
                    this.EditCardVisible = false;
                    const selectEvent = new CustomEvent('CloseEditOppModal', {
                        detail: { Message: 'Close' }
                    });
                    this.dispatchEvent(selectEvent);
                    eval("$A.get('e.force:refreshView').fire();");


                }
            })
            .catch(error => {

                console.log(error);
            })
    }




}