package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class StartTile extends Tile
	{	
		private var isCurrentStartTile:Boolean;
		private var isEnemyTile:Boolean;
		
		public function StartTile(parent:MovieClip, x:Number, y:Number, tw:Number, th:Number, r:int, c:int, type:Boolean)
		{
			var assetPath:String;
			
			if (LevelScreen(parent).inDebugMode())
			{
				assetPath = "assets/swfs/Green.swf";	
			}
			else
			{
				assetPath = "assets/swfs/levelTileGrassNoMarks.swf";
			}
			
			isCurrentStartTile = false;
			isEnemyTile = type;
			
			super(parent, assetPath, x, y, tw, th, r, c);
		}
		
		public function Update(event:Event)
		{
			if (!loaded && assetClip != null)
			{
				assetClip.width = tileWidth;
				assetClip.height = tileHeight;
				loaded = true;
				assetClip.visible = true;
				
				if (isCurrentStartTile)
				{
					if (isEnemyTile)
						LevelScreen(parentClip).createEnemyAtTile(this);
					else
						LevelScreen(parentClip).createAllyAtTile(this);
				}
			}
		}
		
		public function pickAsStartTile()
		{
			isCurrentStartTile = true;
		}
	}
}