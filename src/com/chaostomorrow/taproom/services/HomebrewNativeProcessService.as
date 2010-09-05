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
		
		protected var searchProcess:NativeProcess;
		public static const brewLocation:String = "/usr/local/bin/brew"; // TODO: this should not be hardcoded
		
		public function HomebrewNativeProcessService()
		{
			// TODO: get the location of brew. Could inject the native process here, or at least the name			
		}
		
		/**
		 * General purpose IO error handler.
		 **/
		protected function onIOError(event:IOErrorEvent):void {
			
		}
		
		protected var list:String;
		
		public function loadFormulaList():void {
			list = "";
			var process:NativeProcess = new NativeProcess();
			
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			process.addEventListener(NativeProcessExitEvent.EXIT, loadFormulaeExitHandler);
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = new File(brewLocation);
			info.arguments = new <String>[ 'list', '-v' ];
			process.start(info);
		}
		
		protected function listSTDIOHandler(event:ProgressEvent):void {
			var process:NativeProcess = event.target as NativeProcess;
			list += process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
		}
		
		protected function listSTDERRHandler(event:ProgressEvent):void {
			// TDOO: what could come on std error for the list call?
			var process:NativeProcess = event.target as NativeProcess;
			trace('std err: ' + process.standardError.readUTFBytes(process.standardOutput.bytesAvailable));
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
			
			dispatch(new HomebrewEvent(HomebrewEvent.FORMULA_LIST_LOADED, formulaList));
		}
		
		// TODO: add regex param
		public function search(formula:String):void {
			// if there is already a call running, cancel it
			if(searchProcess && searchProcess.running){
				searchProcess.exit(true);
				searchProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
				searchProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
				searchProcess.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
				searchProcess.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
				searchProcess.removeEventListener(NativeProcessExitEvent.EXIT, searchExitHandler);
				searchProcess = null;
			}
			
			// call brew search
			
			list = "";
			searchProcess = new NativeProcess();
			
			searchProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			searchProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			searchProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			searchProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			searchProcess.addEventListener(NativeProcessExitEvent.EXIT, searchExitHandler);
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = new File(brewLocation);
			info.arguments = new <String>[ 'search', formula];
			searchProcess.start(info);
		}
		
		protected function searchExitHandler(event:NativeProcessExitEvent):void {
			// search process is done
			
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
						
			searchProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			searchProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			searchProcess.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			searchProcess.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			searchProcess.removeEventListener(NativeProcessExitEvent.EXIT, searchExitHandler);
			searchProcess = null;
			
			dispatch(new HomebrewEvent(HomebrewEvent.FORMULA_LIST_LOADED, formulaList));
		}
		
		public function findOutdatedFormulae():void {
			list = "";
			var process:NativeProcess = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, listSTDIOHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, listSTDERRHandler);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			process.addEventListener(NativeProcessExitEvent.EXIT, findOutdatedFormulaeExitHandler);
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.executable = new File(brewLocation);
			info.arguments = new <String>[ 'outdated', '-v'];
			process.start(info);
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