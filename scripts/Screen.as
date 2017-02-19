package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Screen extends MovieClip 
	{
		protected var objectsToUpdate:Array = new Array();
		protected var collidableObjects:Array = new Array();
		
		public function Screen()
		{
			
		}
		
		public function clear() : void
		{
			for each (var object in objectsToUpdate)
			{
				object.clear();
			}
			
			collidableObjects = new Array();
			objectsToUpdate = new Array();
		}
		
		public function Update(event:Event) : void
		{
			for each (var item in objectsToUpdate)
			{
				item.Update(event);
			}
			
			for each (var object in collidableObjects)
			{
				object.checkCollisions(collidableObjects);
			}
		}
		
		protected function addUpdatableObject(object:Renderable)
		{
			objectsToUpdate[objectsToUpdate.length] = object;
		}
		
		protected function removeUpdatableObject(object:Renderable)
		{
			objectsToUpdate.removeAt(objectsToUpdate.indexOf(object));
		}
	}
}