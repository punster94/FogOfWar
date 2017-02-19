package
{
	import Date;
	import flash.display.IDrawCommand;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
		
	public class LevelScreen extends Screen
	{
		private var soundManager:SoundManager;
		
		private var numberOfLevels:int;
		private var currentLevelNumber:int;
		private var currentLevel:Level;
		
		private var mapHeight:Number, mapWidth:Number;
		private var xPosition:Number, yPosition:Number;
		
		private var player:Player;
		private var enemy:Player;
		private var currentPlayerIsEnemy:Boolean;
		
		private var glowEffect:GlowEffect;
		
		private var tiles:Array;
		private var currentObstacles:Array;
		
		private var startTiles:Array;
		private var enemyStartTiles:Array;
		private var currentStartTile:Tile;
		private var currentEnemyStartTile:Tile;
		private var currentGoalTile:Tile;
		
		private var map:Map;
		private var fatImages:Array;
		private var tallImages:Array;
		private var speechBubbles:Array;
		private var levelStartTime:Number, levelEndTime:Number;
		
		private var allyLog:Array;
		private var enemyLog:Array;
		private var logWidth:int = 2;
		private var logHeight:int = 20;
		private var logSize:int = logWidth * logHeight;
		
		private var debug:Boolean = false;
		
		private var bubbleTimer:Timer;
		
		public function LevelScreen(startX:Number, startY:Number, w:Number, h:Number, level:int)
		{
			soundManager = SoundManager.getInstance();
			mapHeight = h;
			mapWidth = w;
			xPosition = startX;
			yPosition = startY;
			
			numberOfLevels = Levels.numberOfLevels();
			currentLevelNumber = level;
			currentLevel = Levels.get(currentLevelNumber);
			
			tiles = new Array();
			startTiles = new Array();
			enemyStartTiles = new Array();
			currentObstacles = new Array();
			allyLog = new Array();
			enemyLog = new Array();
			loadLevel();
		}
		
		public function getPlayer() : Player
		{
			return player;
		}
		
		public function getEnemy() : Player
		{
			return enemy;
		}
		
		public function getMovesInLevel() : int
		{
			if (player == null)
				return 0;

			return player.movesInLevel();
		}
		
		public function getCurrentLevelNumber() : String
		{
			return currentLevel.name;
		}
		
		public function getCurrentLevel() : Level
		{
			return currentLevel;
		}
		
		public function loadLevelNumber(level:int)
		{
			if (level < numberOfLevels)
			{
				currentLevelNumber = level;
				currentLevel = Levels.get(level);
				
				player.setTurnTimerLength(currentLevel.time);
				enemy.setTurnTimerLength(currentLevel.time);
				
				clearLevel();
				loadLevel();
			}
			else
			{
				MainManager(parent).setState(1);
			}
		}
		
		public function nextLevel()
		{
			loadLevelNumber(++currentLevelNumber);
		}
		
		public function reloadLevel()
		{
			clearLevel();
			loadLevel();
		}
		
		public function completedLevel()
		{
			clearSpeechBubbles();
			
			levelEndTime = new Date().getTime();
			glowEffect.assetClip.alpha = 0;
			
			player.repositionForRetrace(currentStartTile.row, currentStartTile.column, currentStartTile.assetClip.x, currentStartTile.assetClip.y);
			enemy.repositionForRetrace(currentEnemyStartTile.row, currentEnemyStartTile.column, currentEnemyStartTile.assetClip.x, currentEnemyStartTile.assetClip.y);
			player.moveAlongFollowedPath();
			enemy.moveAlongFollowedPath();
		}
		
		public function moveToLevelCompletedScreen () : void 
		{
			player.assetClip.visible = false;
			enemy.assetClip.visible = false;
			MainManager(parent).manageCompletedLevel(onSameTile());
			clearLevel();
		}
		
		public function getAllyTime() : Number
		{
			if (enemy == null)
				return 0;
			return player.timeRemainingInSeconds();
		}
		
		public function getEnemyTime() : Number
		{
			if (enemy == null)
				return 0;
			return enemy.timeRemainingInSeconds();
		}
		
		public function lastLevelClearedIn() : Number
		{
			return (levelEndTime - levelStartTime) / 1000;
		}
		
		private function clearLevel()
		{			
			for each(var tile in tiles)
			{
				objectsToUpdate.removeAt(objectsToUpdate.indexOf(tile));
				tile.clear();
			}
			
			removeImagesFromUpdateList();
			
			tiles = new Array();
			startTiles = new Array();
			enemyStartTiles = new Array();
			currentObstacles = new Array();
			fatImages = new Array();
			tallImages = new Array();
			speechBubbles = new Array();
			allyLog = new Array();
			enemyLog = new Array();
			
			enemy.delayTurn();
			removeUpdatableObject(glowEffect);
			
			map.assetClip.visible = false;
			soundManager.stopLevelMusic();
		}
		
		private function removeImagesFromUpdateList()
		{
			removeItemsInArrayFromUpdateList(fatImages);
			removeItemsInArrayFromUpdateList(tallImages);
			removeItemsInArrayFromUpdateList(speechBubbles);
			removeItemsInArrayFromUpdateList(allyLog);
			removeItemsInArrayFromUpdateList(enemyLog);
		}
		
		private function removeItemsInArrayFromUpdateList(array:Array)
		{
			for each (var item in array)
			{
				removeUpdatableObject(item);
			}
		}
		
		private function addGeneralImagesToUpdateList()
		{
			addItemsInArrayToUpdateList(fatImages);
			addItemsInArrayToUpdateList(tallImages);
		}
		
		private function addSpeechBubblesToUpdateList()
		{
			addItemsInArrayToUpdateList(speechBubbles);
		}
		
		private function addItemsInArrayToUpdateList(array:Array)
		{
			for each (var item in array)
			{
				addUpdatableObject(item);
			}
		}
		
		private function selectPoseFromGivenArray(pose:int, images:Array)
		{
			for each (var image in images)
			{
				if (image.selected)
					image.deselect();
				
				if (image.poseId == pose)
					image.select();
			}
		}
		
		public function selectNewGeneralImage(fatGeneral:Boolean, pose:int)
		{
			if (fatGeneral)
			{
				selectPoseFromGivenArray(pose, fatImages);
			}
			else
			{
				selectPoseFromGivenArray(pose, tallImages);
			}
		}
		
		private function loadLevel()
		{			
			if (map == null)
			{
				map = new Map(this);
				fatImages = new Array();
				tallImages = new Array();
				speechBubbles = new Array();
			}
			else
			{
				map.assetClip.visible = true;
				addChild(map.assetClip);
			}
			
			if (objectsToUpdate.indexOf(map) == -1)
				addUpdatableObject(map);
			
			if (glowEffect == null)
			{
				glowEffect = new GlowEffect(this);
			}
			
			var row:int, column:int;
			
			for (row = 0; row < currentLevel.level[0].length; row++)
			{
				for (column = 0; column < currentLevel.level.length; column++)
				{
					var tile:Tile = createTile(currentLevel.level[row][column], row, column);
					addUpdatableObject(tile);
					tiles.push(tile);
				}
			}
			
			currentStartTile = startTiles[Math.floor(Math.random() * startTiles.length)];
			StartTile(currentStartTile).pickAsStartTile();
			currentEnemyStartTile = enemyStartTiles[Math.floor(Math.random() * enemyStartTiles.length)];
			StartTile(currentEnemyStartTile).pickAsStartTile();
			
			currentPlayerIsEnemy = false;
			
			addUpdatableObject(glowEffect);
			loadGeneralsAndBubbles();
			soundManager.startLevelMusic();
		}
		
		private function loadGeneralsAndBubbles()
		{
			fatImages.push(new GeneralRenderable(this, true, 0));
			fatImages.push(new GeneralRenderable(this, true, 1));
			fatImages.push(new GeneralRenderable(this, true, 2));
			fatImages.push(new GeneralRenderable(this, true, 3));
			fatImages.push(new GeneralRenderable(this, true, 4));
			
			tallImages.push(new GeneralRenderable(this, false, 0));
			tallImages.push(new GeneralRenderable(this, false, 1));
			tallImages.push(new GeneralRenderable(this, false, 2));
			tallImages.push(new GeneralRenderable(this, false, 3));
			tallImages.push(new GeneralRenderable(this, false, 4));
			
			speechBubbles.push(new SpeechRenderable(this, 0));
			speechBubbles.push(new SpeechRenderable(this, 1));
			speechBubbles.push(new SpeechRenderable(this, 2));
			speechBubbles.push(new SpeechRenderable(this, 3));
			
			fatImages[0].select();
			tallImages[0].select();
			speechBubbles[0].select();
			
			addGeneralImagesToUpdateList();
			addSpeechBubblesToUpdateList();
		}
		
		public function displayBubble(text:String, id:int)
		{
			if (id < 2)
				speechBubbles[id].assetClip.getChildAt(0).getChildByName("text").text = text;
			speechBubbles[id].select();
		}
		
		public function displayTurn(isEnemy:Boolean)
		{
			map.displayTurn(isEnemy);
		}
		
		public function clearBubble(id:int)
		{
			speechBubbles[id].deselect();
		}
		
		public function clearSpeechBubbles()
		{
			for each (var bubble in speechBubbles)
			{
				bubble.deselect();
			}
		}
		
		public function inDebugMode() : Boolean
		{
			return debug;
		}
		
		public function createAllyAtTile(tile:Tile)
		{
			player = createPlayerAtTile(player, tile, false);
			player.setTurnTimerLength(Levels.get(currentLevelNumber).time);
			player.startTurn();
			displayTurn(true);
		}
		
		public function createEnemyAtTile(tile:Tile)
		{
			enemy = createPlayerAtTile(enemy, tile, true);
			enemy.setTurnTimerLength(Levels.get(currentLevelNumber).time);
		}
		
		public function stillRetracing()
		{
			if (!player.stillRetracing() && !enemy.stillRetracing())
			{
				moveToLevelCompletedScreen();
			}
		}
		
		private function createPlayerAtTile(pointer:Player, tile:Tile, isEnemy:Boolean) : Player
		{
			if (pointer == null)
			{
				pointer = new Player(this, tile.assetClip.x + tile.assetClip.width / 4, tile.assetClip.y + tile.assetClip.height / 4, tile.assetClip.width, tile.assetClip.height, isEnemy);
			}
			else
			{
				addChild(pointer.assetClip);
				
				if (debug)
					pointer.assetClip.visible = true;
				
				pointer.assetClip.x = tile.assetClip.x + tile.assetClip.width / 4;
				pointer.assetClip.y = tile.assetClip.y + tile.assetClip.height / 4;
				pointer.assetClip.width = tile.assetClip.width / 2;
				pointer.assetClip.height = tile.assetClip.height / 2;
			}
			
			addUpdatableObject(pointer);
			pointer.reposition(tile.row, tile.column, widthOfTileOnCurrentLevel(), heightOfTileOnCurrentLevel());
			
			levelStartTime = new Date().getTime();
			
			return pointer;
		}
		
		public function completePlayerTurn(isEnemy:Boolean)
		{
			currentPlayerIsEnemy = !isEnemy;

			if (isEnemy)
			{
				enemy.delayTurn();
				player.startTurn();
			}
			else
			{
				player.delayTurn();
				enemy.startTurn();
			}
		}
		
		public function addMovementToLog(direction:int, isEnemy:Boolean, successful:Boolean)
		{
			var arrow:ArrowRenderable;
			
			if (isEnemy)
			{
				shiftLog(enemyLog);
				enemyLog.push(arrow = new ArrowRenderable(this, successful, direction, isEnemy));
			}
			else
			{
				shiftLog(allyLog);
				allyLog.push(arrow = new ArrowRenderable(this, successful, direction, isEnemy));
			}
			
			addUpdatableObject(arrow);
		}
		
		private function shiftLog(log:Array)
		{
			for each (var move in log)
			{
				move.reposition(logHeight, logWidth);
			}
			
			if (log.length == logSize)
				removeUpdatableObject(log.shift());
		}
		
		private function createTile(type:int, row:int, column:int) : Tile
		{
			var tile:Tile;
			var tileWidth:Number = widthOfTileOnCurrentLevel();
			var tileHeight:Number = heightOfTileOnCurrentLevel();
			
			var x:Number = xPosition + tileWidth * column;
			var y:Number = yPosition + tileHeight * row;
			
			switch(type)
			{
				case 0 :
					tile = new BlankTile(this, x, y, tileWidth, tileHeight, row, column);
					break;
				case 1 :
					tile = new StartTile(this, x, y, tileWidth, tileHeight, row, column, false);
					startTiles.push(tile);
					break;
				case 2 :
					tile = new GoalTile(this, x, y, tileWidth, tileHeight, row, column);
					currentGoalTile = tile;
					break;
				case 3 :
					tile = new MountainTile(this, x, y, tileWidth, tileHeight, row, column, currentObstacles);
					break;
				case 4 :
					tile = new ForestTile(this, x, y, tileWidth, tileHeight, row, column, currentObstacles);
					break;
				case 5 :
					tile = new CheckpointTile(this, x, y, tileWidth, tileHeight, row, column);
					break;
				case 6 :
					tile = new StartTile(this, x, y, tileWidth, tileHeight, row, column, true);
					enemyStartTiles.push(tile);
					break;
				default :
					tile = new BlankTile(this, x, y, tileWidth, tileHeight, row, column);
					break;
			}
			
			return tile;
		}
		
		private function widthOfTileOnCurrentLevel() : Number
		{
			var columns:int = currentColumns();
			
			return mapWidth / columns;
		}
		
		private function heightOfTileOnCurrentLevel() : Number
		{
			var rows:int = currentRows();
			
			return mapHeight / rows;
		}
		
		public function currentColumns() : int
		{
			return currentLevel.level[0].length;
		}
		
		public function currentRows() : int
		{
			return currentLevel.level.length;
		}
		
		public function onSameTile() : Boolean
		{
			return player.currentColumn == enemy.currentColumn && player.currentRow == enemy.currentRow;
		}
		
		public function enterable(row:int, column:int, isEnemy:Boolean) : Boolean
		{
			if (isEnemy && currentGoalTile.row == row && currentGoalTile.column == column)
				return false;
			
			for each (var tile in currentObstacles)
			{
				if (tile.row == row && tile.column == column)
					return false;
			}
			
			return true;
		}
		
		public function atGoal(row:int, column:int) : Boolean
		{
			return row == currentGoalTile.row && column == currentGoalTile.column;
		}
		
		public function showNegativeGlowEffect() : void 
		{
			// TODO: change to the dimensions of the map only
			glowEffect.changeAssetColor(0xC12024);
			setChildIndex(glowEffect.assetClip, numChildren - 1);
			glowEffect.renderGlowEffect(509, 88, 950, 950);
		}
		
		public function showPositiveGlowEffect() : void
		{
			glowEffect.changeAssetColor(0x5FBA7D);
			setChildIndex(glowEffect.assetClip, numChildren - 1);
			glowEffect.renderGlowEffect(509, 88, 950, 950);
		}
	}
}