package com.chaostomorrow.taproom.contexts
{
	import com.chaostomorrow.taproom.controllers.GetFormulaListCommand;
	import com.chaostomorrow.taproom.controllers.GetOutdatedFormulaeCommand;
	import com.chaostomorrow.taproom.events.HomebrewEvent;
	import com.chaostomorrow.taproom.services.HomebrewNativeProcessService;
	import com.chaostomorrow.taproom.services.IHomebrewService;
	import com.chaostomorrow.taproom.views.FormulaeListView;
	import com.chaostomorrow.taproom.views.mediators.FormulaeListViewMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.core.IContext;
	import org.robotlegs.mvcs.Context;
	
	public class TaproomContext extends Context implements IContext
	{
		public function TaproomContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView);
		}
		
		override public function startup():void {
			// map controller			
			commandMap.mapEvent(HomebrewEvent.LOAD_FORMULA_LIST, GetFormulaListCommand, HomebrewEvent);
			commandMap.mapEvent(HomebrewEvent.LOAD_OUTDATED_FORMULA, GetOutdatedFormulaeCommand, HomebrewEvent);
			
			// map model
			
			// map service
			injector.mapSingletonOf(IHomebrewService, HomebrewNativeProcessService);
			
			// map view
			mediatorMap.mapView(FormulaeListView, FormulaeListViewMediator);
			
			// start
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}