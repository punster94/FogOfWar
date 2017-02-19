package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GoalTile extends Tile
	{		
		public function GoalTile(parent:MovieClip, x:Number, y:Number, tw:Number, th:Number, r:int, c:int)
		{
			super(parent, "assets/swfs/levelTileExtractionPoint.swf", x, y, tw, th, r, c);
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