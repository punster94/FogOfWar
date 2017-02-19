package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	
	public class LevelSelectTile extends Renderable
	{
		private var level:int;
		private var levelName:String;
		private var difficulty:int;
		
		private var row:int, column:int;
		
		private var startY:Number = 350;
		
		private var startXEasy:Number = 500;
		private var startXMedium:Number = 853.55;
		private var startXHard:Number = 1207.10;
		
		private var spaceBetweenRows:Number = 10;
		
		public function LevelSelectTile(parent:MovieClip, l:int, lvl:Level, r:int, c:int)
		{
			level = l;
			levelName = lvl.name;
			difficulty = lvl.difficulty;
			row = r;
			column = c;
			
			super(parent, "assets/swfs/levelSelectButton.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{				
				assetClip.x = calculateX();
				assetClip.y = calculateY();
				TextField(MovieClip(assetClip.getChildAt(0)).getChildByName("text")).text = String(levelName);
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(assetClip.x, assetClip.y, assetClip.x + assetClip.width, assetClip.y + assetClip.height))
				LevelSelectScreen(parentClip).setLevel(level);
		}
		
		private function calculateX() : Number
		{
			var startX:Number = startXEasy;
			
			if (difficulty == 1)
				startX = startXMedium;
			else if (difficulty == 2)
				startX = startXHard;
			
			return startX;
		}
		
		private function calculateY() : Number
		{
			return startY + (row * (assetClip.height + spaceBetweenRows));
		}
	}
}