package com.chaostomorrow.taproom.views.mediators
{
	import com.chaostomorrow.taproom.events.HomebrewEvent;
	import com.chaostomorrow.taproom.services.IHomebrewService;
	import com.chaostomorrow.taproom.views.components.FormulaSearchBar;
	import com.chaostomorrow.taproom.views.events.FormulaSearchEvent;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class FormulaSearchMediator extends Mediator implements IMediator
	{
		[Inject]
		public var formulaSearch:FormulaSearchBar;

		public function FormulaSearchMediator()
		{
		
		}
		
		override public function onRegister():void {
			eventMap.mapListener( formulaSearch, FormulaSearchEvent.SEARCH, handleSearch );
		}
		
		protected function handleSearch(event:FormulaSearchEvent):void {
			dispatch(new FormulaSearchEvent(event.searchTerm));
		}
	}
}