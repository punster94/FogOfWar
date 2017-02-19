

package {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Renderable {
		
		private var baseClip:MovieClip; // primary movie clip that all others attach to
		protected var parentClip:MovieClip; // parent of the base clip
		public var assetClip:MovieClip; // used to load external assets		
		
		private var startX:Number;
		private var startY:Number;
		
		protected var loaded = false;
				
		public function Renderable(argParentClip:MovieClip, argAssetPath:String, x:Number, y:Number) {	
			this.parentClip = argParentClip;
			
			this.startX = x;
			this.startY = y;
			
			// Create the base clip on the parent
			this.baseClip = new MovieClip();
			this.parentClip.addChild(this.baseClip);
			
			// Create a loader and load the provided asset path
			var loader:Loader = new Loader();
			loader.load(new URLRequest(argAssetPath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
		}
		
		// TODO: Make all assets loaded in appear at once
		
		private function completedExternalAssetLoad(event:Event):void {
			// Assign the movie clip for the asset and center it on the base clip	
			this.assetClip = MovieClip(event.target.content);
			this.assetClip.visible = false;
			this.baseClip.addChild(this.assetClip);
			this.assetClip.x = startX;
			this.assetClip.y = startY;
			
			// Remove the event listener that triggered this call back
			event.target.removeEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
		}
		
		public function getAssetClip() : MovieClip
		{
			return assetClip;
		}
		
		public function clear() : void
		{
			if (this.baseClip.parent == this.parentClip)
				this.parentClip.removeChild(this.baseClip);
		}
		
		protected function isPressed(keyCode:uint) : Boolean
		{
			if (assetClip == null)
				return false;
			return InputManager.isPressed(keyCode);
		}
	}
	
}
