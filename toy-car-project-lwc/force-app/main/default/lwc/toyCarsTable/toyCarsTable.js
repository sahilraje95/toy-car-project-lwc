import { LightningElement } from 'lwc';
import getToyCarsList from '@salesforce/apex/ToyCarController.getToyCarsList';
import toyCarLogos from '@salesforce/resourceUrl/toyCarLogos';

export default class ToyCarsTable extends LightningElement {

    toyCarLogos = toyCarLogos;
    toyCarsList = [];
    imgSrc = '';
    layoutButtonIcon = 'utility:tile_card_list'
    filterValue = 'all';
    imageNotFoundMessage = 'Image not found'
    noItemsFoundMessage = 'No items found'
    listHeading = 'Toy Cars List'
    changeLayoutHeading = 'Change layout'
    
    get isDataListView() {
        return this.layoutButtonIcon === 'utility:tile_card_list' ? true : false;
    }

    get filterOptions() {
        return [
            { label: 'Sort by Toy Mfg', value: 'all' },
            { label: 'Sort by Car Mfg', value: 'carMfgAsc' },                        
            { label: 'Sort by Car Date', value: 'carDateAsc' },                        
            { label: 'Open for trade', value: 'openForTrade' },
        ];
    }

    get isDataListEmpty() {
        return this.toyCarsList.length ? false : true;
    }

    connectedCallback() {
        this.getToyCarsList();
    }

    getToyCarsList() {
        getToyCarsList({ 
            filterValue: this.filterValue
        })
            .then(result => {
                // console.log('Response from getToyCarsList:', result);                 
                this.imgSrc = window.location.origin + '/sfc/servlet.shepherd/version/download/';
                // console.log('Logo URL:',window.location.origin + this.toyCarLogos + '/hot-wheels-logo.png')
                result.forEach((item, idx) => {
                   item.idx = idx + 1;
                   if (item.photoUrl) {
                       item.photoUrl = this.imgSrc + item.photoUrl;
                   }                   
                   item.toyCarManufacturerLogoUrl = window.location.origin + toyCarLogos + '/'+ item.toyManufacturerName.toLowerCase().replaceAll(' ','-') + '-logo.png';
                   if(item.carManufacturerName!=='Fantasy') {
                        item.isFantasy = false;
                        item.carManufacturerLogoUrl = window.location.origin + toyCarLogos + '/'+ item.carManufacturerName.toLowerCase().replaceAll(' ','-') + '-logo.png';
                   } else {
                        item.isFantasy = true;
                   }
                });
                // console.log('Modified response from getToyCarsList:', result);
                this.toyCarsList = result;
            })
            .catch(error => {
                console.error('Error in getToyCarsList:', error);
            })
    }

    handleClickLayout() {
        this.layoutButtonIcon = (this.layoutButtonIcon === 'utility:tile_card_list') ? 'utility:list' : 'utility:tile_card_list';
    }

    handleChangeFilter(e) {
        this.filterValue = e.detail.value;
        // console.log('Filter value:',this.filterValue);
        this.getToyCarsList();
    }

}