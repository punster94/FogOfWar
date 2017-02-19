package
{
	import flash.display.MovieClip;
	
	public class LevelCompleteScreen extends Screen
	{
		private var currentLevel:int;
		private var movesMade:int, timeTaken:Number, allyScore:Number, enemyScore:Number;
		private var menu:LevelCompleteRenderable;
		private var titleText:String;
		private var allyTime:Number, enemyTime:Number;
		private var allyWon:Boolean;
		private var levelCompleted:Level;
		
		public function LevelCompleteScreen(levelScreen:LevelScreen)
		{
			movesMade = levelScreen.getPlayer().movesInLevel();
			timeTaken = levelScreen.lastLevelClearedIn();
			titleText = levelCompleteTitleText(levelScreen);
			levelCompleted = levelScreen.getCurrentLevel();
			allyTime = levelScreen.getAllyTime();
			enemyTime = levelScreen.getEnemyTime();
			allyScore = calculateAllyScore();
			enemyScore = calculateEnemyScore();
			menu = new LevelCompleteRenderable(this);
			objectsToUpdate.push(menu);
		}
		
		private function levelCompleteTitleText(levelScreen:LevelScreen) : String
		{
			if (levelScreen.onSameTile())
			{
				allyWon = false;
				return "Sabotage Successful";
			}
			
			if (levelScreen.getPlayer().lostLevel())
			{
				allyWon = false;
				return "Ally Out Of Time";
			}
			
			allyWon = true;
				
			if (levelScreen.getEnemy().lostLevel())
				return "Saboteur Out Of Time";
				
			return "Extraction Executed";
		}
		
		public function nextLevel()
		{
			MainManager(parent).nextLevel();
		}
		
		public function restartLevel()
		{
			MainManager(parent).setState(3);
		}
		
		public function returnToMenu()
		{
			MainManager(parent).setState(1);
		}
		
		public function reappear(levelScreen:LevelScreen)
		{
			movesMade = levelScreen.getPlayer().movesInLevel();
			timeTaken = levelScreen.lastLevelClearedIn();
			titleText = levelCompleteTitleText(levelScreen);
			levelCompleted = levelScreen.getCurrentLevel();
			displayProperBackground();
			allyTime = levelScreen.getAllyTime();
			enemyTime = levelScreen.getEnemyTime();
			allyScore = calculateAllyScore();
			enemyScore = calculateEnemyScore();
			menu.setText();
			menu.assetClip.visible = true;
			objectsToUpdate.push(menu);
			addChild(menu.assetClip);
		}
		
		public function displayProperBackground()
		{
			if (allyWon)
			{
				menu.assetClip.getChildByName("sabotageImage").visible = false;
				menu.assetClip.getChildByName("extractionImage").visible = true;
				SoundManager.getInstance().playAllyWinSound();
			}
			else
			{
				menu.assetClip.getChildByName("sabotageImage").visible = true;
				menu.assetClip.getChildByName("extractionImage").visible = false;
				SoundManager.getInstance().playEnemyWinSound();
			}
		}
		
		public function getLevelCompleteTitleText() : String
		{
			return titleText;
		}
		
		public function disappear()
		{
			menu.assetClip.visible = false;
		}
		
		public function moves() : int
		{
			return movesMade;
		}
		
		public function time() : Number
		{
			return timeTaken;
		}
		
		public function getAllyScore() : Number
		{
			return allyScore;
		}
		
		public function getEnemyScore() : Number
		{
			return enemyScore;
		}
		
		public function getAllyTime() : Number
		{
			return allyTime;
		}
		
		public function getEnemyTime() : Number
		{
			return enemyTime;
		}
		
		protected function calculateScore(time:Number, isAlly:Boolean) : Number
		{
			var s = 1000 * (time / levelCompleted.time) - movesMade * (time / levelCompleted.time) * 10;
			
			if (!isAlly == allyWon)
			{ 
				s /= 2;
				//s += movesMade * (time / levelCompleted.time)
			}
			if (s < 0)
				s = 0;
			
			return Math.floor(s);
		}
		
		private function calculateAllyScore() : Number
		{
			return calculateScore(allyTime, true);
		}
		
		private function calculateEnemyScore() : Number
		{
			return calculateScore(enemyTime, false);
		}
	}
}