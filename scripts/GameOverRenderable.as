package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GameOverRenderable extends Renderable
	{
		private var replayButton:MovieClip;
		private var mainMenuButton:MovieClip;
		
		public function GameOverRenderable(parent:MovieClip)
		{
			super(parent, "assets/swfs/gameComplete.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				replayButton = MovieClip(assetClip.getChildByName("replayButton"));
				mainMenuButton = MovieClip(assetClip.getChildByName("mainMenuButton"));
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(replayButton.x, replayButton.y, replayButton.x + replayButton.width, replayButton.y + replayButton.height))
				GameOverScreen(parentClip).restartLevel();
			
			if (InputManager.isClickedInBounds(mainMenuButton.x, mainMenuButton.y, mainMenuButton.x + mainMenuButton.width, mainMenuButton.y + mainMenuButton.height))
				GameOverScreen(parentClip).returnToMenu();
		}
	}
}