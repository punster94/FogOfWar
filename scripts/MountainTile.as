package
{
	import flash.display.MovieClip;
	
	public class MountainTile extends ObstacleTile
	{		
		public function MountainTile(parent:MovieClip, x:Number, y:Number, tw:Number, th:Number, r:int, c:int, currentObstacles:Array)
		{
			super(parent, "assets/swfs/levelTileMountain.swf", x, y, tw, th, r, c, currentObstacles);
		}
	}
}