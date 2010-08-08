package com.chaostomorrow.taproom.views.mediators
{
	import com.chaostomorrow.taproom.events.HomebrewEvent;
	import com.chaostomorrow.taproom.models.vo.BrewFormula;
	import com.chaostomorrow.taproom.views.FormulaeListView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class FormulaeListViewMediator extends Mediator
	{
		[Inject]
		public var formulaeListView:FormulaeListView;
		
		public function FormulaeListViewMediator()
		{
			super();
		}
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher, HomebrewEvent.LOAD_FORMULA_LIST, listLoading);
			eventMap.mapListener(eventDispatcher, HomebrewEvent.FORMULA_LIST_LOADED, listLoaded);
			//eventMap.mapListener(eventDispatcher, HomebrewEvent.LOAD_OUTDATED_FORMULA, listLoading);
			eventMap.mapListener(eventDispatcher, HomebrewEvent.OUTDATED_LIST_LOADED, outdatedListLoaded);
			
			dispatch(new HomebrewEvent(HomebrewEvent.LOAD_FORMULA_LIST));			
		}
		
		protected function listLoading(event:Event):void {
			formulaeListView.loading = true;
		}
		
		protected function listLoaded(event:HomebrewEvent):void {
			formulaeListView.dataProvider = event.formulaList.formulae;
			formulaeListView.loading = false;
			dispatch(new HomebrewEvent(HomebrewEvent.LOAD_OUTDATED_FORMULA));
		}
		
		protected function outdatedListLoaded(event:HomebrewEvent):void {
			// go through the out dated list and find matches in the current list
			var eventList:ArrayCollection = event.formulaList.formulae;
			var found:Boolean;
			for each(var formula:BrewFormula in formulaeListView.dataProvider){ 
				found = false;
				// if there is a match then update the view's copy to have the outdated flag and new version
				for(var i:int = 0; i < eventList.length && !found; i++){
					var outdated:BrewFormula = eventList[i] as BrewFormula;
					if(!outdated) break;
					if(outdated.name == formula.name){
						formula.outdated = true;
						formula.name += '*';
						found = true;
					}
				}
			}
		}
	}
}