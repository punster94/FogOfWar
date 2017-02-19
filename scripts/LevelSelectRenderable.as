package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LevelSelectRenderable extends Renderable
	{
		private var mainMenuButton:MovieClip;
		private var numberOfColumns:int = 3; // easy, medium, hard
		
		private var easyLevels:Array = new Array();
		private var mediumLevels:Array = new Array();
		private var hardLevels:Array = new Array();
		
		public function LevelSelectRenderable(parent:MovieClip)
		{
			super(parent, "assets/swfs/levelSelectScreen.swf", 0, 0);
			
			var index:int = 0;
			var tile:LevelSelectTile;
			
			for each (var level in Levels.levels)
			{
				tile = new LevelSelectTile(parent, index, level, calculateRow(level.difficulty), calculateColumn(level));
				addTileToArrays(tile, level.difficulty);
				LevelSelectScreen(parent).addLevelTile(tile);
				index++;
			}
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				mainMenuButton = MovieClip(assetClip.getChildByName("mainMenuButton"));
				
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(mainMenuButton.x, mainMenuButton.y, mainMenuButton.x + mainMenuButton.width, mainMenuButton.y + mainMenuButton.height))
				LevelSelectScreen(parentClip).returnToMenu();
		}
		
		private function calculateRow(difficulty:int) : int
		{
			if (difficulty == 0)
				return easyLevels.length;
			else if (difficulty == 1)
				return mediumLevels.length;
			return hardLevels.length;
		}
		
		private function calculateColumn(level:Level) : int
		{
			return level.difficulty;
		}
		
		private function addTileToArrays(tile:LevelSelectTile, difficulty:int)
		{
			if (difficulty == 0)
				easyLevels.push(tile);
			else if (difficulty == 1)
				mediumLevels.push(tile);
			else
				hardLevels.push(tile);
		}
	}
}