import { LightningElement, track, wire, api } from 'lwc';
import showProductList from '@salesforce/apex/OpportunityTask.showProductList';
import CreateOpportunityTrail from '@salesforce/apex/OpportunityTask.CreateOpportunity';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
const columns = [{ label: 'Product Name', fieldName: 'Name' },
                    { label: 'MRP', fieldName: 'MRP__c' },
                    { label: 'MOP1', fieldName: 'MOP1__c' },
                    { label: 'MOP2', fieldName: 'MOP2__c' }];
const DELAY = 300;
export default class CreateOpportunityAndOppLineItem extends LightningElement {

    @api AccrecID;
    @track ModalVisible = false;

    @track ShowProductData = false;
    HandlePopUp() {
        this.ModalVisible = true;

    }
    HandleCancel() {
        this.ShowProductData = false;
        this.selectedRows = [];
        this.ModalVisible = false;
        this.clearCache();
    }
    closeModal() {
        debugger;
        this.ShowProductData = false;
        this.selectedRows = [];
        this.ModalVisible = false;

        this.clearCache();
        this.clearProductList();
        eval("$A.get('e.force:refreshView').fire();");
    }
    @track name;
    @track Cdate;
    //@track stageValue;
    @track columns = columns;

    picklistvalue

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STAGE_FIELD })
    StagePicklistValues

    //@track productId;
    handleChange(event) {
        this.picklistvalue = event.detail.value;

    }


    HandleChangename(event) {
        this.name = event.target.value;

    }
    HandleChangeDate(event) {
        this.Cdate = event.target.value;
    }

    //selectedOppData={};
    OppData = {};

    HandleFirstNext() {
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
        this.OppData = {
            Oppname: this.name,
            Oppstage: this.picklistvalue,
            oppClosedate: this.Cdate,

        }
        console.log('Opp Data=' + JSON.stringify(this.OppData));
        if (this.name == null || this.picklistvalue == null || this.Cdate == null) {

            window.alert('Your One Field Is  Empty');
            this.template.querySelector('div.stepOne').classList.remove('slds-hide');
            this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        }

    }

    @track data;
    @track error;

    @track searchText = '';

    @track showSpinner;
    
    typingTimer;
    searchTextHelper = '';
    HandleProductSearch(event) {
        debugger;
        this.searchTextHelper = event.target.value;
        window.clearTimeout(this.typingTimer);
        this.typingTimer = setTimeout(() => {
            this.showSpinner = true;
            this.searchText = this.searchTextHelper;
        }, DELAY);
    }

    @wire(showProductList, { productName: '$searchText' })
    wiredProducts({ error, data }) {
        debugger;
        this.showSpinner = false;
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }




    HandlePrevious() {
        this.template.querySelector('div.stepOne').classList.remove('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.add('slds-hide');
    }
    @track selectedProducts = [];
    selectedProductId = [];

    selectedRows = [];

    getSelectedValue(event) {
        debugger;

        for (let i = 0; i < event.detail.selectedRows.length; i++) {
            if (this.selectedRows.includes(event.detail.selectedRows[i])) {

            } else {
                this.selectedRows.push(event.detail.selectedRows[i]);
            }
        }
        //this.ShowProductData = true;
        console.log('SelectedProductList=' + JSON.stringify(this.selectedRows));
    }


    HandleSecondNext() {
        debugger;
        this.selectedRows.sort((a, b) => (a.Name > b.Name) ? 1 : -1);
        this.ShowProductData = true;
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');

        if (this.selectedRows.length <= 0) {

            window.alert('Select Any Product');
            this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
            this.template.querySelector('div.stepThree').classList.add('slds-hide');

        }


    }
    HandleSecondPrevious() {
        this.ShowProductData = false;
        this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.add('slds-hide');


    }
    FinalValue;
    HandleFinalValueChange(event) {
        debugger;
        this.FinalValue = event.target.value;
        this.textid = event.target.dataset.id;
        console.log('The TextId=' + this.textid);

        console.log('The Final Value=' + this.FinalValue);
        let QuoteDetails = this.record;
        let updatesdselectedProducts = [];
        this.selectedRows.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProducts.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: prod.ProductQuantity__c ? prod.ProductQuantity__c : " ",
                    FinalPrice__c: this.FinalValue ? this.FinalValue : ""

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
        this.selectedRows = updatesdselectedProducts;


    }
    Quantity
    HandleQuantityValueChange(event) {
        debugger;
        this.Quantity = event.target.value;
        this.textid = event.target.dataset.id;

        let updatesdselectedProductsQuantity = [];
        this.selectedRows.forEach(prod => {
            if (this.textid == prod.Id) {

                updatesdselectedProductsQuantity.push({
                    Id: prod.Id ? prod.Id : "",
                    Name: prod.Name ? prod.Name : "",
                    ProductCode: prod.ProductCode ? prod.ProductCode : "",
                    MRP__c: prod.MRP__c ? prod.MRP__c : "",
                    MOP1__c: prod.MOP1__c ? prod.MOP1__c : "",
                    MOP2__c: prod.MOP2__c ? prod.MOP2__c : "",
                    ProductQuantity__c: this.Quantity ? this.Quantity : " ",
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
        this.selectedRows = updatesdselectedProductsQuantity;


    }

    //

    HandleSave() {
        debugger;
        CreateOpportunityTrail({ AccounRecId: this.AccrecID, name: this.OppData.Oppname, closeDate: this.OppData.oppClosedate, Stage: this.OppData.Oppstage, Productlist: this.selectedRows })
            .then(result => {
                debugger;
                console.log('Result Opp=' + result)
                if (result == 'SUCCESS') {

                    window.alert('SucessFully Created Opportunity');
                    this.clearCache();
                    // this.clearProductList();

                    this.ModalVisible = false;
                    eval("$A.get('e.force:refreshView').fire();");
                    //eval("$A.get('e.force:refreshView').fire();");




                }

            })
            .catch(error => {
                console.log(error);

            })


        //eval("$A.get('e.force:refreshView').fire();");
        //($A.get("e.force:closeQuickAction").fire());
        //this.dispatchEvent( new CloseActionScreenEvent() );
    }

    HandleCancelBeforeSave() {
        this.clearProductList();
        this.ModalVisible = false;
        this.clearCache();

    }


    clearCache() {

        this.name = null;
        this.Cdate = null;
        this.picklistvalue = null;

        //this.OppData=null;
    }

    clearProductList() {

        this.selectedProducts = null;
    }


    fixedWidth;

    handlemouseup(e) {
        this._tableThColumn = undefined;
        this._tableThInnerDiv = undefined;
        this._pageX = undefined;
        this._tableThWidth = undefined;
    }

    handlemousedown(e) {
        if (!this._initWidths) {
            this._initWidths = [];
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                this._initWidths.push(th.style.width);
            });
        }

        this._tableThColumn = e.target.parentElement;
        this._tableThInnerDiv = e.target.parentElement;
        while (this._tableThColumn.tagName !== "TH") {
            this._tableThColumn = this._tableThColumn.parentNode;
        }
        while (!this._tableThInnerDiv.className.includes("slds-cell-fixed")) {
            this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
        }
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
        this._pageX = e.pageX;

        this._padding = this.paddingDiff(this._tableThColumn);

        this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
        console.log("handlemousedown this._tableThColumn.tagName => ", this._tableThColumn.tagName);
    }

    handlemousemove(e) {
        console.log("mousemove this._tableThColumn => ", this._tableThColumn);
        if (this._tableThColumn && this._tableThColumn.tagName === "TH") {
            this._diffX = e.pageX - this._pageX;

            this.template.querySelector("table").style.width = (this.template.querySelector("table") - (this._diffX)) + 'px';

            this._tableThColumn.style.width = (this._tableThWidth + this._diffX) + 'px';
            this._tableThInnerDiv.style.width = this._tableThColumn.style.width;

            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            let tableBodyTds = this.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }

    handledblclickresizable() {
        let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = this.template.querySelectorAll("table tbody tr");
        tableThs.forEach((th, ind) => {
            th.style.width = this._initWidths[ind];
            th.querySelector(".slds-cell-fixed").style.width = this._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
            let rowTds = row.querySelectorAll(".dv-dynamic-width");
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = this._initWidths[ind];
            });
        });
    }

    paddingDiff(col) {

        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }

        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padLeft, 10) + parseInt(this._padRight, 10));

    }

    getStyleVal(elm, css) {
        return (window.getComputedStyle(elm, null).getPropertyValue(css))
    }
}