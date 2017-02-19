package
{
	import flash.display.Stage;
	
	public final class StageMetrics
	{
		private var height:Number, width:Number;
		
		private static var instance:StageMetrics;
		
		public function StageMetrics()
		{		
			instance = this;
		}
		
		public static function getInstance() : StageMetrics
		{
			if (!instance)
			{
				new StageMetrics();
			}
			
			return instance;
		}
		
		public function stageHeight()
		{
			return height;
		}
		
		public function stageWidth()
		{
			return width;
		}
		
		public function initialize(stage:Stage)
		{
			height = stage.stageHeight;
			width = stage.stageWidth;
		}
	}
}