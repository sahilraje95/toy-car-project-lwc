import { LightningElement } from 'lwc';
import getToyCarsList from '@salesforce/apex/ToyCarController.getToyCarsList';

export default class ToyCarsTable extends LightningElement {

    toyCarsList = [];
    imgSrc = '';

    connectedCallback() {
        this.getToyCarsList();
    }

    getToyCarsList() {
        getToyCarsList()
            .then(result => {
                // console.log('Response from getToyCarsList:', result);                 
                this.imgSrc = window.location.origin + '/sfc/servlet.shepherd/version/download/';
                 result.forEach((item, idx) => {
                    item.idx = idx + 1;
                    if (item.photoUrl) {
                        item.photoUrl = this.imgSrc + item.photoUrl;
                    }
                });
                // console.log('Modified response from getToyCarsList:', result);
                this.toyCarsList = JSON.parse(JSON.stringify(result));
            })
            .catch(error => {
                console.error('Error in getToyCarsList:', error);
            })
    }

}