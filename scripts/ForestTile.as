package
{
	import flash.display.MovieClip;
	
	public class ForestTile extends ObstacleTile
	{		
		public function ForestTile(parent:MovieClip, x:Number, y:Number, tw:Number, th:Number, r:int, c:int, currentObstacles:Array)
		{
			super(parent, "assets/swfs/radio.swf", x, y, tw, th, r, c, currentObstacles);
		}
	}
}