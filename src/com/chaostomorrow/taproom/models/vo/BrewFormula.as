package com.chaostomorrow.taproom.models.vo
{
	[Bindable]
	public class BrewFormula
	{
		public var name:String;
		public var version:String;
		public var outdated:Boolean = false;
		public var unlinked:Boolean = false;
		
		public function BrewFormula(name:String, version:String)
		{
			this.name = name;
			this.version = version;
		}
	}
}