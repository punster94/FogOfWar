package
{
	import flash.display.MovieClip;
	
	public class LevelSelectScreen extends Screen
	{
		private var manager:MainManager;
		private var menu:LevelSelectRenderable;
		
		public function LevelSelectScreen(mainManager:MainManager)
		{
			manager = mainManager;
			menu = new LevelSelectRenderable(this);
			addUpdatableObject(menu);
		}
		
		public function returnToMenu()
		{
			manager.setState(1);
		}
		
		public function setLevel(level:int)
		{
			manager.setCurrentLevel(level);
		}
		
		public function addLevelTile(tile:LevelSelectTile)
		{
			addUpdatableObject(tile);
		}
	}
}