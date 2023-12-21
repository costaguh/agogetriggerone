public with sharing class Product2TriggerHandler {
	List<Product2> oldRecords {get; set;}
    List<Product2> newRecords {get; set;}
    Map<Id, Product2> oldMap {get; set;}
    Map<Id, Product2> newMap {get; set;}

    public Product2TriggerHandler(List<Product2> oldRecords, List<Product2> newRecords, 
    Map<Id, Product2> oldMap, Map<Id, Product2> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void afterUpdate() {        
        Product2Helper.productCreatePricebookEntry(this.newRecords);        
    }

    public void afterInsert() {       
        Product2Helper.productCreatePricebookEntry(this.newRecords);
    }
}