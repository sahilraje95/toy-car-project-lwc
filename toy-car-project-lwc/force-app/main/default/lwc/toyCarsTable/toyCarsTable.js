import { LightningElement } from 'lwc';
import getToyCarsList from '@salesforce/apex/ToyCarController.getToyCarsList';
import toyCarsImages from '@salesforce/resourceUrl/toyCarsImages';

export default class ToyCarsTable extends LightningElement {

    toyCarsList = [];
    toyCarsImagesURL = toyCarsImages;

    connectedCallback() {
        this.getToyCarsList();
    }

    getToyCarsList() {
        getToyCarsList()
            .then(result => {
                // console.log('Result:', result);
                result.forEach((item, idx) => {
                    item.idx = idx + 1;
                    if (item.Photo__c) {
                        item.Photo__c = this.toyCarsImagesURL + '/images/' + item.Photo__c;
                    }
                });
                // console.log('Result:', result);
                this.toyCarsList = result;
            })
            .catch(error => {
                console.error('Error:', error);
            })
    }
}