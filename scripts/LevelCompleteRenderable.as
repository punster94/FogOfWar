package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class LevelCompleteRenderable extends Renderable
	{
		private var nextButton:MovieClip;
		private var replayButton:MovieClip;
		private var mainMenuButton:MovieClip;
		private var movesMadeText:TextField, allyScoreText:TextField, allyTimeTakenText:TextField, enemyScoreText:TextField, enemyTimeTakenText:TextField;
		private var titleText:TextField;
		
		public function LevelCompleteRenderable(parent:MovieClip)
		{
			super(parent, "assets/swfs/completeScreen.swf", 0, 0);
		}
		
		public function Update(event:Event) : void
		{
			if (assetClip == null)
				return;
			
			if (!assetClip.visible)
			{
				nextButton = MovieClip(assetClip.getChildByName("nextButton"));
				replayButton = MovieClip(assetClip.getChildByName("replayButton"));
				mainMenuButton = MovieClip(assetClip.getChildByName("mainMenuButton"));
				titleText = TextField(MovieClip(assetClip.getChildByName("titleContainer")).getChildByName("levelCompleteTitle"));
				movesMadeText = TextField(assetClip.getChildByName("movesMadeText"));
				
				allyTimeTakenText = TextField(assetClip.getChildByName("allyTimeTakenText"));
				allyScoreText = TextField(assetClip.getChildByName("allyScoreText"));
				
				enemyTimeTakenText = TextField(assetClip.getChildByName("enemyTimeTakenText"));
				enemyScoreText = TextField(assetClip.getChildByName("enemyScoreText"));
				
				setText();
				
				LevelCompleteScreen(parentClip).displayProperBackground();
				assetClip.visible = true;
			}
			
			if (InputManager.isClickedInBounds(nextButton.x, nextButton.y, nextButton.x + nextButton.width, nextButton.y + nextButton.height))
				LevelCompleteScreen(parentClip).nextLevel();
			
			if (InputManager.isClickedInBounds(replayButton.x, replayButton.y, replayButton.x + replayButton.width, replayButton.y + replayButton.height))
				LevelCompleteScreen(parentClip).restartLevel();
			
			if (InputManager.isClickedInBounds(mainMenuButton.x, mainMenuButton.y, mainMenuButton.x + mainMenuButton.width, mainMenuButton.y + mainMenuButton.height))
				LevelCompleteScreen(parentClip).returnToMenu();
		}
		
		public function setText()
		{
			allyTimeTakenText.text = String(LevelCompleteScreen(parentClip).getAllyTime() + " seconds");
			allyScoreText.text = String(LevelCompleteScreen(parentClip).getAllyScore());
			
			enemyTimeTakenText.text = String(LevelCompleteScreen(parentClip).getEnemyTime() + " seconds");
			enemyScoreText.text = String(LevelCompleteScreen(parentClip).getEnemyScore());
			
			titleText.text = String(LevelCompleteScreen(parentClip).getLevelCompleteTitleText());
			movesMadeText.text = String(LevelCompleteScreen(parentClip).moves());
		}
	}
}