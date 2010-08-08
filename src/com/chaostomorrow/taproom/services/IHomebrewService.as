package com.chaostomorrow.taproom.services
{
	public interface IHomebrewService
	{
		/**
		 * Loads the list of formula on the system (brew list)
		 **/
		function loadFormulaList():void;
		/**
		 * Searches for a formula (brew search)
		 **/
		function search(formula:String):void;
		/**
		 * Finds formula that are outdated (brew outdated)
		 **/
		function findOutdatedFormulae():void;
		/**
		 * Finds formula that are installed but not linked (not supported by brew)
		 **/
		function findUnlinkedFormulae():void;
	}
}