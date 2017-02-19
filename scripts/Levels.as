package
{
	import flash.geom.Matrix;
	
	public final class Levels
	{
		public static var levels:Array;
		
		private static var instance:Levels;
		
		public static function getInstance()
		{
			if (!instance)
			{
				instance = new Levels();
			}
			
			return instance;
		}
		
		public static function get(level:int) : Level
		{
			return levels[level];
		}
		
		public static function numberOfLevels()
		{
			return levels.length;
		}
		
		public function setLevels()
		{
			levels = new Array();
			
			/*
			 * 
			 * Blank Tile = 0
			 * Ally Start Tile = 1
			 * Goal Tile = 2
			 * Mountain Tile = 3
			 * Forest Tile = 4
			 * Checkpoint Tile = 5
			 * Enemy Start Tile = 6
			 *
			 * */
			
			/* 
			 * 
			 * It is possible to use multiple start tiles in a level.
			 * A random one will be selected every time the level is loaded.
			 * The same goes for enemy start tiles.
			 * 
			 * */
			
			/*
			 * 
			 * The first component of a level object is its tile matrix.
			 * The second component passed to the constructor is the number of SECONDS the level should time the players for.
			 * The third value is the name of the level as a String.
			 * The final value specified is the difficulty of the level
			 * 		0 - easy
			 * 		1 - medium
			 * 		2 - hard
			 * 
			 * */
			 
			//Level 1-1
			levels.push(new Level([
						[2, 0, 3, 6, 0, 0],
						[0, 0, 0, 0, 0, 3],
						[3, 3, 0, 3, 0, 0],
						[0, 0, 0, 3, 0, 6],
						[0, 1, 0, 0, 0, 0],
						[0, 0, 0, 0, 3, 0]
			], 120, "1-1", 0));			

			// Level 1-2
			levels.push(new Level([
						[0, 0, 6, 0, 3, 0],
						[0, 3, 0, 0, 0, 0],
						[0, 0, 0, 0, 2, 3],
						[1, 0, 3, 0, 0, 0],
						[0, 0, 0, 3, 0, 1],
						[3, 0, 0, 0, 0, 0]
			], 120, "1-2", 0));

			// Level 1-3
			levels.push(new Level([
						[0, 0, 3, 0, 0, 0, 0],
						[6, 3, 0, 0, 6, 3, 3],
						[0, 0, 0, 3, 0, 0, 0],
						[0, 0, 0, 0, 3, 0, 0],
						[0, 0, 0, 1, 0, 0, 0],
						[0, 3, 0, 0, 0, 2, 0],
						[0, 0, 3, 0, 0, 3, 0]
			], 120, "1-3", 0));
			
			// level 2-1
			levels.push(new Level([
						[3, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 3, 0, 2, 0],
						[1, 0, 0, 0, 0, 3, 0],
						[3, 0, 0, 0, 0, 0, 0],
						[0, 3, 0, 0, 6, 0, 3],
						[0, 0, 0, 0, 3, 0, 0],
						[0, 0, 3, 0, 0, 6, 0]
			], 150, "2-1", 1));
			
			
			// level 2-2
			levels.push(new Level([
						[3, 0, 0, 0, 0, 0, 1, 0],
						[0, 0, 3, 0, 3, 0, 0, 0],
						[0, 3, 0, 0, 0, 3, 0, 0],
						[0, 0, 3, 0, 6, 0, 0, 2],
						[0, 0, 0, 0, 0, 0, 0, 0],
						[0, 0, 3, 0, 0, 3, 0, 0],
						[1, 0, 0, 0, 0, 3, 0, 0],
						[0, 0, 0, 3, 0, 0, 0, 3]
			], 150, "2-2", 1))
			
			// level 2-3
			levels.push(new Level([
						[0, 1, 0, 0, 3, 0, 0, 0],
						[0, 0, 3, 0, 0, 0, 2, 0],
						[0, 3, 0, 0, 0, 3, 0, 0],
						[0, 0, 0, 0, 0, 0, 0, 3],
						[0, 3, 0, 3, 6, 0, 0, 0],
						[3, 0, 0, 0, 0, 0, 3, 0],
						[0, 0, 0, 3, 0, 3, 0, 0],
						[0, 0, 3, 0, 0, 0, 0, 0]
			], 150, "2-3", 1));
			
			
			// level 3-1
			levels.push(new Level([
						[3, 0, 3, 0, 0, 3, 0, 0],
						[0, 0, 0, 1, 0, 0, 3, 0],
						[0, 0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0, 0],
						[0, 2, 0, 3, 0, 3, 0, 0],
						[3, 0, 0, 0, 0, 0, 0, 0],
						[0, 3, 0, 0, 0, 0, 6, 0],
						[0, 0, 0, 3, 0, 0, 0, 3]
			], 180, "3-1", 2));
			
			
			// level 3-2
			levels.push(new Level([
						[0, 3, 0, 6, 0, 0, 0, 3],
						[0, 0, 0, 0, 6, 0, 0, 3],
						[3, 0, 0, 3, 0, 0, 3, 0],
						[0, 0, 0, 0, 0, 0, 0, 0],
						[1, 0, 0, 0, 0, 3, 0, 0],
						[0, 3, 0, 0, 0, 0, 0, 0],
						[0, 3, 0, 0, 0, 0, 2, 0],
						[0, 0, 0, 0, 3, 0, 0, 0]
			], 180, "3-2", 2))
			
				// level 3-3
			levels.push(new Level([
						[0, 0, 0, 3, 0, 0, 0, 0, 6],
						[0, 2, 0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 3, 0, 0, 0],
						[0, 3, 0, 0, 3, 0, 3, 0, 0],
						[0, 0, 3, 0, 0, 0, 0, 0, 6],
						[0, 0, 0, 0, 0, 0, 0, 0, 0],
						[0, 0, 3, 0, 0, 0, 0, 0, 3],
						[0, 0, 0, 0, 0, 0, 0, 3, 0],
						[0, 0, 0, 1, 0, 3, 0, 0, 0]
			], 180, "3-3", 2))
			
		}
	}
}