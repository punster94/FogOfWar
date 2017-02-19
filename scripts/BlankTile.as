package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BlankTile extends Tile
	{		
		public function BlankTile(parent:MovieClip, x:Number, y:Number, tw:Number, th:Number, r:int, c:int)
		{
			super(parent, "assets/swfs/levelTileGrassNoMarks.swf", x, y, tw, th, r, c);
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