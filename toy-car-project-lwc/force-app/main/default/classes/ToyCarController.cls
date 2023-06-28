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

    private static String getRecordAttachments(Id toyCarId){
        try {          
            String contentVersionId = '', contentDocumentLinkId = '';              
            // List<ContentDocumentLink> contentDocumentLinkList = 
            // [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType, ContentDocument.Title, ContentDocument.createdDate FROM ContentDocumentLink WHERE LinkedEntityId IN :setToyCarIds];
            List<ContentDocumentLink> contentDocumentLinkList = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :toyCarId LIMIT 1];
            // System.debug('ToyCarController getRecordAttachments contentDocumentLinkList debug: '+contentDocumentLinkList);
            if(contentDocumentLinkList.size() > 0) {
                contentDocumentLinkId = contentDocumentLinkList[0].Id;
                // System.debug('ToyCarController getRecordAttachments contentDocumentLink debug: '+contentDocumentLink);
                List<ContentVersion> contentVersionIdList = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId = :contentDocumentLinkList[0].ContentDocumentId LIMIT 1];
                // System.debug('ToyCarController getRecordAttachments contentVersionIdList debug: '+contentVersionIdList);
                if(contentVersionIdList.size() > 0) {
                    contentVersionId = contentVersionIdList[0].Id;
                    // System.debug('ToyCarController getRecordAttachments contentVersionId debug: '+contentVersionId);
                }
            }            
            return contentVersionId;                
        } catch (Exception ex) {
            System.debug('Exception in getRecordAttachments: ' + ex + ', Cause: ' + ex.getCause() + ', Line number: ' + ex.getLineNumber() + ', Message: ' + ex.getMessage() + ', Get stack trace: ' + ex.getStackTraceString() + ', Get type: ' + ex.getTypeName());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<ToyCarWrapper> getToyCarsList() {
        try {
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
                    toyCarWrapperObj.photoUrl = getRecordAttachments(toyCar.Id);
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