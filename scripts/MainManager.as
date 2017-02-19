package
{	
	import flash.display.MovieClip;
	import flash.accessibility.AccessibilityProperties;
	import flash.accessibility.Accessibility;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class MainManager extends MovieClip
	{
		public var inputManager:InputManager;
		
		private var screen:Screen = null;
		private var previousState:int;
		private var state:int = -1;
		private var currentLevel:int;
		private var levelScreen:LevelScreen;
		private var levelCompleteScreen:LevelCompleteScreen;
		
		public function MainManager()
		{			
			inputManager = InputManager.getInstance(this);
			
			StageMetrics.getInstance().initialize(stage);
			Levels.getInstance().setLevels();
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
			state = 1;
			changeState();
		}
		
		private function changeState() : void
		{
			if (screen != null)
			{
				if (screen is LevelCompleteScreen)
					LevelCompleteScreen(screen).disappear();
				
				screen.clear();
			}
			previousState = state;
			
			var newScreen:Screen;
			
			switch(state)
			{
				case 0 :
					currentLevel = 0;
					newScreen = new MainMenuScreen();
					break;
				case 1 :
					currentLevel = 0;
					newScreen = new InfoScreen();
					break;
				case 2 :
					if (levelScreen == null)
					{
						levelScreen = new LevelScreen(510, 90, 900, 900, currentLevel);
					}
					else
					{
						levelScreen.loadLevelNumber(currentLevel);
					}
					
					newScreen = levelScreen;
					break;
				case 3 :
					moveToLevel(currentLevel);
					break;
				case 4 :
					if (levelCompleteScreen == null)
					{
						levelCompleteScreen = new LevelCompleteScreen(levelScreen);
					}
					else
					{
						levelCompleteScreen.disappear();
						levelCompleteScreen.reappear(levelScreen);
					}
					
					newScreen = levelCompleteScreen;
					break;
				case 5 :
					newScreen = new GameOverScreen();
					break;
				case 6 :
					newScreen = new TutorialScreen();
					break;
				case 7 :
					newScreen = new LevelSelectScreen(this);
					break;
			}
			
			if (newScreen != null)
			{
				screen = newScreen;
				addChild(newScreen);
			}
		}
		
		public function setCurrentLevel(level:int)
		{
			currentLevel = level;
			setState(2);
		}
		
		public function nextLevel()
		{
			if (currentLevel >= Levels.numberOfLevels() - 1)
			{
				setState(1);
			}
			else
			{
				currentLevel++;
				setState(2);
			}
		}
		
		public function moveToLevel(level:int)
		{
			if (level <= Levels.numberOfLevels() - 1)
			{
				currentLevel = level;
				state = 2;
			}
			else
			{
				state = 4;
			}
			
			changeState();
		}
		
		public function manageCompletedLevel(enemyWon:Boolean)
		{
			// TODO: Remember to render the level completed screen with different text when the player wins versus when the enemy wins
			setState(4);
		}
		
		public function setState(s:int)
		{
			state = s;
			changeState();
		}
		
		private function Update(event:Event) : void
		{			
			if (screen != null)
				screen.Update(event);
		}
	}
}