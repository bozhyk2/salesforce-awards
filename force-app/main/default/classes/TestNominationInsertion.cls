@isTest
public class TestNominationInsertion {
    
    @testSetup static void setup() {
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        List<Contact> conts = TestDataFactory.createTenDiffContact();
        List<NominationCategory__c> nomCats = TestDataFactory.createTenDiffNominationCategory();
        insert conts;
        insert nomCats;
        List<Nomination__c> noms = new List<Nomination__c>();
        for(Integer i = 0; i < 3; i++){
            noms.add(new Nomination__c(NomineeId__c = conts.get(i).Id, 
                                       NominatorId__c = conts.get(4).Id, 
                                       NominationCategoryId__c = nomCats.get(1).Id, 
                                       Review__c = TestDataFactory.createTenWellReview().get(i)));
        }
        insert noms;
        
        
    }
  
   // before insert
     @isTest static void testOneFollowRules(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //----------------
        //[ 1 - 5 - 2 ]
        List<Contact> conts = [SELECT Id 
                               FROM Contact];
        List<NominationCategory__c> nomCats = [SELECT Id 
                                               FROM NominationCategory__c ];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(2).Id, 
                                         NominatorId__c = conts.get(5).Id, 
                                         NominationCategoryId__c = nomCats.get(1).Id, 
                                         Review__c = TestDataFactory.createTenWellReview().get(9)));
        Test.startTest();
        Database.SaveResult result = Database.insert(addNewNoms[0]);
        Test.stopTest();
        System.assert(result.isSuccess()); 
     }
    
    @isTest static void testBulkFollowRules(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //--------------
        //[ 1 - 5 - 0 ]
        //[ 1 - 5 - 1 ]
        //[ 1 - 5 - 2 ]
        List<Contact> conts = [SELECT Id FROM Contact];
        List<NominationCategory__c> nomCats = [SELECT Id FROM NominationCategory__c ];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        for(Integer i = 0; i < 3; i++){
            addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(i).Id, 
                                            NominatorId__c = conts.get(5).Id, 
                                            NominationCategoryId__c = nomCats.get(1).Id, 
                                            Review__c = TestDataFactory.createTenWellReview().get(i)));
        }
        Test.startTest();
        Database.SaveResult[] results = Database.insert(addNewNoms);
        Test.stopTest();
        
        for(Database.SaveResult item : results) {
            System.assert(item.isSuccess());
        }
    }
  
    @isTest static void testOneBreakRuleThreeNomineesPerNomination(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //--------------
        //[ 1 - 4 - 3 ]
        
        List<Contact> conts = [SELECT Id, Email 
                               FROM Contact]; 
        List<NominationCategory__c> nomCats = [SELECT Id 
                                               FROM NominationCategory__c];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(3).Id, 
                                         NominatorId__c = conts.get(4).Id, 
                                   		 NominationCategoryId__c = nomCats.get(1).Id, 
                                  		 Review__c = TestDataFactory.createTenWellReview().get(7)));
        Test.startTest();
        Database.SaveResult result = Database.insert(addNewNoms[0], false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You choose more than three Nominees in the same Nomination Category.',
                                 result.getErrors()[0].getMessage());  
    }
    
    @isTest static void testBulkBreakRuleThreeNomineesPerNomination(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //--------------
        //[ 1 - 4 - 5 ]
        //[ 1 - 4 - 6 ]
        //[ 1 - 4 - 7 ]
        List<Contact> conts = [SELECT Id, Email 
                               FROM Contact]; 
        List<NominationCategory__c> nomCats = [SELECT Id 
                                               FROM NominationCategory__c];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        for(Integer i = 5; i <= 7; i++){
            addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(i).Id, 
                                            NominatorId__c = conts.get(4).Id, 
                                            NominationCategoryId__c = nomCats.get(1).Id, 
                                            Review__c = TestDataFactory.createTenWellReview().get(i)));
        }
        Test.startTest();
        Database.SaveResult[] results = Database.insert(addNewNoms, false);
        Test.stopTest();
        
        for(Database.SaveResult item : results) {
            System.assert(!item.isSuccess());
            System.assert(item.getErrors().size() > 0);
            System.assertEquals('You choose more than three Nominees in the same Nomination Category.',
                                 item.getErrors()[0].getMessage());
        }
    }
    
     @isTest static void testOneBreakRuleTwiceNomineePerNomination(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //--------------
        //[ 1 - 4 - 2 ]
        
        List<Contact> conts = [SELECT Id, Email 
                               FROM Contact]; 
        List<NominationCategory__c> nomCats = [SELECT Id 
                                               FROM NominationCategory__c];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(2).Id, 
                                         NominatorId__c = conts.get(4).Id, 
                                   		 NominationCategoryId__c = nomCats.get(1).Id, 
                                  		 Review__c = TestDataFactory.createTenWellReview().get(7)));
        Test.startTest();
        Database.SaveResult result = Database.insert(addNewNoms[0], false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You cannot nominate the Nominee in the Nomination Category twice.',
                                 result.getErrors()[0].getMessage());  
    }
    
    @isTest static void testBulkBreakRuleTwiceNomineePerNomination(){
        //[nomCat - nominator - nominee ]
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        //--------------
        //[ 1 - 4 - 0 ]
        //[ 1 - 4 - 1 ]
        //[ 1 - 4 - 2 ]
        List<Contact> conts = [SELECT Id, Email 
                               FROM Contact]; 
        List<NominationCategory__c> nomCats = [SELECT Id 
                                               FROM NominationCategory__c];
        List<Nomination__c> addNewNoms = new List<Nomination__c>();
        for(Integer i = 0; i <= 2; i++){
            addNewNoms.add(new Nomination__c(NomineeId__c = conts.get(i).Id, 
                                             NominatorId__c = conts.get(4).Id, 
                                             NominationCategoryId__c = nomCats.get(1).Id, 
                                             Review__c = TestDataFactory.createTenWellReview().get(i)));
        }
        Test.startTest();
        Database.SaveResult[] results = Database.insert(addNewNoms, false);
        Test.stopTest();
        
        for(Database.SaveResult item : results) {
            System.assert(!item.isSuccess());
            System.assert(item.getErrors().size() > 0);
            System.assertEquals('You cannot nominate the Nominee in the Nomination Category twice.',
                                 item.getErrors()[0].getMessage());
        }
    }
    /*
    //after insert
    @isTest static void testOneAddNewNINC(){}
    
    @isTest static void testBulkAddNewNINC(){}
    
    @isTest static void testOneAddExistNINC(){}
    
    @isTest static void testBulkAddExistNINC(){}
    
    //after update
    @isTest static void testOneActivateApprovedNINC(){}
    @isTest static void testBulkActivateApprovedNINC(){}
    @isTest static void testOneNotChangeRejectedNINC(){}
    @isTest static void testBulkNotChangeRejectedNINC(){}
    */
   

}