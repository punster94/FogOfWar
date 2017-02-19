package
{
	public class TutorialScreen extends Screen
	{
		public function TutorialScreen()
		{
			objectsToUpdate.push(new TutorialRenderable(this));
		}
		
		public function moveOn()
		{
			MainManager(parent).setState(2);
		}
	}
}