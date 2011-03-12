package com.wasabi.addicube.states 
{
	import com.wasabi.addicube.Main;
	import com.wasabi.addicube.objects.Collider;
	import com.wasabi.addicube.objects.Cube;
	import com.wasabi.addicube.objects.FoodPoof;
	import com.wasabi.addicube.objects.PetriDish;
	import com.wasabi.addicube.ui.Toolbar;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class PlayingState extends GameState
	{
		
		public static const MAXIMUM_FOOD : int = 300;
		public static const ELLIPSE_NUDGE : Number = 1.15;
		
		public static const SCROLL_SPEED : Number = 100;
		
		//	120x120 circle in a 128x128 sprite
		[Embed(source = '../../../../../assets/circle.png')]
		private static const GFX_CIRCLE : Class;
		
		//	The probe ellipse
		[Embed(source = '../../../../../assets/probeEllipse.png')]
		private static const GFX_ELLIPSE : Class;
		
		public static const MODE_PAN : int = Toolbar.BUTTON_PAN;
		public static const MODE_PROBE : int = Toolbar.BUTTON_PROBE;
		public static const MODE_PIPETTE : int = Toolbar.BUTTON_PIPETTE;
		public static const MODE_TWEEZERS : int = Toolbar.BUTTON_TWEEZERS;
		public static const MODE_SCALPEL : int = Toolbar.BUTTON_SCALPEL;
		
		public static var instance : PlayingState;
		
		public var currentMode : int;
		public var mouseIsOverToolbar : Boolean;
		
		private var dish : PetriDish;
		
		private var cubes : FlxGroup;
		private var cubeBaseColliders : FlxGroup;
		private var cubeBodyColliders : FlxGroup;
		
		private var desiredCubeCount : int;
		private var infoText : FlxText;
		
		//	Food
		private var foodPoofs : FlxGroup;
		
		//	Combines cubes, food, and chains, so they can be depth sorted
		private var movingObjects : FlxGroup;
		
		private var backgroundLayer : FlxGroup;
		private var objectLayer : FlxGroup;
		private var uiLayer : FlxGroup;
		
		//	UI Parts
		private var toolbar : Toolbar;
		
		private var cameraTarget : FlxSprite;
		
		//	Panning support
		private var mouseIsPanning : Boolean;
		private var mousePanningStart : FlxPoint;
		
		//	Probe support
		private var probeIsCharging : Boolean;
		private var probeOrigin : FlxPoint;
		private var probeRadius : Number;
		private var probeFieldSprite : FlxSprite;
		
		private var probeEccentricity : Number;
		private var probeMajorAxis : Number;
		private var probeMinorAxis : Number;
		
		//	Debugging flags
		private var showCollisionObjects : Boolean;
		
		//	Pipette support
		private var pipetteContent : FoodPoof;
		private var pipetteCollider : Collider;
		
		public function PlayingState() 
		{
			PlayingState.instance = this;
		}
		
		override public function create():void 
		{
			super.create();
			
			this.desiredCubeCount = 3;
			
			this.currentMode = PlayingState.MODE_PAN;
			this.mouseIsOverToolbar = false;
			
			this.mouseIsPanning = false;
			this.mousePanningStart = new FlxPoint();
			
			//	Probe setup
			this.probeIsCharging = false;
			this.probeOrigin = new FlxPoint();
			this.probeRadius = 0;
			this.probeFieldSprite = new FlxSprite(0, 0, PlayingState.GFX_ELLIPSE);
			this.probeFieldSprite.exists = false;
			
			var n : Number;
			
			this.probeMajorAxis = this.probeFieldSprite.width / 2;
			this.probeMinorAxis = this.probeFieldSprite.height / 2;
			n = (this.probeMinorAxis / this.probeMajorAxis);
			this.probeEccentricity = Math.sqrt(1 - (n * n));
			
			//	Pipette setup
			this.pipetteContent = null;
			this.pipetteCollider = new Collider(null);
			this.pipetteCollider.createGraphic(2, 2, 0x22FF00FF);
			
			var i : int;
			
			//	Setup rendering layers
			this.backgroundLayer = new FlxGroup();
			this.objectLayer = new FlxGroup();
			this.uiLayer = new FlxGroup();
			
			this.add(this.backgroundLayer);
			this.add(this.objectLayer);
			this.add(this.uiLayer);
			
			//	Probe field
			this.objectLayer.add(this.probeFieldSprite);
			
			//	Setup cube group
			this.cubes = new FlxGroup();
			//this.objectLayer.add(this.cubes);
			
			this.movingObjects = new FlxGroup();
			this.objectLayer.add(this.movingObjects);
			
			this.cubeBaseColliders = new FlxGroup();
			this.objectLayer.add(this.cubeBaseColliders);
			
			this.cubeBodyColliders = new FlxGroup();
			this.objectLayer.add(this.cubeBodyColliders);
			
			//	Food poofs
			this.foodPoofs = new FlxGroup();
			//this.objectLayer.add(this.foodPoofs);
			
			//	Petri dish
			this.dish = new PetriDish();
			this.backgroundLayer.add(this.dish);
			
			//	Camera setup
			this.cameraTarget = new FlxSprite();
			this.cameraTarget.createGraphic(2, 2, 0xFFF0000);
			this.cameraTarget.x = this.dish.width / 2;
			this.cameraTarget.y = FlxG.height / 2;
			this.objectLayer.add(this.cameraTarget);
			
			FlxG.follow(this.cameraTarget, 6.0);
			FlxG.followBounds(0, 0, this.dish.width, this.dish.height);
			
			//	UI
			this.uiLayer.scrollFactor = new FlxPoint();
			
			this.toolbar = new Toolbar();
			this.uiLayer.add(this.toolbar);
			
			this.infoText = new FlxText(2, FlxG.height - 20, FlxG.width - 4);
			this.infoText.color = 0xFF00FF;
			this.uiLayer.add(this.infoText, true);
			
			//	Setup debugging flags
			this.showCollisionObjects = false;
			this.cubeBaseColliders.visible = Main.DEBUG_COLLISION;
			this.cubeBodyColliders.visible = Main.DEBUG_COLLISION;
			
			//	Set initial mode to probe
			this.setMode(PlayingState.MODE_PROBE);
			
			//	Generate some random cubes to start with
			this.addRandomCubes();
		}
		
		public function get cubeBaseColliderGroup() : FlxGroup
		{
			return this.cubeBaseColliders;
		}
		
		public function isPointInsideProbeEllipse(p : FlxPoint) : Boolean
		{
			var fa : FlxPoint;
			var fb : FlxPoint;
			var d : Number;
			var dist : FlxPoint;
			
			//FlxG.log("pe: " + this.probeEccentricity);
			
			d = this.probeEccentricity * this.probeMajorAxis;
			d *= this.probeFieldSprite.scale.x;
			
			fa = new FlxPoint(this.probeOrigin.x - d, this.probeOrigin.y);
			fb = new FlxPoint(this.probeOrigin.x + d, this.probeOrigin.y);
			
			d = distance(p, fa) + distance(p, fb);
			//d = distance(p, this.probeOrigin);
			//FlxG.log("D: " + d + " -- " + p.x + ", " + p.y + " / " + this.probeOrigin.x + ", " + this.probeOrigin.y + " vs " + (this.probeMajorAxis * this.probeFieldSprite.scale.x));
			
			return (d <= this.probeMajorAxis * this.probeFieldSprite.scale.x * 2 * PlayingState.ELLIPSE_NUDGE);
		}
		
		private function distance(a : FlxPoint, b : FlxPoint) : Number
		{
			return Math.sqrt(
				(a.x - b.x) * (a.x - b.x) +
				(a.y - b.y) * (a.y - b.y)
			);
		}
		
		public function getClosestCube(p : FlxPoint, skip : Cube, skipStunned : Boolean) : Cube
		{
			var i : int;
			var d : Number;
			var minD : Number = Number.MAX_VALUE;
			var minCube : Cube = null;
			
			for (i = 0; i < this.cubes.members.length; i++)
			{
				if (this.cubes.members[i] == skip || this.cubes.members[i].stunned)
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
		
		override public function update():void 
		{
			if (this.toolbar.background.overlapsPointScreenSpace(FlxG.mouse.screenX, FlxG.mouse.screenY, true))
			{
				this.mouseIsOverToolbar = true;
			}
			else
			{
				this.mouseIsOverToolbar = false;
			}
			
			super.update();
			
			var i : int;
			
			//	Cube collision
			//this.cubeBaseColliders.collide(this.cubeBaseColliders);
			
			//	Input handling
			if (FlxG.keys.justPressed("F"))
			{
				//var poof : FoodPoof = new FoodPoof();
				var poofColor : int;
				var color : uint;
				
				//poof.spawn(FlxG.mouse.x, FlxG.mouse.y);
				
				poofColor = Math.floor(FlxU.random() * 3);
				
				if (poofColor == 0) color = FoodPoof.COLOR_BLUE;
				else if (poofColor == 1) color = FoodPoof.COLOR_GREEN
				else color = FoodPoof.COLOR_RED;
				
				//this.foodPoofs.add(poof);
				this.spawnFoodPoof(FlxG.mouse.x, FlxG.mouse.y, color);
			}
			
			if (FlxG.keys.justPressed('B'))
			{
				this.showCollisionObjects = !this.showCollisionObjects;
				
				this.cubeBaseColliders.visible = this.showCollisionObjects;
				this.cubeBodyColliders.visible = this.showCollisionObjects;
			}
			
			var cube : Cube;
			
			if (FlxG.keys.justPressed('R'))
			{
				//	Remove all the cubes
				while (this.cubes.members.length > 0)
				{
					cube = this.cubes.members.pop();
					this.movingObjects.remove(cube, true);
					
					this.cubeBaseColliders.members.pop();
					this.cubeBodyColliders.members.pop();
				}
				
				//	Remove all the food
				while (this.foodPoofs.members.length > 0)
				{
					this.foodPoofs.members.pop();
				}
				
				this.addRandomCubes();
			}
			
			if (FlxG.keys.justPressed('Q'))
			{
				this.desiredCubeCount--;
				if (this.desiredCubeCount < 1) this.desiredCubeCount = 1;
				this.addRandomCubes();
			}
			else if (FlxG.keys.justPressed('W'))
			{
				this.desiredCubeCount++;
				this.addRandomCubes();
			}
			
			if (FlxG.keys.justPressed('ONE')) this.setMode(PlayingState.MODE_PAN);
			else if (FlxG.keys.justPressed('TWO')) this.setMode(PlayingState.MODE_PROBE);
			else if (FlxG.keys.justPressed('THREE')) this.setMode(PlayingState.MODE_PIPETTE);
			else if (FlxG.keys.justPressed('FOUR')) this.setMode(PlayingState.MODE_TWEEZERS);
			else if (FlxG.keys.justPressed('FIVE')) this.setMode(PlayingState.MODE_SCALPEL);
			
			if (FlxG.keys.justPressed('SIX')) this.toggleMode(PlayingState.MODE_PROBE);
			else if (FlxG.keys.justPressed('SEVEN')) this.toggleMode(PlayingState.MODE_PIPETTE);
			else if (FlxG.keys.justPressed('EIGHT')) this.toggleMode(PlayingState.MODE_TWEEZERS);
			else if (FlxG.keys.justPressed('NINE')) this.toggleMode(PlayingState.MODE_SCALPEL);
			
			if (FlxG.mouse.justPressed())
			{
				if (this.mouseIsOverToolbar)
				{
					//this.handleToolbarMouseClick();
				}
				else
				{
					//	Probe use
					if (this.currentMode == PlayingState.MODE_PROBE)
					{
						if (!this.probeIsCharging)
						{
							this.probeIsCharging = true;
							this.probeRadius = 2.0;
							this.probeOrigin.x = FlxG.mouse.x;
							this.probeOrigin.y = FlxG.mouse.y;
							
							this.probeFieldSprite.color = 0xFFFF0000;
							this.probeFieldSprite.exists = true;
							this.probeFieldSprite.x = this.probeOrigin.x - this.probeFieldSprite.width / 2.0;
							this.probeFieldSprite.y = this.probeOrigin.y - this.probeFieldSprite.height / 2.0;
						}
					}
					
					//	Pipette
					else if (this.currentMode == PlayingState.MODE_PIPETTE)
					{
						if (this.pipetteContent == null)
						{
							//	Attempt to collect a new poof, since the pipette is empty
							this.pipetteCollider.reset(FlxG.mouse.x, FlxG.mouse.y);
							FlxU.overlap(this.pipetteCollider, this.foodPoofs, this.collidePippeteTouchedFoodPoof);
						}
						else
						{
							//	Drop the current poof
							this.pipetteContent.reset(FlxG.mouse.x - this.pipetteContent.width / 2, FlxG.mouse.y - this.pipetteContent.height / 2);
							this.pipetteContent.exists = true;
							this.pipetteContent = null;
						}
					}
					
					//	Panning
					else if (this.currentMode == PlayingState.MODE_PAN)
					{
						this.startMousePanning();
					}
				}
			}
			
			//	Probe updates
			this.updateProbe();
			
			if (this.mouseIsPanning)
			{
				if (FlxG.mouse.pressed())
				{
					this.updateMousePanning();
				}
				else
				{
					this.stopMousePanning();
				}
			}
			
			//	Basic keyboard panning
			if (FlxG.keys.RIGHT)
			{
				this.cameraTarget.x += FlxG.elapsed * PlayingState.SCROLL_SPEED;
			}
			else if (FlxG.keys.LEFT)
			{
				this.cameraTarget.x -= FlxG.elapsed * PlayingState.SCROLL_SPEED;
			}
			
			if (FlxG.keys.DOWN)
			{
				this.cameraTarget.y += FlxG.elapsed * PlayingState.SCROLL_SPEED;
			}
			else if (FlxG.keys.UP)
			{
				this.cameraTarget.y -= FlxG.elapsed * PlayingState.SCROLL_SPEED;
			}
			
			var cameraBounds : FlxRect;
			
			cameraBounds = new FlxRect(
				FlxG.width / 2, FlxG.height / 2,
				this.dish.width - FlxG.width,
				this.dish.height - FlxG.height
			);
			
			if (this.cameraTarget.x > cameraBounds.right) this.cameraTarget.x = cameraBounds.right;
			else if (this.cameraTarget.x < cameraBounds.left) this.cameraTarget.x = cameraBounds.left;
			
			if (this.cameraTarget.y > cameraBounds.bottom) this.cameraTarget.y = cameraBounds.bottom;
			else if (this.cameraTarget.y < cameraBounds.top) this.cameraTarget.y = cameraBounds.top;
			
			//	Cube -> Food Poof collision
			FlxU.overlap(this.cubeBodyColliders, this.foodPoofs, this.collideCubeTouchedFoodPoof);
			
			//	Keep the cubes sorted by depth (y-value)
			//this.cubes.members.sortOn("depth", Array.NUMERIC);
			this.movingObjects.members.sortOn("depth", Array.NUMERIC);
			
			//this.infoText.text = "Mouse: " + FlxG.mouse.x + ", " + FlxG.mouse.y + " / " + FlxG.mouse.screenX + ", " + FlxG.mouse.screenY;
			this.infoText.text = "BCs: " + this.cubeBaseColliders.members.length
		}
		
		private function updateProbe() : void
		{
			var i : int;
			var distanceToCube : Number;
			var cube : Cube;
			
			if (this.probeIsCharging)
			{
				this.probeRadius += 45.0 * FlxG.elapsed;
				this.probeFieldSprite.scale.x = this.probeFieldSprite.scale.y = (this.probeRadius * 2.0) / this.probeFieldSprite.width;
				
				if (!FlxG.mouse.pressed())
				{
					this.probeFieldSprite.exists = false;
					this.probeIsCharging = false;
					
					//	Apply effect to cubes
					for (i = 0; i < this.cubes.members.length; i++)
					{
						cube = this.cubes.members[i] as Cube;
						
						if (cube.exists && cube.active && !cube.dead && !cube.eating)
						{
							if (this.isPointInsideProbeEllipse(cube.center))
							{
								cube.movementTarget = new FlxPoint(this.probeOrigin.x, this.probeOrigin.y);
							}
							else
							{
								cube.lookAt(null);
							}
						}
					}
				}
				else
				{
					//	Cause cubes to look at the probe
					for (i = 0; i < this.cubes.members.length; i++)
					{
						cube = this.cubes.members[i] as Cube;
						
						if (cube.exists && cube.active && !cube.dead && !cube.eating)
						{
							if (this.isPointInsideProbeEllipse(cube.center))
							{
								cube.lookAt(this.probeOrigin);
							}
						}
					}
				}
				
				//	DEBUG: Ellipse testing
				/*
				for (i = 0; i < this.cubes.members.length; i++)
				{
					cube = this.cubes.members[i] as Cube;
					
					if (cube.exists && cube.active && !cube.dead)
					{
						if (this.isPointInsideProbeEllipse(cube.center))
						{
							//cube.movementTarget = new FlxPoint(this.probeOrigin.x, this.probeOrigin.y);
							//cube.setColor(255, 0, 0);
						}
					}
				}
				*/
			}
		}
		
		private function collideCubeTouchedFoodPoof(c : FlxObject, f : FlxObject) : void
		{
			var collider : Collider = c as Collider;
			var foodPoof : FoodPoof = f as FoodPoof;
			var cube : Cube;
			
			if (collider != null)
			{
				cube = collider.owner as Cube;
			}
			
			if (cube != null && foodPoof != null && foodPoof.active)
			{
				//foodPoof.kill();
				cube.eat(foodPoof);
			}
		}
		
		private function collidePippeteTouchedFoodPoof(c : FlxObject, f : FlxObject) : void
		{
			var collider : Collider = c as Collider;
			var foodPoof : FoodPoof = f as FoodPoof;
			
			if (this.pipetteContent == null && collider != null && foodPoof != null)
			{
				this.pipetteContent = foodPoof;
				foodPoof.exists = false;
			}
		}
		
		private function startMousePanning() : void
		{
			this.mouseIsPanning = true;
			this.mousePanningStart = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		
		private function stopMousePanning() : void
		{
			this.mouseIsPanning = false;
			this.mousePanningStart = new FlxPoint();
		}
		
		private function updateMousePanning() : void
		{
			var dx : int;
			var dy : int;
			
			dx = FlxG.mouse.screenX - this.mousePanningStart.x;
			dy = FlxG.mouse.screenY - this.mousePanningStart.y;
			
			this.cameraTarget.x -= dx;
			this.cameraTarget.y -= dy;
			
			this.mousePanningStart.x = FlxG.mouse.screenX;
			this.mousePanningStart.y = FlxG.mouse.screenY;
		}
		
		public function setMode(mode : int) : void
		{
			if (this.toolbar.isButtonEnabled(mode))
			{
				this.toolbar.setActiveButton(mode);
				this.currentMode = mode;
			}
		}
		
		public function disableMode(mode : int) : void
		{
			//	The panning tool cannot be disabled
			if (mode == PlayingState.MODE_PAN) return;
			
			//	If the current tool is being disabled, select the
			//	previous tool
			if (this.currentMode == mode)
			{
				this.setMode(this.currentMode - 1);
			}
			
			this.toolbar.disableButton(mode);
		}
		
		public function enableMode(mode : int) : void
		{
			this.toolbar.enableButton(mode);
		}
		
		public function toggleMode(mode : int) : void
		{
			if (this.toolbar.isButtonEnabled(mode)) this.disableMode(mode);
			else this.enableMode(mode);
		}
		
		public function addCube(cube : Cube) : void
		{
			this.cubes.add(cube);
			this.movingObjects.add(cube);
			this.cubeBaseColliders.add(cube.baseCollider);
			this.cubeBodyColliders.add(cube.bodyCollider);
		}
		
		public function removeCube(cube : Cube) : void
		{
			this.cubes.remove(cube);
			this.movingObjects.remove(cube);
			this.cubeBaseColliders.remove(cube.baseCollider);
			this.cubeBodyColliders.remove(cube.bodyCollider);
		}
		
		private function addRandomCubes() : void
		{
			var i : int;
			var cube : Cube;
			
			this.infoText.text = "Cubes: " + this.desiredCubeCount;
			
			while (this.cubes.members.length > this.desiredCubeCount)
			{
				cube = this.cubes.members.pop();
				this.movingObjects.remove(cube, true);
				
				this.cubeBaseColliders.members.pop();
				this.cubeBodyColliders.members.pop();
			}
			
			//	Test cubes
			for (i = this.cubes.members.length; i < this.desiredCubeCount; i++)
			{
				cube = new Cube(FlxU.random() * this.dish.width, FlxU.random() * this.dish.height);
				
				this.cubes.add(cube);
				this.movingObjects.add(cube);
				
				this.cubeBaseColliders.add(cube.baseCollider);
				this.cubeBodyColliders.add(cube.bodyCollider);
			}
		}
		
		public function spawnFoodPoof(x : int, y : int, color : uint, canSpawnChildren : Boolean = true) : void
		{
			if (this.foodPoofs.countLiving() < PlayingState.MAXIMUM_FOOD)
			{
				var poof : FoodPoof;
				
				poof = new FoodPoof();
				poof.spawn(x, y, canSpawnChildren);
				poof.setColor(color);
				
				this.foodPoofs.add(poof);
				
				this.movingObjects.add(poof);
			}
		}
	}

}