public with sharing class ToyCarController {

    @AuraEnabled
    public static List<Toy_Car__c> getToyCarsList(){
        try {
            List<Toy_Car__c> toyCarList = new List<Toy_Car__c>([
                SELECT 
                Id, 
                Car_Manufacturer__c,
                Car_Year__c,
                Color__c,
                Photo__c,
                Name,
                Toy_Car_Name__c,
                Toy_Manufacturer__r.Toy_Manufacturer_Name__c,
                Toy_Year__c,
                Car_Manufacturer__r.Car_Manufacturer_Name__c,
                Variant__c,
                Pack__c
                FROM Toy_Car__c
                ORDER BY Car_Manufacturer__r.Car_Manufacturer_Name__c]);
            if(toyCarList.size()>0) {
                return toyCarList;
            } else {
                return new List<Toy_Car__c>();
            }
        } catch (Exception e) {
            return new List<Toy_Car__c>();
        }
    }

}
