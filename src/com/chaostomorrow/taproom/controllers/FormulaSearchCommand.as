package com.chaostomorrow.taproom.controllers
{
	import com.chaostomorrow.taproom.services.IHomebrewService;
	import com.chaostomorrow.taproom.views.events.FormulaSearchEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class FormulaSearchCommand extends Command
	{
		[Inject]
		public var event:FormulaSearchEvent;
		
		[Inject]
		public var service:IHomebrewService;
		
		override public function execute():void {
			if(event.searchTerm.length > 0){
				service.search(event.searchTerm);
			} else {
				service.loadFormulaList();
			}
		}
	}
}