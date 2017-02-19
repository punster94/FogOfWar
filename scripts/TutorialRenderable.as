package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TutorialRenderable extends Renderable
	{
		private var continueButton:MovieClip;
		
		public function TutorialRenderable(parent:MovieClip)
		{
			super(parent, "assets/swfs/tutorialScreen.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				continueButton = MovieClip(assetClip.getChildByName("continueButton"));
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(continueButton.x, continueButton.y, continueButton.x + continueButton.width, continueButton.y + continueButton.height))
				TutorialScreen(parentClip).moveOn();
		}
	}
}