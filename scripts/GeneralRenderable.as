package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GeneralRenderable extends Renderable
	{
		private var _selected:Boolean;
		private var _poseId:int;
		
		public function GeneralRenderable(parent:MovieClip, fatGeneral:Boolean, pose:int)
		{
			var path:String;
			poseId = pose;
			var x:Number, y:Number; // I based these numbers off of the positions the generals were in before I removed them from the .fla.
			
			selected = (pose == 0);
			
			if (fatGeneral)
			{
				x = 1071.35;
				y = 430.40;
				
				switch (pose)
				{
					case 0 :
						path = "assets/swfs/evilGeneral_confused.swf";
						break;
					case 1 :
						path = "assets/swfs/evilGeneral_east.swf";//north
						break;
					case 2 :
						path = "assets/swfs/evilGeneral_east.swf";
						break;
					case 3 :
						path = "assets/swfs/evilGeneral_west.swf";//south
						break;
					case 4 :
						path = "assets/swfs/evilGeneral_west.swf";
						break;
				}
			}
			else
			{
				x = -79.15;
				y = 269.20;
				
				switch (pose)
				{
					case 0 :
						path = "assets/swfs/skinnyGeneral_confused.swf";
						break;
					case 1 :
						path = "assets/swfs/skinnyGeneral_north.swf";
						break;
					case 2 :
						path = "assets/swfs/skinnyGeneral_south.swf";//east
						break;
					case 3 :
						path = "assets/swfs/skinnyGeneral_south.swf";
						break;
					case 4 :
						path = "assets/swfs/skinnyGeneral_north.swf";//west
						break;
				}
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
		
		public function get poseId():int 
		{
			return _poseId;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set poseId(value:int):void 
		{
			_poseId = value;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
		}
	}
}