package com.wasabi.addicube.data 
{
	import com.wasabi.addicube.objects.Cube;
	import com.wasabi.addicube.objects.FoodPoof;
	import com.wasabi.addicube.states.PlayingState;
	import com.wasabi.addicube.ui.Toolbar;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Tutorial extends FlxObject
	{
		
		private static const INDEX_TEXT : int = 0;
		private static const INDEX_BLOCKS_TOOLS : int = 1;
		private static const INDEX_BLOCKS_FOOD : int = 2;
		private static const INDEX_NEXT : int = 3;
		
		//	[ text, blocks tool use?, blocks eating?, next or null to stop ]
		private static const STEPS : Object =
		{
			"Start":		[ "", true, true, "1" ],
			"1": 			[ "This is your first cube! He's happy and calm right now because his diet is balanced.", true, true, "2" ], 
			"2": 			[ "This is algae. Your cubes will only eat food that’s right in front of them.", true, true, "3" ],
			"3": 			[ "This tool controls your view of the petri dish. Click it and see if you can find the blue algae. You can also use the arrow keys on the keyboard.", true, false, "4" ],
			"4": 			[ "Very good! Now see if you can find the green algae.", false, false, "5" ],
			"5":			[ "This tool summons cubes by sending out an electric field they find irresistible. Try summoning your cube to eat all the algae in the dish.", false, false, "6" ],
			"6":			[ "Oh look! It's eaten enough to grow into two cubes now. Go ahead and feed them, but remember that if you don’t keep their diet balanced, they'll turn into Addicubes!", false, false, null ],
			
			"NearDeath":  	[ "This cube is going to die if it doesn’t eat soon!", false, false, null ],
			
			"FirstRed":		[ "Oh no, you've created an Addicube! This cube is Angred. It is resistant to your control and will attack nearby cubes, causing them to stop eating.", false, false, null ],
			"FirstBlue":	[ "Oh no, you've created an Addicube! This cube is Blue. It is resistant to your control and will seek out more blue puffs to eat.", false, false, null ],
			"FirstGreen": 	[ "Oh no, you've created an Addicube! This cube is Grenvious. It is resistant to your control and will seek out nearby cubes, stealing the food right out of their mouths.", false, false, null ],
			
			"FirstGrowth":	[ "Your cube has grown a bit. Keep feeding it a balanced diet so that it'll grow and split into two cubes!", false, false, null ],
			
			"Pipette":		[ "You've earned a new tool! This pipette will allow you to pick up and move individual algae puffs anywhere you’d like. Unfortunately, it also randomly changes the color of the puff.", false, false, null ],

			"Chains":		[ "An algae chain has appeared in the dish. Once a cube starts eating, it won’t stop until the chain is gone.", false, false, null],
			
			"Tweezers":		[ "You’ve earned a new tool! The tweezers allows you to move chains safely out of the way of hungry cubes.", false, false, null ],
			
			"Scalpel":		[ "You’ve earned a new tool! The scalpel lets you slice chains into smaller pieces, even if a cube is already eating it.", false, false, null],
			
			"Dirty":		[ "The more cubes you have, the dirtier the dish will become. The dirtier the dish becomes, the faster your cubes will die.", false, false, null ],
			
			"GameOver":		[ "All of your cubes have died. Restart your colony?", true, true, null ]
		};
		
		public var currentStep : String;
		
		public var tutorialIsRunning : Boolean;
		
		private var hasSeenRedCube : Boolean;
		private var hasSeenGreenCube : Boolean;
		private var hasSeenBlueCube : Boolean;
		
		public function Tutorial() 
		{
			this.currentStep = null;
			this.tutorialIsRunning = false;
			
			this.hasSeenRedCube = false;
			this.hasSeenBlueCube = false;
			this.hasSeenGreenCube = false;
		}
		
		/**
		 * Updates the tutorial, displaying new steps when triggerred by events in the game world.
		 */
		override public function update():void 
		{
			super.update();
			
			if (this.currentStep == "2")
			{
				if (PlayingState.instance.foodPoofGroup.countLiving() == 0)
				{
					this.beginNextStep();
				}
			}
			else if (this.currentStep == "3")
			{
				if (FlxG.scroll.x == 0)
				{
					this.beginNextStep();
				}
			}
			else if (this.currentStep == "4")
			{
				if (FlxG.scroll.x == 0 - (PlayingState.instance.petriDish.right - FlxG.width))
				{
					this.beginNextStep();
				}
			}
			else if (this.currentStep == "5")
			{
				if (PlayingState.instance.liveCubeCount >= 2)
				{
					this.beginNextStep();
				}
			}
			else
			{
				this.updateAddicubeMessages();
			}
		}
		
		/**
		 * Checks to see if any new cube dispositions have appeared for the first time and displays the related
		 * tutorial messages.
		 */
		private function updateAddicubeMessages() : void
		{
			var counts : Array;
			
			//	Bail out -- we've already done these tutorial messages
			if (this.hasSeenBlueCube && this.hasSeenRedCube && this.hasSeenGreenCube) return;
			
			if (this.currentStep == null)
			{
				counts = PlayingState.instance.countCubeDispositions();
				
				if (!this.hasSeenRedCube && counts[Disposition.RED] > 0)
				{
					PlayingState.instance.attachTutorialArrow(PlayingState.instance.findFirstCubeWithDisposition(Disposition.RED));
					this.showTutorialStep("FirstRed");
					this.hasSeenRedCube = true;
				}
				else if (!this.hasSeenGreenCube && counts[Disposition.GREEN] > 0)
				{
					PlayingState.instance.attachTutorialArrow(PlayingState.instance.findFirstCubeWithDisposition(Disposition.GREEN));
					this.showTutorialStep("FirstGreen");
					this.hasSeenGreenCube = true;
				}
				else if (!this.hasSeenBlueCube && counts[Disposition.BLUE] > 0)
				{
					PlayingState.instance.attachTutorialArrow(PlayingState.instance.findFirstCubeWithDisposition(Disposition.BLUE));
					this.showTutorialStep("FirstBlue");
					this.hasSeenBlueCube = true;
				}
			}
		}
		
		/**
		 * Starts the tutorial display at the beginning of the basic walkthrough.
		 */
		public function startTutorial() : void
		{
			this.tutorialIsRunning = true;
			this.showTutorialStep("1");
			
			var cube : Cube = PlayingState.instance.getFirstCube();
			PlayingState.instance.attachTutorialArrow(cube);
		}
		
		/**
		 * Ends the tutorial display and hides all of the tutorial content.
		 */
		public function endTutorial() : void
		{
			this.currentStep = null;
			this.tutorialIsRunning = false;
			PlayingState.instance.hideTutorialArrow();
			PlayingState.instance.hideTutorialOverlay();
		}
		
		/**
		 * Displays a single step from the tutorial
		 * @param	step	The name of the step to display
		 */
		public function showTutorialStep(step : String, canSkip : Boolean = true) : void
		{
			this.currentStep = step;
			this.tutorialIsRunning = true;
			PlayingState.instance.setTutorialText(Tutorial.STEPS[this.currentStep][Tutorial.INDEX_TEXT], canSkip);
		}
		
		/**
		 * Shows the game over message
		 */
		public function showGameOver() : void
		{
			this.showTutorialStep("GameOver", false);
		}
		
		/**
		 * Handles the Okay! button on the tutorial pop-up
		 */
		public function tutorialOk() : void
		{
			if (!this.visible) return;
			
			if (this.currentStep == "GameOver")
			{
				FlxG.state = new PlayingState();
				return;
			}
			
			if (
				this.currentStep != "2" &&
				this.currentStep != "3" &&
				this.currentStep != "4" &&
				this.currentStep != "5"
			)
			{
				this.beginNextStep();
			}
		}
		
		/**
		 * Advances the tutorial to the next step, as specified by a the current tutorial step.
		 * If the current tutorial step has no next step, this will end the tutorial.
		 * For certain tutorial steps in the walkthrough this function will generate objects in the game world.
		 */
		private function beginNextStep() : void
		{
			if (Tutorial.STEPS[this.currentStep][Tutorial.INDEX_NEXT] == null)
			{
				this.endTutorial();
				return;
			}
			else
			{
				this.currentStep = Tutorial.STEPS[this.currentStep][Tutorial.INDEX_NEXT];
			}
			
			PlayingState.instance.setTutorialText(Tutorial.STEPS[this.currentStep][Tutorial.INDEX_TEXT]);
			
			var poof : FoodPoof;
			var cube : Cube;
			
			if (this.currentStep == "1")
			{
				cube = PlayingState.instance.getFirstCube();
				PlayingState.instance.attachTutorialArrow(cube);
			}
			if (this.currentStep == "2")
			{
				cube = PlayingState.instance.getFirstCube();
				poof = PlayingState.instance.getFoodPoof();
				
				poof.spawn(cube.center.x - poof.width / 2, cube.bodyCollider.bottom - poof.height, Disposition.RED);
				
				PlayingState.instance.attachTutorialArrow(poof);
			}
			else if (this.currentStep == "3")
			{
				cube = PlayingState.instance.getFirstCube();
				poof = PlayingState.instance.getFoodPoof();
				
				poof.spawn(90, cube.bodySprite.bottom - 10, Disposition.BLUE);
			
				PlayingState.instance.attachTutorialArrow(
					PlayingState.instance.toolbar.getButton(Toolbar.BUTTON_PAN),
					FlxSprite.UP
				);
			}
			else if (this.currentStep == "4")
			{
				cube = PlayingState.instance.getFirstCube();
				poof = PlayingState.instance.getFoodPoof();
				
				poof.spawn(PlayingState.instance.petriDish.right - 150, cube.bodySprite.bottom - 10, Disposition.GREEN);
			
				PlayingState.instance.attachTutorialArrow(
					PlayingState.instance.toolbar.getButton(Toolbar.BUTTON_PAN),
					FlxSprite.UP
				);
			}
			else if (this.currentStep == "5")
			{
				PlayingState.instance.attachTutorialArrow(
					PlayingState.instance.toolbar.getButton(Toolbar.BUTTON_PROBE),
					FlxSprite.UP
				);
			}
			else if (this.currentStep == "6")
			{
				PlayingState.instance.hideTutorialArrow();
			}
		}
		
		public function get currentStepBlocksTools() : Boolean
		{
			if (this.currentStep == null) return false;
			
			return Tutorial.STEPS[this.currentStep][Tutorial.INDEX_BLOCKS_TOOLS];
		}
		
		public function get currentStepBlocksEating() : Boolean
		{
			if (this.currentStep == null) return false;
			
			return Tutorial.STEPS[this.currentStep][Tutorial.INDEX_BLOCKS_FOOD];
		}
	}

}