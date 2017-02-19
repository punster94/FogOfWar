package
{
	public class Node
	{
		private var _row: int;
		private var _column: int;
		
		public function Node(r:int = 0, c:int = 0)
		{
			row = r;
			column = c;
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function set row(value:int):void 
		{
			_row = value;
		}
		
		public function get column():int 
		{
			return _column;
		}
		
		public function set column(value:int):void 
		{
			_column = value;
		}
		
	}
}