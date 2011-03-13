package com.wasabi.addicube.states 
{
	import adobe.utils.CustomActions;
	import com.wasabi.addicube.data.CubeState;
	import com.wasabi.addicube.data.Disposition;
	import com.wasabi.addicube.data.Tool;
	import com.wasabi.addicube.data.Tutorial;
	import com.wasabi.addicube.Main;
	import com.wasabi.addicube.objects.Cube;
	import com.wasabi.addicube.objects.CubeBodyCollider;
	import com.wasabi.addicube.objects.FoodChain;
	import com.wasabi.addicube.objects.FoodPoof;
	import com.wasabi.addicube.objects.PetriDish;
	import com.wasabi.addicube.objects.PetriDishDirt;
	import com.wasabi.addicube.objects.PetriDishEdge;
	import com.wasabi.addicube.objects.PetriDishRim;
	import com.wasabi.addicube.ui.Toolbar;
	import com.wasabi.addicube.ui.TutorialArrow;
	import com.wasabi.shared.ui.TextFrame;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class PlayingState extends GameState
	{
		
		[Embed(source = '../../../../../assets/ui/textboxframe.scaled.png')]
		public static const GFX_FRAME : Class;
		
		[Embed(source = '../../../../../assets/ui/tutorialbox.scientist.small.png')]
		public static const GFX_SCIENTIST : Class;
		
		[Embed(source = '../../../../../assets/probe.effect.png')]
		private static const GFX_ELLIPSE : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorPipette.png')]
		public static const GFX_CURSOR_PIPETTE : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorPipetteBlue.png')]
		public static const GFX_CURSOR_PIPETTE_BLUE : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorPipetteGreen.png')]
		public static const GFX_CURSOR_PIPETTE_GREEN : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorPipetteRed.png')]
		public static const GFX_CURSOR_PIPETTE_RED : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorProbe.png')]
		public static const GFX_CURSOR_PROBE : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorScalpel.png')]
		public static const GFX_CURSOR_SCALPEL: Class;
		
		[Embed(source = '../../../../../assets/ui/cursorTweezers.png')]
		public static const GFX_CURSOR_TWEEZERS : Class;
		
		[Embed(source = '../../../../../assets/ui/cursorNavigation.png')]
		public static const GFX_CURSOR_PAN : Class;
		
		public static const ELLIPSE_NUDGE : Number = 1.15;
		
		public static const PROBE_FAST_SCALE : Number = 0.03; //3.0;
		public static const PROBE_SLOW_SCALE : Number = 0.01; //1.0;
		
		public static const TUTORIAL_BOX_PADDING : int = 6;
		
		public static const KEYBOARD_PANNING_SPEED : Number = 250;
		
		//	Instance access
		public static var instance : PlayingState;
		
		private var cube : Cube;
		
		private var cubes : FlxGroup;
		private var cubeSprites : FlxGroup;
		private var cubeBodyColliders : FlxGroup;
		private var cubeBaseColliders : FlxGroup;
		
		//	Food
		private var foodPoofs : FlxGroup;
		private var foodChains : FlxGroup;
		
		private var maximumFoodPoofs : int;
		
		//	Rendering layers
		private var backgroundLayer : FlxGroup;
		private var cubeLayer : FlxGroup;
		private var foregroundLayer : FlxGroup;
		private var uiLayer : FlxGroup;
		private var tutorialLayer : FlxGroup;
		
		//	UI
		public var toolbar : Toolbar;
		public var petriDish : PetriDish;
		public var petriDishDirt : PetriDishDirt;
		public var petriDishEdge : PetriDishEdge;
		public var petriDishRim : PetriDishRim;
		
		//	Active tool information
		private var activeTool : int;
		
		//	Probe support
		private var probeOrigin : FlxPoint;
		private var probeRadius : Number;
		private var probeSprite : FlxSprite;
		private var probeGrowthRate : Number
		
		private var probeEccentricity : Number;
		private var probeMajorAxis : Number;
		private var probeMinorAxis : Number;
		
		//	Panning support
		private var panOrigin : FlxPoint;
		private var panDelta : FlxPoint;
		private var cameraTarget : FlxSprite;
		
		//	Pippette support
		private var pipettePoof : FoodPoof;
		
		//	Tweezer support
		private var tweezerChain : FoodChain;
		private var tweezerChainOffset : FlxPoint;
		
		//	Tutorial support
		public var tutorial : Tutorial;
		
		private var tutorialTextFrame : TextFrame;
		private var tutorialArrow : TutorialArrow;
		private var scientist : FlxSprite;
		
		private var setupComplete : Boolean;
		
		//	Tracking
		private var mostCubesActive : int;
		private var liveCubes : int;
		
		private var foodNeeded : int;
		private var foodSpawned : int;
		private var foodClock : Number;
		
		private var foodStack : Array;
		
		public function PlayingState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			
			PlayingState.instance = this;
			this.setupComplete = false;
			
			FlxG.mouse.show();
			
			//	Setup rendering layers
			this.backgroundLayer = new FlxGroup();
			this.cubeLayer = new FlxGroup();
			this.foregroundLayer = new FlxGroup();
			this.uiLayer = new FlxGroup();
			
			//	Cube support
			this.cubeBaseColliders = new FlxGroup();
			this.cubeBodyColliders = new FlxGroup();
			
			this.cubes = new FlxGroup();
			
			//	Food support
			this.foodChains = new FlxGroup();
			this.foodPoofs = new FlxGroup();
			
			//this.cubeLayer.add(this.foodPoofs);
			
			//	Setup UI
			this.setupInterface();
			
			//	Assemble layers
			this.add(this.backgroundLayer);
			this.add(this.cubeLayer);
			this.add(this.foregroundLayer);
			this.add(this.uiLayer);
			
			//	Tracking
			this.mostCubesActive = 0;
			this.liveCubes = 0;
			
			this.foodStack = new Array();
			this.foodNeeded = this.foodSpawned = 0;
			this.foodSpawned = 0.0;
			this.foodClock = 0;
			
			this.setupTools();
			
			this.setupTutorial();
			
			this.setupCamera();
			
			this.setupInitialGameSpace();
		}
		
		private function setupTools() : void
		{
			var n : Number;
			
			//	Defaults
			this.setActiveTool(Tool.PROBE);
			
			//	Probe
			this.probeOrigin = new FlxPoint();
			this.probeRadius = 0.0;
			this.probeGrowthRate = 20.0;
			
			this.probeSprite = new FlxSprite(0, 0, PlayingState.GFX_ELLIPSE);
			this.probeSprite.visible = false;
			this.backgroundLayer.add(this.probeSprite);
			
			this.probeMajorAxis = this.probeSprite.width / 2;
			this.probeMinorAxis = this.probeSprite.height / 2;
			n = (this.probeMinorAxis / this.probeMajorAxis);
			this.probeEccentricity = Math.sqrt(1 - (n * n));
			
			//	Panning
			this.panOrigin = new FlxPoint();
			this.panDelta = new FlxPoint();
			
			//	Pippette
			this.pipettePoof = null;
			
			//	Tweezer
			this.tweezerChain = null;
			this.tweezerChainOffset = new FlxPoint();
			
			this.toolbar.disableButton(Toolbar.BUTTON_PIPETTE);
			this.toolbar.disableButton(Toolbar.BUTTON_SCALPEL);
			this.toolbar.disableButton(Toolbar.BUTTON_TWEEZERS);
		}
		
		private function setupCamera() : void
		{
			this.cameraTarget = new FlxSprite();
			this.cameraTarget.createGraphic(4, 4, 0x00FF0000);
			this.cameraTarget.visible = false;
			this.cameraTarget.moves = false;
			this.add(this.cameraTarget);
			
			FlxG.followBounds(0, 0, this.petriDish.width, this.petriDish.height, true);
		}
		
		private function setupInterface() : void
		{
			this.uiLayer.scrollFactor.x = this.uiLayer.scrollFactor.y = 0;
			
			this.toolbar = new Toolbar();
			this.uiLayer.add(this.toolbar, true);
			
			this.petriDish = new PetriDish();
			this.backgroundLayer.add(this.petriDish);
			
			this.petriDishEdge = new PetriDishEdge();
			this.foregroundLayer.add(this.petriDishEdge);
			
			this.petriDishRim = new PetriDishRim();
			this.petriDishRim.alpha = 0.75;
			this.foregroundLayer.add(this.petriDishRim);
			
			this.petriDishDirt = new PetriDishDirt();
			this.backgroundLayer.add(this.petriDishDirt);
		}
		
		private function setupTutorial() : void
		{
			this.tutorialLayer = new FlxGroup();
			
			this.tutorialTextFrame = new TextFrame(PlayingState.GFX_FRAME, "", 40);
			this.tutorialTextFrame.setSizeAndText(
				FlxG.width * 0.80, 
				""
			);
			
			this.tutorialTextFrame.y =
				FlxG.height - this.tutorialTextFrame.height -
				PlayingState.TUTORIAL_BOX_PADDING
			;
			this.tutorialTextFrame.x =
				FlxG.width - this.tutorialTextFrame.width -
				PlayingState.TUTORIAL_BOX_PADDING
			;
			
			this.tutorialTextFrame.scrollFactor =
				this.tutorialTextFrame.textDisplay.scrollFactor =
				new FlxPoint()
			;
			
			this.tutorialTextFrame.setScrollFactor(new FlxSprite());
			this.tutorialTextFrame.okCallback = this.tutorialOk;
			this.tutorialTextFrame.skipCallback = this.tutorialSkip;
			
			this.tutorialLayer.add(this.tutorialTextFrame);
			
			this.tutorialArrow = new TutorialArrow();
			this.tutorialLayer.add(this.tutorialArrow);
			
			//this.tutorialArrow.attachToObject(this.cubes.members[0]);
			this.tutorialArrow.attachToObject(this.toolbar.getButton(Toolbar.BUTTON_PIPETTE));
			
			this.scientist = new FlxSprite(0, 0, PlayingState.GFX_SCIENTIST);
			this.scientist.scrollFactor.x = this.scientist.scrollFactor.y = 0;
			this.scientist.x = FlxG.width - this.scientist.width - 10;
			this.scientist.y = FlxG.height - this.scientist.height - 10;
			this.tutorialLayer.add(this.scientist);
			
			//this.tutorialTextFrame.x = this.scientist.left - this.tutorialTextFrame.width + 10;
			//this.tutorialTextFrame.x = this.scientist.right - this.tutorialTextFrame.width + 10;
			
			this.tutorialArrow.visible = true;
			this.scientist.visible = this.tutorialTextFrame.visible = false;
			
			this.uiLayer.add(this.tutorialLayer);
			
			this.tutorial = new Tutorial();
			this.add(this.tutorial);
		}
		
		//-----------------------------------------------------------------------------------------
		//	Object creation / destruction
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Adds a new cube to the world; also sets up the base and body colliders for the cube
		 * @param	cube	The cube to add
		 */
		public function addCube(cube : Cube) : void
		{
			this.add(cube);
			this.cubes.add(cube);
			this.cubeLayer.add(cube.spriteGroup);
			this.cubeBaseColliders.add(cube.baseCollider);
			this.cubeBodyColliders.add(cube.bodyCollider);
			
			this.liveCubes++;
			this.foodNeeded += Cube.FOOD_TO_SPLIT;
			
			this.buildFoodStack();
		}
		
		private function buildFoodStack() : void
		{
			var groupData : Object;
			var remaining : int;
			var groupSize : int;
			var colorCount : Array;
			var color : int;
			var colorRemaining : int;
			var which : Number;
			var oneThird : int;
			
			remaining = this.foodNeeded - this.foodPoofs.countLiving();
			
			//	Account for the initial cube not starting at a small size
			remaining -= (Cube.FOOD_TO_SPLIT - 3);
			
			oneThird = FlxU.ceil(remaining / 3);
			colorCount = new Array();
			
			if (remaining < 3) return;
			
			colorCount[Disposition.RED] = 0;
			colorCount[Disposition.GREEN] = 0;
			colorCount[Disposition.BLUE] = 0;
			
			FlxG.log("remaining: " + remaining + " / ot: " +oneThird);
			//return;
			
			do
			{
				which = FlxU.random();
				
				if (which < 0.33 && colorCount[Disposition.RED] < oneThird)
				{
					color = Disposition.RED;
				}
				else if (which < 0.66 && colorCount[Disposition.BLUE] < oneThird)
				{
					color = Disposition.BLUE;
				}
				else if (which < 1.00 && colorCount[Disposition.GREEN] < oneThird)
				{
					color = Disposition.GREEN;
				}
				
				which = FlxU.random() < 0.5 ? 3 : 6;
				colorRemaining = oneThird - colorCount[color];
				
				which = Math.min(which, colorRemaining);
				
				colorCount[color] += which;
				
				groupData = new Object();
				groupData["color"] = color;
				groupData["count"] = which;
				this.foodStack.push(groupData);
				
				//FlxG.log("cr: " + colorRemaining + " / " + which + " " + color);
				
				remaining -= which;
				//FlxG.log("r: " + remaining);
				//return;
			} while (remaining >= 3);
		}
		
		public function removeCube(cube : Cube) : void
		{
			this.cubes.remove(cube, true);
			this.cubeLayer.remove(cube.spriteGroup, true);
			this.cubeBodyColliders.remove(cube.bodyCollider, true);
			
			this.liveCubes--;
		}
		
		public function getFoodPoof() : FoodPoof
		{
			var poof : FoodPoof;
			
			poof = this.foodPoofs.getFirstAvail() as FoodPoof;
			
			if (poof == null)
			{
				poof = new FoodPoof();
				this.foodPoofs.add(poof);
				this.cubeLayer.add(poof);
			}
			
			this.foodSpawned++;
			
			return poof;
		}
		
		public function getFirstCube() : Cube
		{
			return this.cubes.members[0];
		}
		
		//-----------------------------------------------------------------------------------------
		//	Tool / mode handling functions
		//-----------------------------------------------------------------------------------------
		
		public function setActiveTool(tool : int) : void
		{
			this.activeTool = tool;
			this.toolbar.setActiveButton(tool);
			
			if (this.activeTool == Toolbar.BUTTON_PAN) FlxG.mouse.show(PlayingState.GFX_CURSOR_PAN, 16, 16);
			else if (this.activeTool == Toolbar.BUTTON_PROBE) FlxG.mouse.show(PlayingState.GFX_CURSOR_PROBE, 6, 27);
			else if (this.activeTool == Toolbar.BUTTON_PIPETTE)
			{
				if (this.pipettePoof == null) FlxG.mouse.show(PlayingState.GFX_CURSOR_PIPETTE, 6, 27);
				else if (this.pipettePoof.colorId == Disposition.RED) FlxG.mouse.show(GFX_CURSOR_PIPETTE_RED, 6, 27);
				else if (this.pipettePoof.colorId == Disposition.GREEN) FlxG.mouse.show(GFX_CURSOR_PIPETTE_GREEN, 6, 27);
				else if (this.pipettePoof.colorId == Disposition.BLUE) FlxG.mouse.show(GFX_CURSOR_PIPETTE_BLUE, 6, 27);
				
			}
			else if (this.activeTool == Toolbar.BUTTON_SCALPEL) FlxG.mouse.show(PlayingState.GFX_CURSOR_SCALPEL, 8, 27);
			else if (this.activeTool == Toolbar.BUTTON_TWEEZERS) FlxG.mouse.show(PlayingState.GFX_CURSOR_TWEEZERS, 7, 23);
			else FlxG.mouse.show();
		}
		
		//-----------------------------------------------------------------------------------------
		//	Update support functions
		//-----------------------------------------------------------------------------------------
		
		private function handleCubeOverlap(a : FlxObject, b : FlxObject) : void
		{
			var bca : CubeBodyCollider = a as CubeBodyCollider;
			var bcb : CubeBodyCollider = b as CubeBodyCollider;
			var bct : CubeBodyCollider;
			
			//	Make sure BCA and CA refer to the cube on the left -- to simplify
			//	separation along the x-axis later
			if (bcb.left < bca.left)
			{
				bct = bca;
				bca = bcb;
				bcb = bct;
			}
			
			var ca : Cube = bca.cube;
			var cb : Cube = bcb.cube;
			
			var centerPoint : Number;
			var pa : Number;
			var pb : Number;
			
			if (ca != null && cb != null)
			{
				if (ca.followerCube != cb && ca.currentState == CubeState.MOVING)
				{
					if (
						ca.targetPoint.x > bca.left ||
						(
							(bca.y > bcb.y && ca.targetPoint.y < bca.top) ||
							(bca.y < bcb.y && ca.targetPoint.y > bca.bottom)
						)
					)
					{
						ca.currentState = CubeState.IDLE;
						ca.switchAnimation("Idle");
					}
				}
				if (cb.followerCube != ca && cb.currentState == CubeState.MOVING)
				{
					if (
						cb.targetPoint.x < bcb.left ||
						(
							(bcb.y > bca.y && cb.targetPoint.y < bcb.top) ||
							(bcb.y < bca.y && cb.targetPoint.y > bcb.bottom)
						)
					)
					{
						cb.currentState = CubeState.IDLE;
						cb.switchAnimation("Idle");
					}
				}
			}
		}
		
		override public function update():void 
		{
			var i : int;
			var j : int;
			
			//FlxU.collide(this.cubeBodyColliders, this.cubeBodyColliders);
			super.update();
			
			//	Update most cubes active
			if (this.liveCubeCount > this.mostCubesActive)
			{
				this.mostCubesActive = this.liveCubeCount;
			}
			
			//	Check for pipette tool (unlocked at 3 cubes)
			if (this.mostCubesActive >= 3)
			{
				if (this.toolbar.isButtonEnabled(Toolbar.BUTTON_PIPETTE) == false)
				{
					this.tutorial.showTutorialStep("Pipette", false);
				}
				
				this.toolbar.enableButton(Toolbar.BUTTON_PIPETTE);
			}
			
			//	Chains at 5
			
			if (this.mostCubesActive >= 7)
			{
				this.toolbar.enableButton(Toolbar.BUTTON_TWEEZERS);
			}
			
			if (this.mostCubesActive >= 9)
			{
				this.toolbar.enableButton(Toolbar.BUTTON_SCALPEL);
			}
			
			//	Adjust dish background based on available tools
			if (this.toolbar.isButtonEnabled(Toolbar.BUTTON_PIPETTE))
			{
				this.petriDishEdge.setGraphic(3);
			}
			else if (this.toolbar.isButtonEnabled(Toolbar.BUTTON_PROBE))
			{
				this.petriDishEdge.setGraphic(2);
			}
			else
			{
				this.petriDishEdge.setGraphic(1);
			}
			
			//	Sort the cubes and poofs
			this.cubeLayer.members.sortOn("depth", Array.NUMERIC);
			
			FlxU.overlap(this.cubeBodyColliders, this.cubeBodyColliders, this.handleCubeOverlap );
			
			//	Determine the maximum desired food poofs
			if (!this.tutorial.tutorialIsRunning)
			{
				this.foodClock -= FlxG.elapsed;
				
				if(this.foodStack.length && this.foodClock <= 0)
				{
					
					if (this.mostCubesActive >= 5 && FlxU.random() <= 0.33)
					{
						this.spawnFoodChain();
					}
					else
					{
						this.spawnFoodPoof();
					}
					
					this.foodClock = FlxU.random() * 2.0 + 0.5;
				}
			}
			
			if (Main.DEBUG) this.updateDebug();
			
			//	Keyboard updates
			if (FlxG.keys.justPressed("ONE") && this.toolbar.isButtonEnabled(0)) this.setActiveTool(0);
			if (FlxG.keys.justPressed("TWO") && this.toolbar.isButtonEnabled(1)) this.setActiveTool(1);
			if (FlxG.keys.justPressed("THREE") && this.toolbar.isButtonEnabled(2)) this.setActiveTool(2);
			if (FlxG.keys.justPressed("FOUR") && this.toolbar.isButtonEnabled(3)) this.setActiveTool(3);
			if (FlxG.keys.justPressed("FIVE") && this.toolbar.isButtonEnabled(4)) this.setActiveTool(4);
			
			if (this.activeTool == Tool.PROBE)
			{
				this.updateProbeTool();
			}
			else if (this.activeTool == Tool.PAN)
			{
				this.updatePanTool();
			}
			else if (this.activeTool == Tool.PIPETTE)
			{
				this.updatePipetteTool();
			}
			else if (this.activeTool == Tool.TWEEZERS)
			{
				this.updateTweezerTool();
			}
			else if (this.activeTool == Tool.SCALPEL)
			{
				this.updateScalpelTool();
			}
			
			//	End the game if all the cubes have died
			if 
			(
				this.setupComplete &&
				(
					this.liveCubeCount <= 0 ||
					(Main.DEBUG && FlxG.keys.justPressed("X"))
				)
			)
			{
				if (this.tutorial.currentStep != "GameOver")
				{
					this.removeAllCubes();
					this.tutorial.showGameOver();
				}
			}
			
			if (FlxG.keys.justPressed("C") && Main.DEBUG)
			{
				this.spawnFoodChain();
			}
			
			this.updateKeyboardPanning();
			this.clampPanning();
		}
		
		/**
		 * Handles updates that support debugging
		 */
		private function updateDebug() : void
		{
			//	Drops random food poofs at the mouse cursor
			if (FlxG.keys.justPressed("F"))
			{
				var poof : FoodPoof;
				
				poof = this.getFoodPoof();
				
				poof.spawn(FlxG.mouse.x, FlxG.mouse.y);
			}
			
			if (FlxG.keys.justPressed("M"))
			{
				var cube : Cube;
				
				cube = this.cubes.members[0];
				cube.moveTo(FlxG.mouse.x, FlxG.mouse.y);
			}
		}
		
		/**
		 * Handles regular updates for the probe tool
		 */
		private function updateProbeTool() : void
		{
			if (this.tutorial.tutorialIsRunning && (this.mouseIsOverTutorial || this.tutorial.currentStepBlocksTools)) return;
				
			if (FlxG.mouse.justPressed())
			{
				this.probeOrigin.x = FlxG.mouse.x;
				this.probeOrigin.y = FlxG.mouse.y;
			}
			
			if (FlxG.mouse.pressed())
			{
				this.probeRadius +=
					this.probeGrowthRate * FlxG.elapsed *
					(
						FlxG.keys.SHIFT ?
						PlayingState.PROBE_FAST_SCALE :
						PlayingState.PROBE_SLOW_SCALE
					)
				;
				
				this.probeSprite.visible = true;
				this.probeSprite.scale.x = this.probeSprite.scale.y = this.probeRadius * 2;
				
				this.probeSprite.reset(
					this.probeOrigin.x - this.probeSprite.width / 2,
					this.probeOrigin.y - this.probeSprite.height / 2
				);
				
				var cube : Cube;
				var i : int;
				
				for (i = 0; i < this.cubes.members.length; i++)
				{
					cube = this.cubes.members[i] as Cube;
					
					if (cube != null)
					{
						if (cube.exists && cube.active && !cube.dead && !cube.eating)
						{
							if (this.isPointInsideProbeEllipse(cube.center))
							{
								cube.lookAt(this.probeOrigin);
							}
							else
							{
								cube.lookAt(null);
							}
						}
					}
				}
			
			}
			else if (FlxG.mouse.justReleased())
			{
				this.endProbeTool();
			}
		}
		
		private function updateScalpelTool() : void
		{
			var poof : FoodPoof;
			
			if (this.mouseIsOverTutorial) return;
			
			if (FlxG.mouse.justPressed())
			{
				poof = this.findFoodPoofAt(FlxG.mouse.x, FlxG.mouse.y);
				if (poof != null) FlxG.log("Poof under scalpel...");
				
				if (poof != null && poof.ownerChain != null)
				{
					FlxG.log("Splitting chain...");
					poof.ownerChain.splitAt(poof);
				}
			}
		}
		
		private function updateTweezerTool() : void
		{
			var poof : FoodPoof;
			
			if (this.mouseIsOverTutorial) return;
			
			if (FlxG.mouse.justPressed())
			{
				poof = this.findFoodPoofAt(FlxG.mouse.x, FlxG.mouse.y);
				
				if (poof != null)
				{
					FlxG.log("Poof: " + poof);
					
					if (poof.ownerChain != null)
					{
						this.tweezerChain = poof.ownerChain;
						this.tweezerChainOffset = new FlxPoint(
							this.tweezerChain.x - FlxG.mouse.x,
							this.tweezerChain.y - FlxG.mouse.y
						);
					}
				}
			}
			
			if (FlxG.mouse.justReleased())
			{
				this.tweezerChain = null;
			}
			
			if (this.tweezerChain != null)
			{
				this.tweezerChain.reset(
					FlxG.mouse.x + this.tweezerChainOffset.x,
					FlxG.mouse.y + this.tweezerChainOffset.y
				);
			}
		}
		
		/**
		 * Handles regular updates for the pan tool
		 */
		private function updatePanTool() : void
		{
			if (this.mouseIsOverTutorial) return;
			
			if (FlxG.mouse.justPressed())
			{
				this.panOrigin.x = FlxG.mouse.screenX;
				this.panOrigin.y = FlxG.mouse.screenY;
			}
			
			if (FlxG.mouse.pressed())
			{
				this.panDelta.x = FlxG.mouse.screenX - this.panOrigin.x;
				this.panDelta.y = FlxG.mouse.screenY - this.panOrigin.y;
				
				//this.cameraTarget.x -= this.panDelta.x;
				//this.cameraTarget.y -= this.panDelta.y;
				
				FlxG.scroll.x += this.panDelta.x;
				FlxG.scroll.y += this.panDelta.y;
				
				this.panOrigin.x = FlxG.mouse.screenX;
				this.panOrigin.y = FlxG.mouse.screenY;
			}
		}
		
		private function updateKeyboardPanning() : void
		{
			if (FlxG.keys.pressed("LEFT") || FlxG.keys.pressed("A"))
			{
				FlxG.scroll.x += PlayingState.KEYBOARD_PANNING_SPEED * FlxG.elapsed;
			}
			else if (FlxG.keys.pressed("RIGHT") || FlxG.keys.pressed("D"))
			{
				FlxG.scroll.x -= PlayingState.KEYBOARD_PANNING_SPEED * FlxG.elapsed;
			}
			
			if (FlxG.keys.pressed("UP") || FlxG.keys.pressed("W"))
			{
				FlxG.scroll.y += PlayingState.KEYBOARD_PANNING_SPEED * FlxG.elapsed;
			}
			else if (FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("S"))
			{
				FlxG.scroll.y -= PlayingState.KEYBOARD_PANNING_SPEED * FlxG.elapsed;
			}
		}
		
		private function clampPanning() : void
		{
			if (FlxG.scroll.x < -this.petriDish.right + FlxG.width) FlxG.scroll.x = -this.petriDish.right + FlxG.width;
			else if (FlxG.scroll.x > 0) FlxG.scroll.x = 0;
			
			if (FlxG.scroll.y < -this.petriDish.bottom + FlxG.height) FlxG.scroll.y = -this.petriDish.bottom + FlxG.height;
			else if (FlxG.scroll.y > 0) FlxG.scroll.y = 0;
		}
	
		private function updatePipetteTool() : void
		{
			var poof : FoodPoof;
			
			if (this.mouseIsOverTutorial) return;
			
			if (FlxG.mouse.justPressed())
			{
				if (this.pipettePoof == null)
				{
					//	Collect a poof
					poof = this.findFoodPoofAt(FlxG.mouse.x, FlxG.mouse.y);
					
					if (poof != null && poof.ownerChain == null)
					{
						poof.randomizeColor();
						this.pipettePoof = poof;
						poof.active = poof.visible = false;
						
						if (poof.colorId == Disposition.RED) FlxG.mouse.show(GFX_CURSOR_PIPETTE_RED, 6, 27);
						else if (poof.colorId == Disposition.GREEN) FlxG.mouse.show(GFX_CURSOR_PIPETTE_GREEN, 6, 27);
						else if (poof.colorId == Disposition.BLUE) FlxG.mouse.show(GFX_CURSOR_PIPETTE_BLUE, 6, 27);
					}
				}
				else
				{
					//	Drop a poof
					this.pipettePoof.reset(
						FlxG.mouse.x - this.pipettePoof.width / 2,
						FlxG.mouse.y - this.pipettePoof.height / 2
					);
					
					this.pipettePoof.active = this.pipettePoof.visible = true;
					
					this.pipettePoof = null;
					
					FlxG.mouse.show(GFX_CURSOR_PIPETTE, 6, 27);
				}
			}
		}
		
		private function endProbeTool() : void
		{
			var cube : Cube;
			var i : int;
			
			for (i = 0; i < this.cubes.members.length; i++)
			{
				cube = this.cubes.members[i] as Cube;
				
				if (cube != null)
				{
					if (cube.exists && cube.active && !cube.dead && !cube.eating)
					{
						if (this.isPointInsideProbeEllipse(cube.center))
						{
							cube.moveTo(this.probeOrigin.x, this.probeOrigin.y);
						}
						else
						{
							cube.lookAt(null);
						}
					}
				}
			}
			
			this.probeSprite.visible = false;
			this.probeRadius = 0;
		}
		
		public function isPointInsideProbeEllipse(p : FlxPoint) : Boolean
		{
			var fa : FlxPoint;
			var fb : FlxPoint;
			var d : Number;
			var dist : FlxPoint;
			
			d = this.probeEccentricity * this.probeMajorAxis;
			d *= this.probeSprite.scale.x;
			
			fa = new FlxPoint(this.probeOrigin.x - d, this.probeOrigin.y);
			fb = new FlxPoint(this.probeOrigin.x + d, this.probeOrigin.y);
			
			d = distance(p, fa) + distance(p, fb);
			
			return (d <= this.probeMajorAxis * this.probeSprite.scale.x * 2 * PlayingState.ELLIPSE_NUDGE);
		}
		
		private function findFoodPoofAt(x : int, y : int) : FoodPoof
		{
			var i : int;
			var poof : FoodPoof;
			var maxY : Number = -Number.MAX_VALUE;
			var maxPoof : FoodPoof = null;
			
			for (i = 0; i < this.foodPoofs.members.length; i++)
			{
				poof = this.foodPoofs.members[i];
				
				if (poof.overlapsPoint(x, y))
				{
					if (poof.y > maxY)
					{
						maxY = poof.y;
						maxPoof = poof;
					}
				}
			}
			
			return maxPoof;
		}
		
		public function spawnFoodPoof() : void
		{
			var x : int;
			var y : int;
			var poof : FoodPoof;
			var p : FlxPoint;
			var pb : FlxPoint;
			
			var poofCount : int;
			var color : int;
			
			var a : Number;
			
			if (this.foodStack.length > 0)
			{
				var foodData : Object;
				
				foodData = this.foodStack.shift();
				
				poofCount = foodData["count"];
				color = foodData["color"];
			}
			else
			{
				return;
			}
			
			//poofCount = FlxU.random() * 3 + 3;
			
			//color = FlxU.random() * 3 + 1;
			
			//x = FlxU.random() * this.petriDish.width;
			//y = FlxU.random() * this.petriDish.height;
			
			p = this.getRandomPointInsideDish();
			pb = new FlxPoint(p.x, p.y);
			
			do {
				poof = this.getFoodPoof();
				poof.spawn(pb.x, pb.y, color);
				
				do
				{
					a = FlxU.random() * Math.PI * 2;
					
					pb.x = p.x + poof.width * 1.0 * Math.cos(a);
					pb.y = p.y + poof.height * 1.0 * Math.sin(a);
				} while (
					!this.isPointInsideDish(pb.x, pb.y) ||
					this.pointOverlapsFood(pb)
				);
			} while (poofCount-- > 0);
		}
		
		public function spawnFoodChain() : void 
		{
			var x : int;
			var y : int;
			var i : int;
			var chain : FoodChain;
			var length : int;
			var foodData : Object;
			var poofCount : int;
			var color : int;
			var p : FlxPoint;
			
			p = this.getRandomPointInsideDish();
			
			chain = new FoodChain();
			chain.spawn(p.x, p.y);
			this.add(chain);
			
			length = FlxU.floor(3 + FlxU.random() * 3);
			FlxG.log("Chain: " + length);
			
			do
			{
				foodData = this.foodStack.shift();
				
				poofCount = foodData["count"];
				color = foodData["color"];
				
				FlxG.log("\t" + poofCount + " / clr: " + color);
				
				do
				{
					chain.addPoof(color);
					FlxG.log("\t\tAdded poof: " + chain.length());
				} while (poofCount-- > 0 && chain.poofCount < length);
			} while (chain.poofCount < length);
			
			if (poofCount > 0)
			{
				foodData = new Object();
				foodData["color"] = color;
				foodData["poofCount"] = poofCount;
				this.foodStack.unshift(foodData);
			}
		}
		
		public function getEmptyFoodChain() : FoodChain
		{
			var chain : FoodChain;
			
			chain = new FoodChain();
			
			return chain;
		}
		
		public function addFoodChain(chain : FoodChain) : void
		{
			this.add(chain);
		}
		
		public function getClosestCube(p : FlxPoint, skip : Cube, skipStunned : Boolean) : Cube
		{
			var i : int;
			var d : Number;
			var minD : Number = Number.MAX_VALUE;
			var minCube : Cube = null;
			
			for (i = 0; i < this.cubes.members.length; i++)
			{
				if (this.cubes.members[i] == skip || (this.cubes.members[i].currentState == CubeState.IDLE_STUNNED && skipStunned))
				{
					continue;
				}
				
				d = this.distance(
					p,
					this.cubes.members[i].center
				);
				
				if (d < minD)
				{
					minD = d;
					minCube = this.cubes.members[i];
				}
			}
			
			return minCube;
		}
		
		public function getClosestFoodPoof(p : FlxPoint, maxDistance : Number = Number.MAX_VALUE, colorId : int = -1, mustBeAvailable : Boolean = true) : FoodPoof
		{
			var i :int;
			var d : Number;
			var minD : Number = Number.MAX_VALUE;
			var poof : FoodPoof;
			var minPoof : FoodPoof = null;
			
			for (i = 0; i < this.foodPoofs.members.length; i++)
			{
				poof = this.foodPoofs.members[i] as FoodPoof;
				
				if (
					poof == null ||
					(colorId >= 0 && poof.colorId != colorId) ||
					!poof.exists ||
					(mustBeAvailable && poof.ownerCube != null)
				)
				{
					continue;
				}
				
				d = this.distance(p, poof);
				
				if (d < minD && d < maxDistance)
				{
					minD = d;
					minPoof = poof;
				}
			}
			
			return minPoof;
		}
		
		private function distance(a : FlxPoint, b : FlxPoint) : Number
		{
			return Math.sqrt(
				(a.x - b.x) * (a.x - b.x) +
				(a.y - b.y) * (a.y - b.y)
			);
		}
		
		public function tutorialOk() : void
		{
			if (this.tutorialTextFrame.visible)
			{
				this.tutorialTextFrame.visible = false;
				this.scientist.visible = false;
				this.tutorial.tutorialOk();
			}
		}
		
		public function tutorialSkip() : void
		{
			if (this.tutorialTextFrame.visible)
			{
				this.tutorialTextFrame.visible = false;
				this.tutorialLayer.visible = false;
				this.tutorial.endTutorial();
			}
		}
		
		public function hideTutorialOverlay() : void
		{
			this.tutorialTextFrame.visible = false;
			this.tutorialLayer.visible = false;
		}
		
		public function setTutorialText(t : String, canSkip : Boolean = true) : void
		{
			this.tutorialTextFrame.setSizeAndText(this.tutorialTextFrame.width, t);
			this.tutorialTextFrame.reset(
				//this.scientist.left - this.tutorialTextFrame.width,
				FlxG.width - this.tutorialTextFrame.width - this.scientist.width / 2,
				FlxG.height - this.tutorialTextFrame.height - PlayingState.TUTORIAL_BOX_PADDING
			);
			
			this.scientist.y = this.tutorialTextFrame.bottom - this.scientist.height - 37;
			
			this.tutorialTextFrame.setSkipButtonVisible(canSkip);
			
			this.tutorialTextFrame.visible = true;
			this.scientist.visible = true;
			this.tutorialLayer.visible = true;
		}
		
		public function attachTutorialArrow(target : FlxObject, direction : int = FlxSprite.DOWN) : void
		{
			this.tutorialArrow.visible = true;
			this.tutorialArrow.setDirection(direction);
			this.tutorialArrow.attachToObject(target);
		}
		
		public function hideTutorialArrow() : void
		{
			this.tutorialArrow.visible = false;
		}
		
		public function get mouseIsOverTutorial() : Boolean
		{
			return false;
			
			/*
			return (
				this.tutorial.tutorialIsRunning &&
				this.tutorialLayer.visible &&
				this.tutorialTextFrame.visible &&
				this.tutorialTextFrame.overlapsPointScreenspace(FlxG.mouse.screenX, FlxG.mouse.screenX)
			);
			*/
		}
		
		public function get tutorialTextIsVisible() : Boolean
		{
			return (this.tutorialLayer.visible && this.tutorialTextFrame.visible);
		}
		
		public function get foodPoofGroup() : FlxGroup
		{
			return this.foodPoofs;
		}
		
		public function setupInitialGameSpace() : void
		{
			/*
			this.cube = new Cube();
			this.cube.setDisposition(Disposition.GREEN);
			this.cube.setSize(Cube.SIZE_LARGE);
			this.addCube(this.cube);
			this.cube.reset(this.petriDish.width / 2 - this.cube.bodySprite.width / 2, this.petriDish.height / 2 - this.cube.bodySprite.height - 75);
			
			this.cube = new Cube();
			this.cube.setDisposition(Disposition.BALANCED);
			this.cube.setSize(Cube.SIZE_LARGE);
			this.addCube(this.cube);
			this.cube.reset(this.petriDish.width / 2 - this.cube.bodySprite.width / 2 - 150, this.petriDish.height / 2 - this.cube.bodySprite.height - 75);
			
			this.cube = new Cube();
			this.cube.setDisposition(Disposition.BALANCED);
			this.cube.setSize(Cube.SIZE_LARGE);
			this.addCube(this.cube);
			this.cube.reset(this.petriDish.width / 2 - this.cube.bodySprite.width / 2 + 150, this.petriDish.height / 2 - this.cube.bodySprite.height - 75);
			
			FlxG.scroll.x = -this.petriDish.width / 2 + FlxG.width / 2;
			
			this.tutorial.endTutorial();
			*/
			
			this.cube = new Cube();
			
			this.cube.setDisposition(Disposition.BALANCED);
			
			this.cube.setSize(Cube.SIZE_LARGE);
			
			this.cube.addConsumedFood(Disposition.RED, 5);
			this.cube.addConsumedFood(Disposition.GREEN, 5);
			this.cube.addConsumedFood(Disposition.BLUE, 5);
			
			this.addCube(this.cube);
			this.cube.reset(this.petriDish.width / 2 - this.cube.bodySprite.width / 2, this.petriDish.height / 2 - this.cube.bodySprite.height - 75);
			
			FlxG.scroll.x = -this.petriDish.width / 2 + FlxG.width / 2;
			
			this.tutorial.startTutorial();
			
			this.setupComplete = true;
		}
		
		public function get liveCubeCount() : int
		{
			return this.liveCubes;
		}
		
		public function get maxLiveCubeCount() : int
		{
			return this.mostCubesActive;
		}
		
		private static const PETRI_DISH_RADIUS : Number = 920 / 2;
		private static const PETRI_DISH_MINOR_SCALE : Number = 0.525;
		
		public function pointOverlapsFood(p : FlxPoint) : Boolean
		{
			var i : int;
			var l : int;
			var poof : FoodPoof;
			
			l = this.foodPoofs.members.length;
			
			for (i = 0; i < l; i++)
			{
				poof = this.foodPoofs.members[i] as FoodPoof;
				
				if (poof != null && poof.exists)
				{
					if (poof.overlapsPoint(p.x, p.y)) return true;
				}
			}
			
			return false;
		}
		
		public function isPointInsideDish(x : Number, y : Number) : Boolean
		{
			var p : FlxPoint = new FlxPoint();
			
			var a : Number;
			var b : Number;
			
			var a2 : Number
			var b2 : Number;
			
			var h : Number;
			var k : Number;
			
			var d : Number;
			
			h = this.petriDish.center.x;
			k = this.petriDish.center.y;
			a = PlayingState.PETRI_DISH_RADIUS;
			b = PlayingState.PETRI_DISH_RADIUS * PlayingState.PETRI_DISH_MINOR_SCALE;
			
			a2 = (a * a);
			b2 = (b * b);
			
			x -= h;
			y -= k;
			
			d = (x * x) / a2 + (y * y) / b2;
			
			return (d <= 1.0);
		}
		
		public function getRandomPointInsideDish() : FlxPoint
		{
			var p : FlxPoint = new FlxPoint();
			
			var a : Number;
			var d : Number;
			
			d = Math.sqrt(FlxU.random()) * PlayingState.PETRI_DISH_RADIUS;
			a = FlxU.random() * Math.PI * 2;
			
			p.x = (Math.cos(a) * d) + this.petriDish.center.x;
			p.y = (Math.sin(a) * d * 0.525) + this.petriDish.center.y;
			
			return p;
		}
		
		public function get currentTutorialStep() : String
		{
			return this.tutorial.currentStep;
		}
		
		public function countCubeDispositions() : Array
		{
			var counts : Array = new Array();
			var i : int;
			var cube : Cube;
			var count : int;
			var cubesLength : int;
			
			count = 0;
			cubesLength = this.cubes.members.length;
			
			counts[Disposition.BALANCED] = 0;
			counts[Disposition.RED] = 0;
			counts[Disposition.GREEN] = 0;
			counts[Disposition.BLUE] = 0;
			counts[Disposition.YELLOW] = 0;
			counts[Disposition.CYAN] = 0;
			counts[Disposition.MAGENTA] = 0;
			
			for (i = 0; i < cubesLength; i++)
			{
				cube = this.cubes.members[i];
				
				if (cube != null && cube.exists)
				{
					counts[cube.currentDisposition]++;
				}
			}
			
			return counts;
		}
		
		public function countCubesWithDisposition(d : int) : int
		{
			var i : int;
			var cube : Cube;
			var count : int;
			var cubesLength : int;
			
			count = 0;
			cubesLength = this.cubes.members.length;
			
			for (i = 0; i < cubesLength; i++)
			{
				cube = this.cubes.members[i];
				
				if (cube != null && cube.exists && cube.currentDisposition == d)
				{
					count++;
				}
			}
			
			return count;
		}
		
		public function findFirstCubeWithDisposition(d : int) : Cube
		{
			var i : int;
			var cube : Cube;
			var count : int;
			var cubesLength : int;
			
			count = 0;
			cubesLength = this.cubes.members.length;
			
			for (i = 0; i < cubesLength; i++)
			{
				cube = this.cubes.members[i];
				
				if (cube != null && cube.exists && cube.currentDisposition == d)
				{
					return cube;
				}
			}
			
			return null;
		}
		
		private function removeAllCubes() : void
		{
			var i : int;
			var cube : Cube;
			
			while (this.cubes.members.length > 0)
			{
				cube = this.cubes.members[0];
				this.removeCube(cube);
			}
		}
		
		public function get currentTweezerChain() : FoodChain
		{
			return this.tweezerChain;
		}
	}
	
}