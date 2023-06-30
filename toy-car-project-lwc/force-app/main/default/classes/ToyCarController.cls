public with sharing class ToyCarController {
    
    public class ToyCarWrapper {
        @AuraEnabled 
        public Id toyCarId;
        @AuraEnabled 
        public String carManufacturerName;
        @AuraEnabled
        public Decimal carYear;
        @AuraEnabled
        public String toyCarName;
        @AuraEnabled
        public String toyManufacturerName;
        @AuraEnabled
        public String color;
        @AuraEnabled
        public String variant;
        @AuraEnabled
        public String photoUrl;
    }    

    @AuraEnabled
    public static List<ToyCarWrapper> getToyCarsList() {
        try {
            Set<Id> setOfToyCarIds = new Set<Id>();
            for(Toy_Car__c tc: [SELECT Id FROM Toy_Car__c]) {
                setOfToyCarIds.add(tc.Id);
            }
            /*
            System.debug('Toy Car IDS: '+ setOfToyCarIds);
            system.debug('SET size = ' + setOfToyCarIds.size());
            for (ID a : setOfToyCarIds) {
                System.debug('A Toy car ID = ' + a);
            } 
            */
            Map<Id, Id> mapOfToyCarToContentVersionId = new Map<Id, Id>();            
            for(ContentDocumentLink cdl: [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :setOfToyCarIds]) {
                mapOfToyCarToContentVersionId.put(cdl.LinkedEntityId, cdl.ContentDocument.LatestPublishedVersionId);
            }
            // System.debug('Map of Toy car to CDL: '+mapOfToyCarToContentVersionId);

            List<ToyCarWrapper> toyCarWrapperList = new List<ToyCarWrapper>();     
            ToyCarWrapper toyCarWrapperObj;
            for(Toy_Car__c toyCar: [
                SELECT 
                Id, 
                Car_Manufacturer__c,
                Car_Year__c,
                Color__c,
                Name,
                Toy_Car_Name__c,
                Toy_Manufacturer__r.Toy_Manufacturer_Name__c,
                Toy_Year__c,
                Car_Manufacturer__r.Car_Manufacturer_Name__c,
                Variant__c,
                Pack__c
                FROM Toy_Car__c
                ORDER BY Car_Manufacturer__r.Car_Manufacturer_Name__c]) {
                    toyCarWrapperObj = new ToyCarWrapper();
                    toyCarWrapperObj.toyCarId = toyCar.Id;
                    toyCarWrapperObj.carManufacturerName = toyCar.Car_Manufacturer__r.Car_Manufacturer_Name__c;
                    toyCarWrapperObj.carYear = toyCar.Car_Year__c;
                    toyCarWrapperObj.toyCarName = toyCar.Toy_Car_Name__c;
                    toyCarWrapperObj.toyManufacturerName = toyCar.Toy_Manufacturer__r.Toy_Manufacturer_Name__c;
                    toyCarWrapperObj.color = toyCar.Color__c;
                    toyCarWrapperObj.variant = toyCar.Variant__c;
                    toyCarWrapperObj.photoUrl = mapOfToyCarToContentVersionId.get(toyCar.Id);
                    toyCarWrapperList.add(toyCarWrapperObj);
                }
            if(toyCarWrapperList.size()>0) {
                return toyCarWrapperList;
            } else {
                return new List<ToyCarWrapper>();
            }
        } catch (Exception ex) {
            System.debug('Exception in getRecordAttachments: ' + ex + ', Cause: ' + ex.getCause() + ', Line number: ' + ex.getLineNumber() + ', Message: ' + ex.getMessage() + ', Get stack trace: ' + ex.getStackTraceString() + ', Get type: ' + ex.getTypeName());
            throw new AuraHandledException(ex.getMessage());            
        }
    }

}