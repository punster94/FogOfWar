package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class StartButton extends Renderable
	{
		public function StartButton(parent:MovieClip, x:Number, y:Number) 
		{
			super(parent, "assets/swfs/StartButtonAsset.swf", x, y);
		}
		
		public function Update(event:Event) : void
		{			
			if (assetClip == null)
				return;
				
			if (!assetClip.visible)
				assetClip.visible = true;
			
			if (InputManager.isClickedInBounds(assetClip.x, assetClip.y, assetClip.x + assetClip.width, assetClip.y + assetClip.height))
				MainMenuScreen(assetClip.parent.parent).start();
		}
	}
}