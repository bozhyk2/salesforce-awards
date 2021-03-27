trigger NominationCategoryTrigger on NominationCategory__c (before insert) {
	(new NominationCategoryTrH()).run();
}