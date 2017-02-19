package
{
	public class MainMenuScreen extends Screen
	{	
		public function MainMenuScreen() 
		{
			var mainMenu:MainMenu = new MainMenu(this, 0, 0);
			addUpdatableObject(mainMenu);
		}
		
		public function start() : void
		{
			MainManager(parent).setState(1);
		}
	}
}