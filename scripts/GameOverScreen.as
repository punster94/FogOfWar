package
{
	public class GameOverScreen extends Screen
	{
		private var menu:GameOverRenderable;
		
		public function GameOverScreen()
		{
			menu = new GameOverRenderable(this);
			objectsToUpdate.push(menu);
		}
		
		public function restartLevel()
		{
			MainManager(parent).setState(3);
		}
		
		public function returnToMenu()
		{
			MainManager(parent).setState(1);
		}
	}
}