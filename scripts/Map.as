package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Map extends Renderable
	{
		private var stepsTakenBox:TextField;
		private var tallTimeMinutesBox:TextField, tallTimeSecondsBox:TextField;
		private var fatTimeMinutesBox:TextField, fatTimeSecondsBox:TextField;
		private var levelNumberBox:TextField;
		private var allyTurn:MovieClip;
		private var enemyTurn:MovieClip;
		
		public function Map(parent:MovieClip)
		{
			super(parent, "assets/swfs/levelScreen.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				assetClip.visible = true;
				
				stepsTakenBox = TextField(assetClip.getChildByName("stepsTakenText"));
				levelNumberBox = TextField(assetClip.getChildByName("levelNumberText"));
				tallTimeMinutesBox = TextField(assetClip.getChildByName("tallTimeMinutesText"));
				fatTimeMinutesBox = TextField(assetClip.getChildByName("fatTimeMinutesText"));
				tallTimeSecondsBox = TextField(assetClip.getChildByName("tallTimeSecondsText"));
				fatTimeSecondsBox = TextField(assetClip.getChildByName("fatTimeSecondsText"));
				allyTurn = MovieClip(assetClip.getChildByName("allyTurn"));
				enemyTurn = MovieClip(assetClip.getChildByName("enemyTurn"));
				
				allyTurn.visible = true;
				enemyTurn.visible = false;
			}
			
			updateGameStatistics();
		}
		
		private function updateGameStatistics()
		{
			stepsTakenBox.text = String(LevelScreen(parentClip).getMovesInLevel());
			levelNumberBox.text = LevelScreen(parentClip).getCurrentLevelNumber();
			
			tallTimeMinutesBox.text = String(calculateMinutesFromSeconds(LevelScreen(parentClip).getAllyTime()));
			fatTimeMinutesBox.text = String(calculateMinutesFromSeconds(LevelScreen(parentClip).getEnemyTime()));
			
			var seconds:int = calculateSecondsFromSeconds(LevelScreen(parentClip).getAllyTime());
			tallTimeSecondsBox.text = addLeadingZeroIfNecessary(seconds);
			
			seconds = calculateSecondsFromSeconds(LevelScreen(parentClip).getEnemyTime())
			fatTimeSecondsBox.text = addLeadingZeroIfNecessary(seconds);
		}
		
		private function addLeadingZeroIfNecessary(number:int) : String
		{
			if (number < 10)
				return String("0" + number);
				
			return String(number);
		}
		
		private function calculateMinutesFromSeconds(seconds:Number) : int
		{
			return int(seconds / 60);
		}
		
		private function calculateSecondsFromSeconds(seconds:Number) : int
		{
			return seconds - (calculateMinutesFromSeconds(seconds) * 60);
		}
		
		public function displayTurn(isEnemy:Boolean)
		{
			if (!isEnemy)
			{
				allyTurn.visible = false;
				enemyTurn.visible = true;
			}
			else
			{
				allyTurn.visible = true;
				enemyTurn.visible = false;
			}
		}
	}
}