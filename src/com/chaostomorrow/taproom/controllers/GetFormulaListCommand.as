package com.chaostomorrow.taproom.controllers
{
	import com.chaostomorrow.taproom.services.IHomebrewService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetFormulaListCommand extends Command
	{
		[Inject]
		public var service:IHomebrewService;
		
		override public function execute():void {
			service.loadFormulaList();
		}
	}
}