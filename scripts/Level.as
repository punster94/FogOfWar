package
{
	public class Level
	{
		public var level:Array;
		public var time:Number;
		public var name:String;
		public var difficulty:int;
		
		public function Level(l:Array, t:Number, n:String, d:int)
		{
			level = l;
			time = t;
			name = n;
			difficulty = d;
		}
	}
}