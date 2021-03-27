trigger NomineeInNominationCategoryTrigger on NomineeInNominationCategory__c (before insert) {
	(new NomineeInNominationCategoryTrH()).run();
}