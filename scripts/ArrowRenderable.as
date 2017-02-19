package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ArrowRenderable extends Renderable
	{
		private var source:int;
		private var isGreen:Boolean;
		private var belongsToEnemy:Boolean;
		private var row:int, column:int;
		
		private var allyStartX:Number = 483.45, allyStartY:Number = 125.65;
		private var enemyStartX:Number = 1405.95, enemyStartY:Number = 125.65;
		
		public function ArrowRenderable(parent:MovieClip, color:Boolean, direction:int, isEnemy:Boolean)
		{
			var path:String;		
			isGreen = color;
			belongsToEnemy = isEnemy;
			row = 0;
			column = 0;
					
			switch (direction)
			{
				case 0 :
					if (isGreen)
						path = "assets/swfs/upgreenarrow25.swf";
					else
						path = "assets/swfs/upredarrow25.swf";
					break;
				case 1 :
					if (isGreen)
						path = "assets/swfs/rightgreenarrow25.swf";
					else
						path = "assets/swfs/rightredarrow25.swf";
					break;
				case 2 :
					if (isGreen)
						path = "assets/swfs/downgreenarrow25.swf";
					else
						path = "assets/swfs/downredarrow25.swf";
					break;
				case 3 :
					if (isGreen)
						path = "assets/swfs/leftgreenarrow25.swf";
					else
						path = "assets/swfs/leftredarrow25.swf";
					break;
			}
			
			super(parent, path, 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
				
			if (!loaded)
			{
				loaded = true;
				assetClip.visible = true;
				assetClip.x = findX();
				assetClip.y = findY();
			}
		}
		
		public function reposition(logHeight:int, logWidth:int)
		{
			if ((row == logHeight - 1) && (column == logWidth - 1))
			{
				assetClip.visible = false;
				return;
			}
			
			row = (row + 1) % logHeight;
			
			if (row == 0)
				column++;
			
			if (assetClip == null)
				return;
				
			assetClip.x = findX();
			assetClip.y = findY();
		}
		
		private function findX() : Number
		{
			if (belongsToEnemy)
				return enemyStartX + (column * (assetClip.width + 5));
			
			return allyStartX - (column * (assetClip.width + 5));
		}
		
		private function findY() : Number
		{
			if (belongsToEnemy)
				return enemyStartY + (row * assetClip.height);
			
			return allyStartY + (row * assetClip.height);
		}
	}
}