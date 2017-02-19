package
{
	public class InfoScreen extends Screen
	{		
		public function InfoScreen()
		{
			objectsToUpdate.push(new InfoRenderable(this));
		}
		
		public function moveOn()
		{
			MainManager(parent).setState(6);
		}
		
		public function moveToLevelSelectScreen()
		{
			MainManager(parent).setState(7);
		}
	}
}