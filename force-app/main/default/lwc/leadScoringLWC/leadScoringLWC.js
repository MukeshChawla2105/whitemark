import { LightningElement, wire ,track} from 'lwc';
import getContactFields from '@salesforce/apex/DependentPicklistGenerator.getContactFields';

export default class DependentPicklistGenerator extends LightningElement {
    @wire(getContactFields) wiredContactFields;
}