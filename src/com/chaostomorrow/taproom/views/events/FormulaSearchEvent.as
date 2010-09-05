package com.chaostomorrow.taproom.views.events
{
	import flash.events.Event;
	
	public class FormulaSearchEvent extends Event
	{
		public static const SEARCH:String = "search"; 
		
		public var searchTerm:String;
		
		public function FormulaSearchEvent(searchTerm:String)
		{
			this.searchTerm = searchTerm;
			super(SEARCH, true, false);
		}
	}
}