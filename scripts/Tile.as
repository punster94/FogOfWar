package
{
	import flash.display.MovieClip;
	
	public class Tile extends Renderable
	{
		protected var tileWidth:Number, tileHeight:Number;
		public var row:int, column:int;
		protected var enterable:Boolean;
		
		public function Tile(parent:MovieClip, path:String, x:Number, y:Number, tw:Number, th:Number, r:int, c:int)
		{
			super(parent, path, x, y);
			tileWidth = tw;
			tileHeight = th;
			row = r;
			column = c;
			enterable = true;
		}
		
		public function isEnterable()
		{
			return enterable;
		}
	}
}