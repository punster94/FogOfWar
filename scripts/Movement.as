package
{
	public class Movement
	{
		private var _startNode:Node
		private var _endNode:Node;
		private var _successful:Boolean;
		private var _pairedMove:Boolean;
		
		public function Movement(s:Node, e:Node, successful:Boolean, paired:Boolean)
		{
			_startNode = s;
			_endNode = e;
			_successful = successful;
			_pairedMove = paired;
		}
		
		public function get startNode():Node 
		{
			return _startNode;
		}
		
		public function set startNode(value:Node):void 
		{
			_startNode = value;
		}
		
		public function get endNode():Node 
		{
			return _endNode;
		}
		
		public function set endNode(value:Node):void 
		{
			_endNode = value;
		}
		
		public function get successful():Boolean 
		{
			return _successful;
		}
		
		public function set successful(value:Boolean):void 
		{
			_successful = value;
		}
		
		public function get pairedMove():Boolean 
		{
			return _pairedMove;
		}
		
		public function set pairedMove(value:Boolean):void 
		{
			_pairedMove = value;
		}
		
		public function y() : int
		{
			var difference:int = endNode.row - startNode.row;
			
			if (!successful)
			{
				if (difference > 1)
					return -1;
				if (difference < -1)
					return 1;
			}
				
			return endNode.row - startNode.row;
		}
		
		public function ySign() : int
		{
			return y() < 0 ? -1 : 1;
		}
		
		public function x() : int
		{
			var difference:int = endNode.column - startNode.column;
			
			if (!successful)
			{
				if (difference > 1)
					return -1;
				if (difference < -1)
					return 1;
			}
				
			return endNode.column - startNode.column;
		}
		
		public function xSign() : int
		{
			return x() < 0 ? -1 : 1;
		}
		
		public function getDivider() : int
		{
			if (pairedMove)
				return 2;
				
			return 1;
		}
	}
}