package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class GlowEffect extends Renderable
	{
		private var rendering :Boolean;
		private var fadingOut :Boolean;
		private var addedToParent :Boolean;
		
		private var fadingSpeed:Number = 0.25;
		private var effectColor = 0xC12024;
		
		public function GlowEffect(parent:MovieClip)
		{
			super(parent, "assets/swfs/glowEffect.swf", 0, 0);
			addedToParent = false;
			rendering = false;
		}
		
		public function Update(event:Event) : void
		{
			if (!loaded && assetClip != null)
			{
				loaded = true;
				parentClip.addChild(assetClip);
			}
			
			if (rendering) 
			{
				if (!fadingOut) 
				{
					assetClip.alpha += fadingSpeed;
					if (assetClip.alpha >= 1) 
					{
						fadingOut = true;
					}
				}
				else
				{
					assetClip.alpha -= fadingSpeed;
					if (assetClip.alpha<=0) 
					{
						rendering = false;
					}
				}
			}
		}
		
		public function renderGlowEffect(xPosition:Number, yPosition:Number, w:Number, h:Number) 
		{
			if (rendering) 
			{
				return;
			}
			assetClip.x = xPosition;
			assetClip.y = yPosition;
			assetClip.width = w;
			assetClip.height = h;
			assetClip.alpha = 0;
			changeAssetColor(effectColor);

			
			assetClip.visible = true;
			rendering = true;
			fadingOut = false;
		}
		
		public function changeAssetColor(color:uint)
		{
			var colorTrans:ColorTransform = new ColorTransform();
			colorTrans.color = color;
			assetClip.transform.colorTransform = colorTrans;
			effectColor = color;
		}
	}
}