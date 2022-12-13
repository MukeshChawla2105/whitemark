import { LightningElement,api,track,wire } from 'lwc';
import getProductList from '@salesforce/apex/productDetailsLWCcontroller.getProductList';
import Name from '@salesforce/schema/Product2.Name';
import Brand__c from '@salesforce/schema/Product2.Brand__c';
import Capacity_Size__c from '@salesforce/schema/Product2.Capacity_Size__c';
import Colour__c from '@salesforce/schema/Product2.Colour__c';
import Description from '@salesforce/schema/Product2.Description';
import Family from '@salesforce/schema/Product2.Family';
import QuantityUnitOfMeasure from '@salesforce/schema/Product2.QuantityUnitOfMeasure';
import Consumer_Offer__c from '@salesforce/schema/Product2.Consumer_Offer__c';
import IsActive from '@salesforce/schema/Product2.IsActive';
import DisplayUrl from '@salesforce/schema/Product2.DisplayUrl';
import ExternalId from '@salesforce/schema/Product2.ExternalId';
import ExternalDataSourceId from '@salesforce/schema/Product2.ExternalDataSourceId';
import Sub_Category__c from '@salesforce/schema/Product2.Sub_Category__c';
import Warranty__c from '@salesforce/schema/Product2.Warranty__c';
import ProductCode from '@salesforce/schema/Product2.ProductCode';
import Star_Rating__c from '@salesforce/schema/Product2.Star_Rating__c';

export default class ProductDetailsLWC extends LightningElement {
    @api recordId='01t1m000002DDzpAAG';
    @api objectApiName='Product2';
    @api nameField=Name;
    @api brand=Brand__c;
    @api capacitySize=Capacity_Size__c;
    @api color=Colour__c;
    @api consumerOffer=Consumer_Offer__c;
    @api ProductDescription=Description;
    @api Family=Family;
    @api QuantityUnitOfMeasure=QuantityUnitOfMeasure
    @api Active=IsActive;
    @api SubCategory=Sub_Category__c;
    @api DisplayUrl=DisplayUrl;
    @api ExternalId=ExternalId;
    @api warrenty=Warranty__c;
    @api productCode=ProductCode;
    @api starrating=Star_Rating__c;

    @api ExternalDataSourceId=ExternalDataSourceId
    @track priceBookList=[]
    @track columns=[
        { label: 'Pricebook Name', fieldName: 'Price_Book_Name__c', type: 'Text' },
        { label: 'List Price', fieldName: 'UnitPrice', type: 'text' },
        { label: 'Use Standard Price', fieldName: 'UseStandardPrice', type: 'text' },
        { label: 'Active', fieldName: 'IsActive', type: 'checkbox' }
    ]

    @wire(getProductList,{prodid:'$recordId'})
    wireResponse({data,error}){
        debugger;
        if(data){
            this.priceBookList=data;
        }
        if(error){

        }
    }

}