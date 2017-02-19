package
{	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public final class SoundManager
	{	
		private static var instance:SoundManager;
		
		private var musicChannel:SoundChannel;
		private var levelMusic:Sound;
		
		private var soundChannel:SoundChannel;
		
		private var testSound:Sound;
		private var allyWinSound:Sound;
		private var enemyWinSound:Sound;
		private var menuSound:Sound;
		private var buttonSound:Sound;
		
		private var allyRadio:Array = new Array();
		private var enemyRadio:Array = new Array();
		private var fatCommands:Array = new Array();
		private var tallCommands:Array = new Array();
		private var fatThoughts:Array = new Array();
		private var tallThoughts:Array = new Array();
		
		private var musicVolume:Number = 0.3;
		
		public function SoundManager()
		{		
			instance = this;
			soundChannel = new SoundChannel();
			musicChannel = new SoundChannel();
			
			testSound = new Sound(new URLRequest("assets/sounds/test.mp3"));
			allyWinSound = new Sound(new URLRequest("assets/sounds/allyWin.mp3"));
			enemyWinSound = new Sound(new URLRequest("assets/sounds/enemyWin.mp3"));
			menuSound = new Sound(new URLRequest("assets/sounds/startMusic.mp3"));
			buttonSound = new Sound(new URLRequest("assets/sounds/buttonSound.mp3"));
			
			allyRadio[0] = new Sound(new URLRequest("assets/sounds/Ally No 1.mp3"));
			allyRadio[1] = new Sound(new URLRequest("assets/sounds/Ally No 2.mp3"));
			
			enemyRadio[0] = new Sound(new URLRequest("assets/sounds/Ennemy No 1.mp3"));
			enemyRadio[1] = new Sound(new URLRequest("assets/sounds/Ennemy No 2.mp3"));
			
			fatCommands[0] = new Sound(new URLRequest("assets/sounds/Fat man commands 1.mp3"));
			fatCommands[1] = new Sound(new URLRequest("assets/sounds/Fat man commands 2.mp3"));
			fatCommands[2] = new Sound(new URLRequest("assets/sounds/Fat man commands 3.mp3"));
			
			tallCommands[0] = new Sound(new URLRequest("assets/sounds/Tall Command Yes 1.mp3"));
			tallCommands[1] = new Sound(new URLRequest("assets/sounds/Tall commands Yes 2.mp3"));
			tallCommands[2] = new Sound(new URLRequest("assets/sounds/Tall commands Yes 3.mp3"));
			
			fatThoughts[0] = new Sound(new URLRequest("assets/sounds/Fat man mmm 1.mp3"));
			fatThoughts[1] = new Sound(new URLRequest("assets/sounds/Fat man mmmm 2.mp3"));
			fatThoughts[2] = new Sound(new URLRequest("assets/sounds/Fat man mmmm 3.mp3"));
		
			tallThoughts[0] = new Sound(new URLRequest("assets/sounds/Tall man Mmm.mp3"));
			tallThoughts[1] = new Sound(new URLRequest("assets/sounds/Tall Man Mmm1.mp3"));
			tallThoughts[2] = new Sound(new URLRequest("assets/sounds/Tall man Mmm2.mp3"));
			
			levelMusic = new Sound(new URLRequest("assets/sounds/gameMusic.mp3"));
		}
		
		public static function getInstance() : SoundManager
		{
			if (!instance)
			{
				new SoundManager();
			}
			
			return instance;
		}
		
		private function playSound(sound:Sound, volume:Number = 1)
		{
			if (soundChannel != null)
			{
				soundChannel.stop();
				soundChannel = sound.play();
				soundChannel.soundTransform = new SoundTransform(volume);
			}
		}
		
		public function playTestSound()
		{
			playSound(testSound);
		}
		
		public function playAllyWinSound()
		{
			playSound(allyWinSound, 0.6);
		}
		
		public function playEnemyWinSound()
		{
			playSound(enemyWinSound, 0.6);
		}
		
		public function playMenuSound()
		{
			playSound(menuSound, 0.8);
		}
		
		public function playButtonClickedSound()
		{
			playSound(buttonSound);
		}
		
		public function playRadioSound(isEnemy:Boolean)
		{
			if (isEnemy)
				playSoundFromArray(enemyRadio);
			else
				playSoundFromArray(allyRadio);
		}
		
		public function playCommandSound(isEnemy:Boolean)
		{
			if (isEnemy)
				playSoundFromArray(fatCommands);
			else
				playSoundFromArray(tallCommands);
		}
		
		public function playThoughtSound(isEnemy:Boolean)
		{
			if (isEnemy)
				playSoundFromArray(fatThoughts);
			else
				playSoundFromArray(tallThoughts);
		}
		
		private function playSoundFromArray(array:Array)
		{
			var index:int = Math.random() * array.length;
			playSound(array[index]);
		}
		
		public function startLevelMusic()
		{
			if (musicChannel != null)
			{
				musicChannel.stop();
				musicChannel = levelMusic.play();
				musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusicChannel);
				musicChannel.soundTransform = new SoundTransform(musicVolume);
			}
		}
		
		public function stopLevelMusic()
		{
			musicChannel.stop();
		}
		
		private function loopMusicChannel(event:Event)
		{
			startLevelMusic();
		}
	}
}