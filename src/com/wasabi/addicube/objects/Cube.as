package com.wasabi.addicube.objects 
{
	import adobe.utils.CustomActions;
	import com.wasabi.addicube.Main;
	import com.wasabi.addicube.states.PlayingState;
	import flash.geom.Point;
	import org.flixel.data.FlxPanel;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Cube extends FlxGroup
	{
		
		[Embed(source = '../../../../../assets/Arrow.png')]
		private static const GFX_ARROW : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.cube.png')]
		private static const GFX_CUBE : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.face.png')]
		private static const GFX_EYES : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.mouth.png')]
		private static const GFX_MOUTH : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.nose01.png')]
		private static const GFX_NOSE_01 : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.nose02.png')]
		private static const GFX_NOSE_02 : Class;
		
		public static const FOOD_TO_SPLIT : int = 18;
		public static const FOOD_TO_GROW : int = 2;
		
		public static const BEHAVIOR_BALANCED : int = 0;
		public static const BEHAVIOR_RED : int = 1;
		public static const BEHAVIOR_GREEN : int = 2;
		public static const BEHAVIOR_BLUE : int = 3;
		public static const BEHAVIOR_YELLOW : int = 4;
		public static const BEHAVIOR_MAGENTA : int = 5;
		public static const BEHAVIOR_CYAN : int = 6;
		
		public static const FACING_EAST : int = 0;
		public static const FACING_SE : int = 1;
		public static const FACING_SOUTH : int = 2;
		public static const FACING_SW : int = 3;
		public static const FACING_WEST : int = 4;
		public static const FACING_NW: int = 5;
		public static const FACING_NORTH : int = 6;
		public static const FACING_NE : int = 7;
		
		//	//Name, StartingFrameOffset, Length, FrameRate, FrameListCache
		//	Name, Frames, FrameRate, Loops?, FrameListCache
		private static const ALI_NAME : int = 0;
		private static const ALI_FRAMES : int = 1;
		private static const ALI_FRAME_RATE : int = 2;
		private static const ALI_LOOP : int = 3;
		private static const ALI_CACHE : int = 4;
		
		private static const SIZE_SMALL : Number = 0.5;
		private static const SIZE_MEDIUM : Number = 0.75;
		private static const SIZE_LARGE : Number = 1.0;
		
		private static var animationList : Array =
		[
			[ "Idle", [ 0 ], 1, true, [ ] ],
			[ "Fidget", [ 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3 ], 8, true, [ ] ],
			[ "StartWalk", [ 21, 22, 23 ], 12, false, [ ] ],
			[ "Walk", [ 24, 25, 26, 27, 28, 29, 30, 31, 32 ], 12, true, [ ] ],
			[ "StartSucking", [ 15, 16, 17, 18 ], 12, false, [ ] ],
			[ "Sucking", [ 18 ], 12, true, [ ] ],
			[ "StopSucking", [ 19, 20 ], 12, false, [ ] ],
			[ "LookRight", [ 12, 13, 14 ], 8, false, [ ] ],
			[ "LookLeft", [ 9, 10, 11 ], 8, false, [ ] ],
			//[ "Idle", 1, 1, 15, [] ],
			//[ "Fidget", 0, 3, 5, [] ]
		];
		
		private static var faceAngles : Array = [ Cube.FACING_SE, Cube.FACING_SOUTH, Cube.FACING_SW ];
		private static var noseAngles : Array = [ Cube.FACING_EAST, Cube.FACING_SE, Cube.FACING_SOUTH, Cube.FACING_SW, Cube.FACING_WEST ];
		
		private static const FRAMES_PER_ROW : int = 33;
		
		private static const FACE_ANIMATION_OFFSET : int = 1 * Cube.FRAMES_PER_ROW;
		private static const NOSE_ANIMATION_OFFSET : int = 0 * Cube.FRAMES_PER_ROW;
		
		private var backEyesSprite : FlxSprite;
		private var backNoseSprite : FlxSprite;
		
		private var cubeSprite : FlxSprite;
		
		private var eyesSprite : FlxSprite;
		private var mouthSprite : FlxSprite;
		private var noseSprite : FlxSprite;
		
		private var infoText : FlxText;
		
		//	Food counters
		private var red : Number;
		private var green : Number;
		private var blue : Number;
		private var totalFoodEaten : int;
		private var foodSinceGrowth : int;
		private var hunger : Number;
		private var hungerRate : Number;
		private var behavior : int;
		
		private var currentFacingId : int;
		
		private var speed : Number;
		
		public var movementTarget : FlxPoint;
		public var lookAtTarget : FlxPoint;
		
		public var bodyCollider : FlxSprite;
		public var baseCollider : FlxSprite;
		
		//	Was 38, 88 and 53, 12
		private var baseColliderOffset : FlxPoint = new FlxPoint(38, 75);
		private var baseColliderSize : FlxPoint = new FlxPoint(53, 25);
		
		private var bodyColliderOffset : FlxPoint = new FlxPoint(35, 30);
		private var bodyColliderSize : FlxPoint = new FlxPoint(60, 70);
		
		private var currentAnimation : String;
		
		private var targetFoodPoof : FoodPoof;
		private var foodPoofOrigin: FlxPoint;
		private var suckingDelay : Number;
		private var eatingDelay : Number;
		
		private var currentCubeSize : Number;
		private var targetCubeSize : Number;
		
		//	RED
		private var targetCube : Cube;
		private var isHeadbutting : Boolean;
		
		private var dashDirection : FlxPoint;
		
		private var isStunned : Boolean;
		private var stunClock : Number;
		
		public function Cube(x : int, y : int) 
		{
			var whichNose : Class;
			
			super();
			
			this.isHeadbutting = false;
			this.targetCube = null;
			this.dashDirection = new FlxPoint();
			
			this.isStunned = false;
			this.stunClock = 0;
			
			this.visible = false;
			this.currentFacingId = -1;
			this.currentAnimation = "Idle";
			this.targetFoodPoof = null;
			
			this.speed = 80.0;
			
			this.totalFoodEaten = 0;
			this.foodSinceGrowth = 0;
			this.behavior = Cube.BEHAVIOR_BALANCED;
			
			this.hunger = 0;
			this.hungerRate = 0.2;
			this.red = this.green = this.blue = 0;
			
			whichNose = FlxU.random() < 0.5 ? Cube.GFX_NOSE_01 : Cube.GFX_NOSE_02;
			
			this.backNoseSprite = new FlxSprite();
			this.backNoseSprite.loadGraphic(whichNose, true, false, 128, 128, false);
			//this.add(this.backNoseSprite);
			
			this.backEyesSprite = new FlxSprite();
			this.backEyesSprite.loadGraphic(Cube.GFX_EYES, true, false, 128, 128, false);
			//this.add(this.backEyesSprite);
			
			this.cubeSprite = new FlxSprite();
			this.cubeSprite.loadGraphic(Cube.GFX_CUBE, true, false, 128, 128, false);
			this.add(this.cubeSprite);
			
			this.eyesSprite = new FlxSprite();
			this.eyesSprite.loadGraphic(Cube.GFX_EYES, true, false, 128, 128, false);
			this.add(this.eyesSprite);
			
			this.mouthSprite = new FlxSprite();
			this.mouthSprite.loadGraphic(Cube.GFX_MOUTH, true, false, 128, 128, false);
			//this.add(this.mouthSprite);
			
			this.noseSprite = new FlxSprite();
			this.noseSprite.loadGraphic(whichNose, true, false, 128, 128, false);
			//this.noseSprite.addAnimation("Idle", [ 0, 1, 2, 3, 4, 5, 6, 7 ]);
			this.add(this.noseSprite);
			
			this.baseCollider = new Collider(this);
			this.baseCollider.createGraphic(this.baseColliderSize.x, this.baseColliderSize.y, 0x66FFFF00);
			//if (Main.DEBUG_COLLISION) this.add(this.baseCollider);
			
			this.bodyCollider = new Collider(this);
			this.bodyCollider.createGraphic(this.bodyColliderSize.x, this.bodyColliderSize.y, 0x6600FFFF);
			//if (Main.DEBUG_COLLISION) this.add(this.bodyCollider);
			
			this.buildAnimations();
			
			this.infoText = new FlxText(0, this.cubeSprite.height + 2, this.cubeSprite.width);
			this.infoText.color = 0x666666;
			this.add(this.infoText);
			
			this.x = x;
			this.y = y;
			
			this.movementTarget = null;
			
			this.backEyesSprite.antialiasing = true;
			this.backNoseSprite.antialiasing = true;
			this.cubeSprite.antialiasing = true;
			this.eyesSprite.antialiasing = true;
			this.mouthSprite.antialiasing = true;
			this.noseSprite.antialiasing = true;
			
			this.cubeSize = Cube.SIZE_SMALL;
			this.targetCubeSize = this.currentCubeSize;
		}
		
		private function buildAnimations() : void
		{
			var facingId : int;
			var baseFrame : int;
			var animations : Array;
			var animationId : int;
			var animationStartFrame : int;
			var frames : Array;
			var noseFrames : Array;
			var faceFrames : Array;
			var i : int;
			
			animationStartFrame = 0;
			
			//	TODO: Needs optimization
			var animationsLength : int = Cube.animationList.length;
			var facingCount : int = 7;
			var animationName : String;
			var frameRate : int;
			var frameCount : int;
			
			for (animationId = 0; animationId < animationsLength; animationId++)
			{
				//animationStartFrame += Cube.animationList[animationId][1];
				
				for (facingId = 0; facingId <= facingCount; facingId++)
				{
					baseFrame = facingId * Cube.FRAMES_PER_ROW /*+ Cube.animationList[animationId][1]*/;
					
					animationName = Cube.animationList[animationId][Cube.ALI_NAME] + facingId;
					frameRate = Cube.animationList[animationId][Cube.ALI_FRAME_RATE];
					
					if (false && Cube.animationList[animationId][Cube.ALI_CACHE][facingId] != null)
					{
						//	Get the cached array of frames
						frames = Cube.animationList[animationId][Cube.ALI_CACHE][facingId];
						
						//FlxG.log("Used cached animation frame set for: " + animationName + " " + frames);
					}
					else
					{
						//	Build the array of frames for the animation
						frames = new Array();
						noseFrames = new Array();
						faceFrames = new Array();
						
						for (i = 0; i < Cube.animationList[animationId][Cube.ALI_FRAMES].length; i++)
						{
							frames.push(Cube.animationList[animationId][Cube.ALI_FRAMES][i] + baseFrame);
							noseFrames.push(Cube.animationList[animationId][Cube.ALI_FRAMES][i] + baseFrame - Cube.NOSE_ANIMATION_OFFSET);
							faceFrames.push(Cube.animationList[animationId][Cube.ALI_FRAMES][i] + baseFrame - Cube.FACE_ANIMATION_OFFSET);
						}
						
						Cube.animationList[animationId][Cube.ALI_CACHE][facingId] = frames;						
						FlxG.log("Created new FACE animation frame set for: " + animationName + " " + faceFrames);
					}
					
					this.backNoseSprite.addAnimation(animationName, noseFrames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
					this.backEyesSprite.addAnimation(animationName, faceFrames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
					this.cubeSprite.addAnimation(animationName, frames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
					this.noseSprite.addAnimation(animationName, noseFrames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
					this.eyesSprite.addAnimation(animationName, faceFrames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
					this.mouthSprite.addAnimation(animationName, frames, frameRate, Cube.animationList[animationId][Cube.ALI_LOOP]);
				}
			}
		}
		
		private function turnToFace(p : FlxPoint) : void
		{
			var facing : Number;
			var facingDegress : Number;
			var adjustedFacingDegress : Number;
			var toTarget : FlxPoint;
			var facingId : int;
			
			toTarget = new FlxPoint(
				p.x - this.center.x,
				p.y - this.center.y
			);
			
			facing = Math.atan2(toTarget.y, toTarget.x);
			facingDegress = (facing / Math.PI) * 180;
			if (facingDegress < 0) facingDegress += 360;
			
			adjustedFacingDegress = facingDegress - 22.5;
			facingId = ((adjustedFacingDegress / 45) + 1) % 8;
			
			this.setFacing(facingId);
		}
		
		public function lookAt(p : FlxPoint) : void
		{
			if (p == null)
			{
				this.lookAtTarget = null;
				this.switchAnimation("Idle");
			}
			else
			{
				if (this.lookAtTarget == null || p.x != this.lookAtTarget.x)
				{
					if (p.x < this.center.x)
					{
						this.switchAnimation("LookLeft");
					}
					else
					{
						this.switchAnimation("LookRight");
					}
				}
				
				this.lookAtTarget = new FlxPoint(p.x, p.y);
			}
		}
		
		private function setFacing(facingId : int) : void
		{
			//	Adjust layer visibility to account for the correct layer order based on the
			//	direction the cube is currently facing
			if (facingId == 0 || facingId >= 4)
			{
				this.backEyesSprite.visible = this.backNoseSprite.visible = true;
				this.eyesSprite.visible = this.noseSprite.visible = this.mouthSprite.visible = false;
			}
			else
			{
				this.backEyesSprite.visible = this.backNoseSprite.visible = false;
				this.eyesSprite.visible = this.noseSprite.visible = this.mouthSprite.visible = true;
			}
			
			//	Set the animation to correspond to the direction the cube is facing
			if (this.currentFacingId != facingId)
			{
				var currentFrame : int = this.cubeSprite.frame;
				
				this.currentFacingId = facingId;
				this.adjustAnimationForFacing();
			}
		}
		
		private function normalize(p : FlxPoint, pn : FlxPoint = null) : Number
		{
			var l : Number;
			
			l = p.x * p.x + p.y * p.y;
			l = Math.sqrt(l);
			
			if (pn == null)
			{
				pn = new FlxPoint(p.x / l, p.y / l);
			}
			else
			{
				pn.x = p.x / l;
				pn.y = p.y / l;
			}
			
			return l;
		}
		
		private function updateEating() : void
		{
			var percentage : Number;
			
			if (this.targetFoodPoof != null || this.currentAnimation == "StopSucking")
			{
				if (this.targetFoodPoof != null && this.targetFoodPoof.exists == false)
				{
					this.targetFoodPoof = null;
					this.switchAnimation("Idle");
					return;
				}
				
				//FlxG.log(this.currentAnimation + " / " + this.cubeSprite.finished);
				
				if (this.currentAnimation == "StartSucking")
				{
					if (this.cubeSprite.finished)
					{
						this.switchAnimation("Sucking");
						this.suckingDelay = 4.0;
						FlxG.log("Starting sustained sucking");
					}
				}
				else if (this.currentAnimation == "Sucking")
				{
					this.suckingDelay -= FlxG.elapsed;
					if (this.suckingDelay < 0) this.suckingDelay = 0;
					
					percentage = 1.0 - (this.suckingDelay / 1.0);
					
					//FlxG.log("Sucking continues: " + this.suckingDelay);
					
					if (this.suckingDelay <= 0)
					{
						//	Done eating
						this.finishEating();
					}
					else
					{
						this.targetFoodPoof.x = (this.foodPoofOrigin.x + (this.center.x - this.foodPoofOrigin.x) * percentage);
						this.targetFoodPoof.y = (this.foodPoofOrigin.y + ((this.center.y + 20) - this.foodPoofOrigin.y) * percentage);
					}
				}
				else if (this.currentAnimation == "StopSucking")
				{
					this.eatingDelay -= FlxG.elapsed;
					
					if (this.eatingDelay <= 0)
					{
						this.switchAnimation("Idle");
					}
				}
			}
		}	
		
		private function finishEating() : void
		{
			this.totalFoodEaten++;
			this.foodSinceGrowth++;
			this.hunger -= 1.0;
			
			if (targetFoodPoof.getColor() == FoodPoof.COLOR_RED) this.red += 1.0
			else if (targetFoodPoof.getColor() == FoodPoof.COLOR_GREEN) this.green += 1.0
			else if (targetFoodPoof.getColor() == FoodPoof.COLOR_BLUE) this.blue += 1.0
			
			this.targetFoodPoof.kill();
			this.targetFoodPoof = null;
			
			this.switchAnimation("StopSucking");
			
			this.eatingDelay = 0.5;
			
			//	Check for growth
			if (this.totalFoodEaten >= Cube.FOOD_TO_SPLIT)
			{
				this.split();
			}
			else
			{
				if (this.foodSinceGrowth >= Cube.FOOD_TO_GROW)
				{
					if (this.targetCubeSize == Cube.SIZE_SMALL) this.targetCubeSize = Cube.SIZE_MEDIUM;
					else if (this.targetCubeSize == Cube.SIZE_MEDIUM) this.targetCubeSize = Cube.SIZE_LARGE;
					
					this.foodSinceGrowth = 0;
				}
			}
			
			//	Check for color changes
			if (this.totalFoodEaten >= 3)
			{
				FlxG.log("R: " + this.red + ", G:" + this.green + ", B: " + this.blue);
				
				if (this.red - this.green >= 3 && this.red - this.blue >= 3)
				{
					this.setColor(255, 0, 0);
					this.behavior = Cube.BEHAVIOR_RED;
				}
				else if (this.green - this.red >= 3 && this.green - this.blue >= 3)
				{
					this.setColor(0, 255, 0);
					this.behavior = Cube.BEHAVIOR_GREEN;
				}
				else if (this.blue - this.red >= 3 && this.blue - this.green >= 3)
				{
					this.setColor(0, 0, 255);
					this.behavior = Cube.BEHAVIOR_BLUE;
				}
				else
				{
					this.setColor(255, 255, 255);
					this.behavior = Cube.BEHAVIOR_BALANCED;
				}
			}
		}
		
		private function split() : void
		{
			var child : Cube;
			
			child = new Cube(this.x + 10, this.y + 10);
			PlayingState.instance.addCube(child);
			
			this.totalFoodEaten = 0;
			this.red = this.green = this.blue = 0;
			this.reset(this.x - 10, this.y - 10);
		}
		
		override public function update():void 
		{
			super.update();
			
			this.infoText.text = "" + this.eating;
			
			this.updateEating();
			
			//	Debugging
			if (FlxG.mouse.justPressed() && this.bodyCollider.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y))
			{
				if (this.behavior == Cube.BEHAVIOR_RED) this.behavior = Cube.BEHAVIOR_GREEN;
				else if (this.behavior == Cube.BEHAVIOR_GREEN) this.behavior = Cube.BEHAVIOR_BLUE;
				else if (this.behavior == Cube.BEHAVIOR_BLUE) this.behavior = Cube.BEHAVIOR_BALANCED;
				else this.behavior = Cube.BEHAVIOR_RED;
			}
			
			//	Stunned
			if (this.stunned)
			{
				this.stunClock -= FlxG.elapsed;
				if (this.stunClock <= 0) this.stunned = false;
			}
			
			if (!this.visible)
			{
				this.visible = true;
				
				//this.baseCollider.x = this.cubeSprite.center.x - this.baseCollider.width / 2;
				//this.baseCollider.y = this.cubeSprite.center.y - this.baseCollider.height / 2;
				//this.bodyCollider.x = this.cubeSprite.center.x - this.bodyCollider.width / 2;
				//this.bodyCollider.y = this.cubeSprite.center.y - this.bodyCollider.height / 2;
				this.baseCollider.x = this.cubeSprite.center.x + 4;
				this.baseCollider.y = this.cubeSprite.center.y;
				this.bodyCollider.x = this.cubeSprite.center.x;
				this.bodyCollider.y = this.cubeSprite.center.y - this.bodyCollider.height + this.baseCollider.height;
			}
			
			if (this.currentCubeSize < this.targetCubeSize)
			{
				var newSize : Number;
				
				FlxG.log("Cube growing: " + this.currentCubeSize + " / " + this.targetCubeSize);
				
				newSize = this.currentCubeSize + 0.2 * FlxG.elapsed;
				if (newSize > this.targetCubeSize) newSize = this.targetCubeSize
				
				this.cubeSize = newSize;
			}
			
			//	AI
			if (this.behavior == Cube.BEHAVIOR_RED)
			{
				//FlxG.log("RED");
				var cube : Cube;
				
				if (this.targetCube == null)
				{
					cube = PlayingState.instance.getClosestCube(this.center, this, true);
					
					this.targetCube = cube;
					if (this.targetCube != null)
					{
						this.movementTarget = this.targetCube.center;
						this.dashDirection.x = this.targetCube.center.x - this.center.x;
						this.dashDirection.y = this.targetCube.center.y - this.center.y;
						this.normalize(this.dashDirection, this.dashDirection);
					}
				}
			}
			
			var distanceToTarget : Number;
			
			if (this.targetCube != null)
			{
				if (this.bodyCollider.overlaps(this.targetCube.bodyCollider))
				{
					this.targetCube.bodyCollider.reset(
						this.targetCube.bodyCollider.x + 20 * this.dashDirection.x,
						this.targetCube.bodyCollider.y + 20 * this.dashDirection.y
					);
					this.targetCube.baseCollider.reset(
						this.targetCube.baseCollider.x + 20 * this.dashDirection.x,
						this.targetCube.baseCollider.y + 20 * this.dashDirection.y
					);
					this.targetCube.stunned = true;
					
					this.targetCube = null;
					this.movementTarget = null;
				}
			}
			
			if (this.movementTarget != null)
			{
				var toTarget : FlxPoint;
				var toTargetNormal : FlxPoint = new FlxPoint();
				
				toTarget = new FlxPoint(
					this.movementTarget.x - this.baseCollider.x,
					this.movementTarget.y - this.baseCollider.y
				);
				
				distanceToTarget = this.normalize(toTarget, toTargetNormal);
				
				if (distanceToTarget >= 30 || this.targetCube != null)
				{
					//this.velocity.x = toTargetNormal.x * this.speed;
					//this.velocity.y = toTargetNormal.y * this.speed;
					this.baseCollider.velocity.x = toTargetNormal.x * this.speed;
					this.baseCollider.velocity.y = toTargetNormal.y * this.speed;
					this.bodyCollider.velocity.x = toTargetNormal.x * this.speed;
					this.bodyCollider.velocity.y = toTargetNormal.y * this.speed;
					this.turnToFace(this.movementTarget);
					
					if (this.currentAnimation != "StartWalk" && this.currentAnimation != "Walk")
					{
						this.switchAnimation("StartWalk");
					}
					else if (this.currentFrame >= 2)
					{
						this.switchAnimation("Walk");
					}
				} else {
					this.baseCollider.velocity.x = this.baseCollider.velocity.y = 0;
					this.bodyCollider.velocity.x = this.bodyCollider.velocity.y = 0;
					this.movementTarget = null;
					this.setFacing(Cube.FACING_SOUTH);
					this.switchAnimation("Idle");
				}
				
				//this.baseCollider.fixed = false;
				FlxU.collide(this.baseCollider, PlayingState.instance.cubeBaseColliderGroup);
				//this.baseCollider.fixed = true;
				
				//this.x = this.baseCollider.x;
				//this.y = this.baseCollider.y;
				//this.reset(this.baseCollider.x - this.baseColliderOffset.x, this.baseCollider.y - this.baseColliderOffset.y);
			}
			else
			{
				if (this.currentAnimation == "Idle")
				{
					if (FlxU.random() < 0.02)
					{
						this.switchAnimation("Fidget");
					}
				}
				else if (this.currentAnimation == "Fidget" && this.cubeSprite.finished)
				{
					this.switchAnimation("Idle");
				}
				
				if (!this.eating)
				{
					this.setFacing(2);
				}
				
				//this.setFacing(Cube.FACING_SOUTH);
				this.baseCollider.velocity.x = this.baseCollider.velocity.y = 0;
				this.bodyCollider.velocity.x = this.bodyCollider.velocity.y = 0;
			}
			
			//this.reset(this.baseCollider.x - this.baseColliderOffset.x, this.baseCollider.y - this.baseColliderOffset.y);
			//this.reset(this.bodyCollider.x - this.bodyColliderOffset.x, this.bodyCollider.y - this.bodyColliderOffset.y);
			
			this.reset(
				this.bodyCollider.x + this.bodyCollider.width / 2 - this.cubeSprite.width / 2,
				this.bodyCollider.y + this.bodyCollider.height / 2  - this.cubeSprite.height / 2
			);
			
			/*this.reset(
				this.baseCollider.center.x - this.cubeSprite.width / 2,
				this.baseCollider.center.y - this.cubeSprite.height / 2
			);*/
			
			/*if (FlxG.mouse.justPressed() && this.cubeSprite.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y, true))
			{
				this.randomizeColor();
			}*/
			
			//	Update hunger
			this.hunger += this.hungerRate * FlxG.elapsed;
		}
		
		private function switchAnimation(newAnimation : String) : void
		{
			this.currentAnimation = newAnimation;
			this.cubeSprite.finished = false;
			
			this.backEyesSprite.play(this.currentAnimation + this.currentFacingId);
			this.backNoseSprite.play(this.currentAnimation + this.currentFacingId);
			this.cubeSprite.play(this.currentAnimation + this.currentFacingId);
			this.eyesSprite.play(this.currentAnimation + this.currentFacingId);
			this.noseSprite.play(this.currentAnimation + this.currentFacingId);
			this.mouthSprite.play(this.currentAnimation + this.currentFacingId);
		}
		
		private function adjustAnimationForFacing() : void
		{
			var i : int;
			
			for (i = 0; i < this.spriteGroup.members.length; i++)
			{
				this.spriteGroup.members[i].playWithoutInterruption(animation + this.direction);
			}
		}
		
		private function get currentFrame() : int
		{
			return this.cubeSprite._curFrame;
		}
		
		private function randomizeColor() : void
		{
			this.red = 128 + FlxU.random() * 128;
			this.green = 128 + FlxU.random() * 128;
			this.blue = 128 + FlxU.random() * 128;
			
			this.setColor(int(red), int(green), int(blue));
		}
		
		public function eat(poof : FoodPoof) : void
		{
			if (!this.eating /*&& this.hunger > 1.0*/)
			{
				this.targetFoodPoof = poof;
				this.foodPoofOrigin = new FlxPoint(poof.x, poof.y);
				
				this.turnToFace(this.foodPoofOrigin);
				this.switchAnimation("StartSucking");
			}
		}
		
		public function setColor(r : int, g : int, b : int) : void
		{
			this.cubeSprite.color = (r << 16) | (g << 8) | (b);
			this.noseSprite.color = this.backNoseSprite.color = (int(r * 0.8) << 16) | (int(g * 0.8) << 8) | (int(b * 0.8));
		}
		
		public function get color() : uint 
		{
			return this.cubeSprite.color;
		}
		
		public function get center() : FlxPoint
		{
			return new FlxPoint(this.x + 64, this.y + 64);
		}
		
		public function get depth() : Number
		{
			return this.cubeSprite.y + 64;
		}
		
		public function get eating() : Boolean
		{
			return (this.targetFoodPoof != null || this.currentAnimation == "StopSucking");
		}
		
		public function get cubeSize() : Number
		{
			return this.targetCubeSize;
		}
		
		public function set cubeSize(s : Number) : void
		{
			this.currentCubeSize = s;
			FlxG.log("New cube size: " + s);
			
			this.bodyCollider.createGraphic(
				this.bodyColliderSize.x * s,
				this.bodyColliderSize.y * s,
				0x66FF0000
			);
			
			this.baseCollider.createGraphic(
				this.baseColliderSize.x * s,
				this.baseColliderSize.y * s,
				0x66FFFF00
			);
				
			this.backEyesSprite.scale = new FlxPoint(s, s);
			this.backNoseSprite.scale = new FlxPoint(s, s);
			this.cubeSprite.scale = new FlxPoint(s, s);
			this.eyesSprite.scale = new FlxPoint(s, s);
			this.mouthSprite.scale = new FlxPoint(s, s);
			this.noseSprite.scale = new FlxPoint(s, s);
			
			this.baseCollider.x = this.bodyCollider.x;
			this.baseCollider.y = this.bodyCollider.bottom - this.baseCollider.height;
		}
		
		public function get stunned() : Boolean
		{
			return this.isStunned;
		}
		
		public function set stunned(s : Boolean) : void
		{
			this.isStunned = s;
			this.stunClock = 1.0;
			this.eatingDelay = 0.0;
			
			if (this.isStunned)
			{
				this.switchAnimation("Idle");
				
				if (this.targetFoodPoof != null)
				{
					this.targetFoodPoof.owner = null;
					this.targetFoodPoof = null;
				}
			}
		}
	}
	
}