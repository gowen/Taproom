package com.chaostomorrow.taproom.services
{
	import com.chaostomorrow.taproom.events.HomebrewEvent;
	import com.chaostomorrow.taproom.models.vo.BrewFormula;
	import com.chaostomorrow.taproom.models.vo.FormulaList;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;

	public class HomebrewNativeProcessService extends Actor implements IHomebrewService
	{
		// TODO: queue requests or don't share a single native process for all calls
		
		protected var brewProcess:NativeProcess;
		public static const brewLocation:String = "/usr/local/bin/brew"; // TODO: this should not be hardcoded
		
		public function HomebrewNativeProcessService()
		{
			// TODO: get the location of brew. Could inject the native process here, or at least the name
			brewProcess = new NativeProcess();
		}
		
		/**
		 * General purpose IO error handler.
		 **/
		protected function onIOError(event:IOErrorEvent):void {
			
		}
		
		protected var list:String;
		
		public function loadFormulaList():void {
			list = "";
			
			brewProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			brewProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			brewProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			brewProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			brewProcess.addEventListener(NativeProcessExitEvent.EXIT, loadFormulaeExitHandler);
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = new File(brewLocation);
			info.arguments = new <String>[ 'list', '-v' ];
			brewProcess.start(info);
		}
		
		protected function listSTDIOHandler(event:ProgressEvent):void {
			list += brewProcess.standardOutput.readUTFBytes(brewProcess.standardOutput.bytesAvailable);
		}
		
		protected function listSTDERRHandler(event:ProgressEvent):void {
			// TDOO: what could come on std error for the list call?
			trace('std err: ' + brewProcess.standardError.readUTFBytes(brewProcess.standardOutput.bytesAvailable));
		}
		
		protected function loadFormulaeExitHandler(event:NativeProcessExitEvent):void {
			// list process is done
			
			// parse the list into formula objects
			var formulaeStrings:Array = list.split('\n');
			var formulae:Array = [];
			for each(var formulaString:String in formulaeStrings){
				var nameAndVersions:Array = formulaString.split(' ');
				var formula:BrewFormula = new BrewFormula(nameAndVersions[0], nameAndVersions[nameAndVersions.length - 1]); // versions are listed oldest to newest
				if(formula.name){
					formulae.push(formula);
				}
			}
			
			var formulaList:FormulaList = new FormulaList();
			formulaList.formulae = new ArrayCollection(formulae);
			
			brewProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			brewProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			brewProcess.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			brewProcess.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			brewProcess.removeEventListener(NativeProcessExitEvent.EXIT, loadFormulaeExitHandler);
			
			dispatch(new HomebrewEvent(HomebrewEvent.FORMULA_LIST_LOADED, formulaList));
		}
		
		public function search(formula:String):void {
			// check the existing list of formulae for any matches (not regex due to special characters, instead do 'indexOf') TODO: need a model class
			// call brew search
		}
		
		public function findOutdatedFormulae():void {
			list = "";
			
			brewProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			brewProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			brewProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			brewProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			brewProcess.addEventListener(NativeProcessExitEvent.EXIT, findOutdatedFormulaeExitHandler);
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = new File(brewLocation);
			info.arguments = new <String>[ 'outdated', '-v'];
			brewProcess.start(info);
		}
		
		protected function findOutdatedFormulaeExitHandler(event:NativeProcessExitEvent):void {
			// outdated process is done
			
			// parse the list into formula objects
			var formulaeStrings:Array = list.split('\n');
			var formulae:Array = [];
			for each(var formulaString:String in formulaeStrings){
				var nameAndVersions:Array = formulaString.split(' ');
				var formula:BrewFormula = new BrewFormula(nameAndVersions[0], "");
				if(formula.name){
					formulae.push(formula);
				}
			}
			
			var formulaList:FormulaList = new FormulaList();
			formulaList.formulae = new ArrayCollection(formulae);
			
			dispatch(new HomebrewEvent(HomebrewEvent.OUTDATED_LIST_LOADED, formulaList));
		}
		
		public function findUnlinkedFormulae():void {
			
		}
	}
}