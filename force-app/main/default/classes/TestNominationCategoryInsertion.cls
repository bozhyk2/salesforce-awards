@isTest
private class TestNominationCategoryInsertion {
    
    @testSetup static void setup() {
        // Create common test nomination categories
        List<NominationCategory__c> existNomCats = new List<NominationCategory__c>();
        existNomCats.addAll(TestDataFactory.createNominationCategory(0, 'The Best Boy', 3));
        insert existNomCats;        
    }
    
    @isTest static void testInsertOneNominationCategoryWithDiffName(){
        
        NominationCategory__c[] newNomCats = TestDataFactory.createNominationCategory(0, 'The Best Girl', 1);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(newNomCats[0]);
        Test.stopTest();
        
        System.assert(result.isSuccess());
     }
    
    @isTest static void testInsertBulkNominationCategoryWithDiffNames(){
        NominationCategory__c[] newNomCats = TestDataFactory.createNominationCategory(0, 'The Best Girl', 3);
        
      	Test.startTest();
        Database.SaveResult[] results = Database.insert(newNomCats);
        Test.stopTest();
        
        for(Database.SaveResult ir : results) {
            System.assert(ir.isSuccess());
        }
    }
    
     @isTest static void testInsertOneNominationCategoryWithSameName(){
        NominationCategory__c[] newNomCats = TestDataFactory.createNominationCategory(0, 'The Best Boy', 1);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(newNomCats[0], false);
        Test.stopTest();
         
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Nomination Category with the same name already exists. Please try to use it.',
                                 result.getErrors()[0].getMessage());
    } 
    
    @isTest static void testInsertBulkNominationCategoryAllWithSameNames(){
        NominationCategory__c[] newNomCats = TestDataFactory.createNominationCategory(3, 'The Best Boy', 2);
        
      	Test.startTest();
        Database.SaveResult[] results = Database.insert(newNomCats, false);
        Test.stopTest();
       
        for(Database.SaveResult ir : results) {
            System.assert(!ir.isSuccess());
            System.assert(ir.getErrors().size() > 0);
            System.assertEquals('Nomination Category with the same name already exists. Please try to use it.',
                                 ir.getErrors()[0].getMessage());
        }
    }
    
    
}