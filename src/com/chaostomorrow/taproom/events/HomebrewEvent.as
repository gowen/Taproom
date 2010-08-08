package com.chaostomorrow.taproom.events
{
	import com.chaostomorrow.taproom.models.vo.FormulaList;
	
	import flash.events.Event;
	
	public class HomebrewEvent extends Event
	{
		public static const LOAD_FORMULA_LIST:String = "loadFormulaList";
		public static const FORMULA_LIST_LOADED:String = "formulaListLoaded";
		public static const LOAD_OUTDATED_FORMULA:String = "loadOutdatedFormula";
		public static const OUTDATED_LIST_LOADED:String = "outdatedListLoaded";
		
		public var formulaList:FormulaList;
		
		public function HomebrewEvent(type:String, formulaList:FormulaList = null)
		{
			this.formulaList = formulaList;
			super(type, true, true);
		}
	}
}