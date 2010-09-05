package com.chaostomorrow.taproom.contexts
{
	import com.chaostomorrow.taproom.controllers.GetFormulaListCommand;
	import com.chaostomorrow.taproom.controllers.GetOutdatedFormulaeCommand;
	import com.chaostomorrow.taproom.controllers.FormulaSearchCommand;
	import com.chaostomorrow.taproom.events.HomebrewEvent;
	import com.chaostomorrow.taproom.services.HomebrewNativeProcessService;
	import com.chaostomorrow.taproom.services.IHomebrewService;
	import com.chaostomorrow.taproom.views.components.FormulaSearchBar;
	import com.chaostomorrow.taproom.views.components.FormulaeListView;
	import com.chaostomorrow.taproom.views.events.FormulaSearchEvent;
	import com.chaostomorrow.taproom.views.mediators.FormulaSearchMediator;
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
			commandMap.mapEvent(FormulaSearchEvent.SEARCH, FormulaSearchCommand, FormulaSearchEvent);
			
			// map model
			
			// map service
			injector.mapSingletonOf(IHomebrewService, HomebrewNativeProcessService);
			
			// map view
			mediatorMap.mapView(FormulaeListView, FormulaeListViewMediator);
			mediatorMap.mapView(FormulaSearchBar, FormulaSearchMediator);
			
			// start
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}