package com.chaostomorrow.taproom.controllers
{
	import com.chaostomorrow.taproom.services.IHomebrewService;
	
	import org.robotlegs.mvcs.Command;
	
	public class GetOutdatedFormulaeCommand extends Command
	{
		[Inject]
		public var service:IHomebrewService;
		
		override public function execute():void {
			service.findOutdatedFormulae();
		}
	}
}