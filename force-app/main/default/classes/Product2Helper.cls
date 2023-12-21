public class Product2Helper {
    public static void productCreatePricebookEntry(List<Product2> products){      

        List<PricebookEntry> listEntries = new List<PricebookEntry>();
        Id standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;

        for (Product2 product2 : products){
            PricebookEntry newPricebookEntry = new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = product2.Id,
                CurrencyIsoCode = product2.CurrencyIsoCode,
                UnitPrice = 0
            );
            listEntries.add(newPricebookEntry);
        }

        if (!listEntries.isEmpty()) {
            insert listEntries;
        }
    }
}