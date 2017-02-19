package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ObstacleTile extends Tile
	{		
		public function ObstacleTile(parent:MovieClip, path:String, x:Number, y:Number, tw:Number, th:Number, r:int, c:int, currentObstacles:Array)
		{
			super(parent, path, x, y, tw, th, r, c);
			enterable = false;
			currentObstacles.push(this);
		}
		
		public function Update(event:Event)
		{
			if (!loaded && assetClip != null)
			{
				assetClip.width = tileWidth;
				assetClip.height = tileHeight;
				loaded = true;
				assetClip.visible = true;
			}
		}
	}
}