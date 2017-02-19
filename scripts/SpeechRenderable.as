package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SpeechRenderable extends Renderable
	{
		private var _selected:Boolean;
		private var source:int;
		
		public function SpeechRenderable(parent:MovieClip, s:int)
		{
			var path:String;
			var x:Number, y:Number;
			
			_selected = (s == 0);
					
			switch (s)
			{
				case 0 :
					path = "assets/swfs/speechBubble_skinny.swf";
					x = 143.35;
					y = 365.60;
					break;
				case 1 :
					path = "assets/swfs/speechBubble_fat.swf";
					x = 1621.50;
					y = 423.00;
					break;
				case 2 :
					path = "assets/swfs/speechRadio_skinny.swf";
					x = 49.25;
					y = 175.35;
					break;
				case 3 :
					path = "assets/swfs/speechRadio_fat.swf";
					x = 1705.05;
					y = 164.35;
					break;
			}
			
			super(parent, path, x, y);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
				
			if (selected)			
				assetClip.visible = true;
			else
				assetClip.visible = false
		}
		
		public function select()
		{
			selected = true;
		}
		
		public function deselect()
		{
			selected = false;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
		}
	}
}