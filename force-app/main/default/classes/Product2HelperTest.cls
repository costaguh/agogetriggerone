@isTest
private class Product2HelperTest {
    
    @isTest
    static void scenario1(){
        Pricebook2 pb = new Pricebook2(Name='Pricebook', isActive=true);
        insert pb;

    	Product2 testProduct2 = new Product2(
        	Name = 'Teste'
        );
        
        Insert testProduct2;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id=pb.Id,
            Product2Id=testProduct2.Id,
            UnitPrice=100.00,
            IsActive=true
        );
        insert pbe;
        
        
        
        System.debug(testProduct2);
    }	
}