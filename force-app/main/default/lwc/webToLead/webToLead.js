import { LightningElement } from 'lwc';

export default class WebToLead extends LightningElement {
    recordId;

    connectedCallback(){
        const params = new URL(window.location.href).searchParams;
        this.recordId = params.get('id'); // "1
        // https://whitemart--partial.lightning.force.com/c/WebToLeadApp.app
        // 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&qzone=1&data=' + 'https://whitemart--partial.lightning.force.com/c/WebToLeadApp.app?id=' + Id
        // 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&qzone=1&data=' + 'https://baski514.github.io/frenchwhitemart.github.io/?id=' + Id
    }
}