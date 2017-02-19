package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.filters.GlowFilter;
	
	public class Player extends Renderable
	{
		private var soundManager:SoundManager;
		
		private var tileWidth:Number, tileHeight:Number;
		
		private var movingLeft = false, movingRight = false, movingUp = false, movingDown = false;
		
		private var _currentRow:int,  _currentColumn:int;
		
		private var turnsTaken:int;
		
		private var wasMovedLast:Boolean;
		
		private var _pathFollowed:Array;
		private var canBeMoved:Boolean;
		private var retracingPath:Boolean;
		private var delayBetweenMovesInRetrace:Number = 1100;
		private var startTime:Number;
		private var pathIndex:Number;
		
		private var turnTimer:Timer;
		private var timeForTurn:Number;
		private var turnTick:Number = 20;
		private var lost:Boolean;
		
		private var thoughtTimer:Timer;
		private var ticksUntilNextThought:Number = 10;
		private var thoughtTick:Number = 1000;
		private var thoughtsPerTurn:int = 2;
		private var thoughtsThisTurn:int = 0;
		
		private var failedMovementTimer:Timer;
		private var currentFailedMovement:Movement;
		
		private var numberOfColumns:int, numberOfRows:int;
		
		private var isEnemy:Boolean;
		private var turnComplete:Boolean;
		private var canMoveAgain:Boolean;
		private var playerCollided:Boolean;
		private var up:int, down:int, left:int, right:int;
		
		public function Player(parent:MovieClip, xStart:Number, yStart:Number, tw:Number, th:Number, enemy:Boolean)
		{
			var assetUrl:String = (enemy) ? "assets/swfs/soldierIcon_evil.swf" : "assets/swfs/soldierIcon_good.swf";
			
			super(parent, assetUrl, xStart, yStart);
			
			tileWidth = tw;
			tileHeight = th;
			playerCollided = false;
			wasMovedLast = false;
			canBeMoved = true;
			retracingPath = false;
			isEnemy = enemy;
			
			soundManager = SoundManager.getInstance();
			
			turnComplete = enemy;
			
			if (isEnemy)
			{
				up = Keyboard.UP;
				down = Keyboard.DOWN;
				left = Keyboard.LEFT;
				right = Keyboard.RIGHT;
			}
			else
			{
				up = Keyboard.W;
				down = Keyboard.S;
				left = Keyboard.A;
				right = Keyboard.D;
			}
			
			turnTimer = new Timer(turnTick, timeForTurn);
			lost = false;
			
			thoughtTimer = new Timer(thoughtTick, ticksUntilNextThought);
			thoughtTimer.addEventListener(TimerEvent.TIMER_COMPLETE, playThoughtSound);
			
			failedMovementTimer = new Timer(delayBetweenMovesInRetrace / 4, 1);
			failedMovementTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleFailedMovementAnimation);
			
			_pathFollowed = new Array();
		}
		
		public function Update(event:Event)
		{
			if (!loaded && assetClip != null)
			{
				assetClip.width = tileWidth / 2;
				assetClip.height = tileHeight / 2;
				loaded = true;
				
				if (isEnemy)
				{
					assetClip.filters = [new GlowFilter(0xC12024)];
				}
				else
					assetClip.filters = [new GlowFilter(0x5FBA7D)];
				
				if (LevelScreen(parentClip).inDebugMode())
					assetClip.visible = true;
				
				setNumberOfRowsAndColumns();
				
				startBubbleState();
			}
			
			if (loaded && canBeMoved && !turnComplete)
			{	
				if (!movingUp && isPressed(up))
				{
					movingUp= true;
					moveUp();
				}
				else if (movingUp && !isPressed(up))
				{
					movingUp = false;
				}
				
				if (!movingDown && isPressed(down))
				{
					movingDown = true;
					moveDown();
				}
				else if (movingDown && !isPressed(down))
				{
					movingDown = false;
				}
				
				if (!movingRight && isPressed(right))
				{
					movingRight = true;
					moveRight();
				}
				else if (movingRight && !isPressed(right))
				{
					movingRight = false;
				}
				
				if (!movingLeft && isPressed(left))
				{
					movingLeft = true;
					moveLeft();
				}
				else if (movingLeft && !isPressed(left))
				{
					movingLeft = false;
				}
			}
			
			else if (retracingPath)
			{	
				var divider:int = 1;
				
				if (pathFollowed[pathIndex] != undefined)
					divider = pathFollowed[pathIndex].getDivider();
				
				if (new Date().getTime() - startTime >= delayBetweenMovesInRetrace / divider) 
				{
					startTime = new Date().getTime();
					
					if (pathIndex  == pathFollowed.length) 
					{
						retracingPath = false;
						LevelScreen(parentClip).stillRetracing();
					}
					
					moveToNextPostion(pathIndex);
					pathIndex ++;
				}
			}
		}
		
		public function setTurnTimerLength(seconds:Number)
		{
			timeForTurn = seconds * 1000 / turnTick;
			turnTimer = new Timer(turnTick, timeForTurn);
			turnTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleOutOfTime);
		}
		
		public function timeRemainingInSeconds() : Number
		{
			if (turnTimer == null)
				return Math.round(turnTick * timeForTurn / 1000);
			return Math.round(turnTick * (timeForTurn - turnTimer.currentCount) / 1000);
		}
		
		public function startTurn()
		{
			turnComplete = false;
			playerCollided = false;
			
			if (isEnemy) 
			{
				canMoveAgain = true;
			}
			else 
			{
				canMoveAgain = false;
			}
			
			turnTimer.start();
			thoughtTimer.start();
		}
		
		public function delayTurn()
		{
			turnTimer.stop();
			turnComplete = true;
		}
		
		public function stillRetracing() : Boolean
		{
			return retracingPath;
		}
		
		private function setNumberOfRowsAndColumns()
		{
			numberOfRows = LevelScreen(parentClip).currentRows();
			numberOfColumns = LevelScreen(parentClip).currentColumns();
		}
		
		public function movesInLevel() : int
		{
			return turnsTaken;
		}
		
		public function repositionForRetrace(row:int, column:int, x:Number, y:Number):void 
		{
			turnTimer.stop();
			thoughtTimer.stop();
			
			assetClip.x = x + tileWidth / 4;
			assetClip.y = y + tileHeight / 4;
			currentRow = row;
			currentColumn = column;
			canBeMoved = false;
			
			assetClip.visible = true;
		}
			
		public function reposition(row:int, column:int, w:Number, h:Number)
		{
			_pathFollowed = new Array();
			
			wasMovedLast = false;
			canBeMoved = true;
			currentRow = row;
			currentColumn = column;
			tileWidth = w;
			tileHeight = h;
			setNumberOfRowsAndColumns();
			
			if (assetClip != null)
				assetClip.parent.parent.setChildIndex(assetClip.parent, assetClip.parent.parent.numChildren - 1);
			
			startBubbleState();
			
			turnsTaken = 0;
			
			turnTimer.reset();
			lost = false;
			
			thoughtTimer.reset();
			thoughtTimer.stop();
			thoughtsThisTurn = 0;
		}
		
		public function moveAlongFollowedPath():void 
		{
			retracingPath = true;
			pathIndex = 0;
			startTime = new Date().getTime();
		}
		
		private function moveToNextPostion(index:int) : void 
		{	
			if (index >= pathFollowed.length)
				return;
				
			var movement:Movement = pathFollowed[index];
				
			if (movement.successful)
			{				
				currentRow = movement.endNode.row ;
				currentColumn = movement.endNode.column;
				
				assetClip.x += tileWidth * movement.x();
				assetClip.y += tileHeight * movement.y();
			}
			else
			{	
				assetClip.x += movement.x() * (1 / 2) * tileWidth;
				assetClip.y += movement.y() * (1 / 2) * tileHeight;
				
				currentFailedMovement = movement;
				failedMovementTimer.start();
			}
		}
		
		private function handleFailedMovementAnimation(event:TimerEvent)
		{	
			assetClip.x -= (1 / 2) * tileWidth * currentFailedMovement.x();
			assetClip.y -= (1 / 2) * tileHeight * currentFailedMovement.y();
		
			startTime = new Date().getTime();
		}
		
		private function playThoughtSound(event:TimerEvent)
		{
			if (thoughtsThisTurn < thoughtsPerTurn)
			{
				soundManager.playThoughtSound(isEnemy);
				thoughtTimer.reset();
				thoughtTimer.start();
				thoughtsThisTurn++;
			}
		}
		
		private function handleOutOfTime(event:TimerEvent)
		{
			lost = true;
			LevelScreen(parentClip).completedLevel();
		}
		
		public function lostLevel() : Boolean
		{
			return lost;
		}
		
		private function moveRight()
		{
			wasMovedLast = false;
			
			LevelScreen(parentClip).selectNewGeneralImage(!isEnemy, 0);
			LevelScreen(parentClip).selectNewGeneralImage(isEnemy, 2);
			displayText("East");
			
			var nextMove:Movement = new Movement(new Node(currentRow, currentColumn), new Node(currentRow, (currentColumn + 1) % numberOfColumns), true, true);
			
			if (enterable(currentRow, (currentColumn + 1) % (numberOfColumns)))
			{
				currentColumn += 1;
				currentColumn %= numberOfColumns;
				
				if (currentColumn != 0)
					assetClip.x += tileWidth;
				else
					assetClip.x -= tileWidth * (numberOfColumns - 1);
				
				LevelScreen(parentClip).showPositiveGlowEffect();
				
				if (!isEnemy && !playerCollided)
					nextMove.pairedMove = false;
					
				soundManager.playCommandSound(isEnemy);
			}
			else 
			{
				if (!isEnemy && !canMoveAgain && !playerCollided) 
				{
					canMoveAgain = true;
					playerCollided = true;
				}
				
				nextMove.successful = false;
				LevelScreen(parentClip).showNegativeGlowEffect();
				displayRadioAlert();
				soundManager.playRadioSound(isEnemy);
			}
			
			pathFollowed.push(nextMove);
			LevelScreen(parentClip).addMovementToLog(1, isEnemy, nextMove.successful);
			completeTurn();
			
			if (reachedGoal())
				completeLevel();
		}
	
		private function moveLeft()
		{
			wasMovedLast = false;
			
			LevelScreen(parentClip).selectNewGeneralImage(!isEnemy, 0);
			LevelScreen(parentClip).selectNewGeneralImage(isEnemy, 4);
			displayText("West");
			
			var nextMove:Movement = new Movement(new Node(currentRow, currentColumn), new Node(currentRow, (currentColumn - 1 + numberOfColumns) % numberOfColumns), true, true);
			
			if (enterable(currentRow, (currentColumn + numberOfColumns - 1) % numberOfColumns))
			{
				currentColumn += numberOfColumns - 1;
				currentColumn %= numberOfColumns;
				
				if (currentColumn != numberOfColumns - 1)
					assetClip.x -= tileWidth;
				else
					assetClip.x += tileWidth * (numberOfColumns - 1);
				
				LevelScreen(parentClip).showPositiveGlowEffect();
				
				if (!isEnemy && !playerCollided)
					nextMove.pairedMove = false;
				
				soundManager.playCommandSound(isEnemy);
			}
			else 
			{
				if (!isEnemy && !canMoveAgain && !playerCollided) 
				{
					canMoveAgain = true;
					playerCollided = true;
				}
				
				nextMove.successful = false;
				LevelScreen(parentClip).showNegativeGlowEffect();
				displayRadioAlert();
				soundManager.playRadioSound(isEnemy);
			}
			
			pathFollowed.push(nextMove);
			LevelScreen(parentClip).addMovementToLog(3, isEnemy, nextMove.successful);
			completeTurn();
			
			if (reachedGoal())
				completeLevel();
		}
		
		private function moveDown()
		{
			wasMovedLast = true;
			
			LevelScreen(parentClip).selectNewGeneralImage(isEnemy, 3);
			LevelScreen(parentClip).selectNewGeneralImage(!isEnemy, 0);		
			displayText("South");
			
			var nextMove:Movement = new Movement(new Node(currentRow, currentColumn), new Node((currentRow + 1) % numberOfRows, currentColumn), true, true);
			
			if (enterable((currentRow + 1) % (numberOfRows), currentColumn))
			{
				currentRow += 1;
				currentRow %= numberOfRows;
				
				if (currentRow != 0)
					assetClip.y += tileHeight;
				else
					assetClip.y -= tileHeight * (numberOfRows - 1);
					
				LevelScreen(parentClip).showPositiveGlowEffect();
				
				if (!isEnemy && !playerCollided)
					nextMove.pairedMove = false;
					
				soundManager.playCommandSound(isEnemy);
			}
			else 
			{
				if (!isEnemy && !canMoveAgain && !playerCollided) 
				{
					canMoveAgain = true;
					playerCollided = true;
				}
				
				nextMove.successful = false;
				LevelScreen(parentClip).showNegativeGlowEffect();
				displayRadioAlert();
				soundManager.playRadioSound(isEnemy);
			}
			
			pathFollowed.push(nextMove);
			LevelScreen(parentClip).addMovementToLog(2, isEnemy, nextMove.successful);
			completeTurn();
			
			if (reachedGoal())
				completeLevel();
		}
		
		private function moveUp()
		{
			wasMovedLast = true;
			
			LevelScreen(parentClip).selectNewGeneralImage(isEnemy, 1);
			LevelScreen(parentClip).selectNewGeneralImage(!isEnemy, 0);
			displayText("North");
			
			var nextMove:Movement = new Movement(new Node(currentRow, currentColumn), new Node((currentRow + numberOfRows - 1) % numberOfRows, currentColumn), true, true);
			
			if (enterable((currentRow + numberOfRows - 1) % (numberOfRows), currentColumn))
			{
				currentRow += numberOfRows - 1;
				currentRow %= numberOfRows;
				
				if (currentRow != numberOfRows - 1)
					assetClip.y -= tileHeight;
				else
					assetClip.y += tileHeight * (numberOfRows - 1);
					
				LevelScreen(parentClip).showPositiveGlowEffect();
				
				if (!isEnemy && !playerCollided)
					nextMove.pairedMove = false;
					
				soundManager.playCommandSound(isEnemy);
			}
			else 
			{
				if (!isEnemy && !canMoveAgain && !playerCollided) 
				{
					canMoveAgain = true;
					playerCollided = true;
				}

				nextMove.successful = false;
				LevelScreen(parentClip).showNegativeGlowEffect();
				displayRadioAlert();
				soundManager.playRadioSound(isEnemy);
			}
			
			pathFollowed.push(nextMove);
			LevelScreen(parentClip).addMovementToLog(0, isEnemy, nextMove.successful);
			completeTurn();
			
			if (reachedGoal())
				completeLevel();
		}
		
		private function completeLevel()
		{
			LevelScreen(parentClip).completedLevel();
		}
		
		private function startBubbleState()
		{
			LevelScreen(parentClip).clearSpeechBubbles();
		}
		
		private function displayText(text:String)
		{
			LevelScreen(parentClip).clearSpeechBubbles();
			
			if (isEnemy)
			{
				LevelScreen(parentClip).displayBubble(text, 1);
			}
			else
			{
				LevelScreen(parentClip).displayBubble(text, 0);
			}
		}
		
		private function displayRadioAlert()
		{
			if (isEnemy)
			{
				LevelScreen(parentClip).displayBubble("!", 3);
			}
			else
			{
				LevelScreen(parentClip).displayBubble("!", 2);
			}
		}
		
		private function completeTurn()
		{
			thoughtTimer.reset();
			thoughtsThisTurn = 0;
			
			if (!canMoveAgain)
			{
				turnsTaken++;
				turnComplete = true;
				LevelScreen(parentClip).completePlayerTurn(isEnemy);
				LevelScreen(parentClip).displayTurn(isEnemy);
				thoughtTimer.stop();
			}
			else 
			{
				canMoveAgain = false;
				thoughtTimer.start();
			}
		}
		
		private function enterable(row:int, column:int) : Boolean
		{
			return LevelScreen(parentClip).enterable(row, column, isEnemy);
		}
		
		private function reachedGoal() : Boolean
		{
			if (!isEnemy)
			{
				lost = LevelScreen(parentClip).onSameTile();
				
				return LevelScreen(parentClip).atGoal(currentRow, currentColumn) || LevelScreen(parentClip).onSameTile();
			}
			
			return LevelScreen(parentClip).onSameTile();
		}
		
		public function get pathFollowed() : Array 
		{
			return _pathFollowed;
		}
		
		public function get currentRow() : int 
		{
			return _currentRow;
		}
		
		public function get currentColumn() : int 
		{
			return _currentColumn;
		}
		
		public function set currentRow(value:int):void 
		{
			_currentRow = value;
		}
		
		public function set currentColumn(value:int):void 
		{
			_currentColumn = value;
		}
	}
}