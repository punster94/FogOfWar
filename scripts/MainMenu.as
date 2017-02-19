package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MainMenu extends Renderable
	{
		private var startButton:MovieClip;
		
		public function MainMenu(parent:MovieClip, x:Number, y:Number) 
		{
			super(parent, "assets/swfs/MainMenu.swf", x, y);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				startButton = MovieClip(assetClip.getChildByName("startButton"));
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(startButton.x, startButton.y, startButton.x + startButton.width, startButton.y + startButton.height))
				MainMenuScreen(parentClip).start();
		}
	}
}