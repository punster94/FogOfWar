package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public final class InputManager
	{
		public static var inputHash:Object = {};
		private static var instance:InputManager;
		private static var mainManager:MainManager;
		private static var completedClick:Boolean;
				
		public function InputManager()
		{	
			instance = this;
			completedClick = true;
		}
		
		public static function getInstance(mm:MainManager) : InputManager
		{
			if (!instance)
			{
				new InputManager();
				
				mainManager = mm;
				
				mm.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				mm.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
				mm.stage.addEventListener(MouseEvent.MOUSE_DOWN, clicked);
				mm.stage.addEventListener(MouseEvent.MOUSE_UP, unclicked);
			}
			
			return instance;
		}
		
		public static function isPressed(keyCode:uint) : Boolean
		{
			return inputHash[keyCode] !== undefined;
		}
		
		public static function isClickedInBounds(topX:int, topY:int, bottomX:int, bottomY:int) : Boolean
		{
			if (inputHash["mouseX"] == undefined || !completedClick)
				return false;
			
			if (topX <= inputHash["mouseX"] && bottomX >= inputHash["mouseX"] && topY <= inputHash["mouseY"] && bottomY >= inputHash["mouseY"])
			{
				completedClick = false;
				SoundManager.getInstance().playButtonClickedSound();
				return true;
			}
			return false;
		}
		
		private static function keyPressed(event:KeyboardEvent) : void
		{
			inputHash[event.keyCode] = 1;
		}
		
		private static function keyReleased(event:KeyboardEvent) : void 
		{
			delete inputHash[event.keyCode];
		}
		
		private static function clicked(event:MouseEvent) : void
		{
			inputHash["mouseX"] = mainManager.mouseX;
			inputHash["mouseY"] = mainManager.mouseY;
		}
		
		private static function unclicked(event:MouseEvent) : void
		{
			completedClick = true;
			delete inputHash["mouseX"];
			delete inputHash["mouseY"];
		}
	}
}