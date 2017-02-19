package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class InfoRenderable extends Renderable
	{
		private var continueButton:MovieClip;
		private var levelSelectButton:MovieClip;
		
		public function InfoRenderable(parent:MovieClip)
		{
			super(parent, "assets/swfs/lostSoldierIllustration_mainmenu.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				continueButton = MovieClip(assetClip.getChildByName("playButton"));
				levelSelectButton = MovieClip(assetClip.getChildByName("levelSelectButton"));
				assetClip.visible = true;
				SoundManager.getInstance().playMenuSound();
			}
			
			if (InputManager.isClickedInBounds(continueButton.x, continueButton.y, continueButton.x + continueButton.width, continueButton.y + continueButton.height))
				InfoScreen(parentClip).moveOn();
				
			if (InputManager.isClickedInBounds(levelSelectButton.x, levelSelectButton.y, levelSelectButton.x + levelSelectButton.width, levelSelectButton.y + levelSelectButton.height))
				InfoScreen(parentClip).moveToLevelSelectScreen();
		}
	}
}