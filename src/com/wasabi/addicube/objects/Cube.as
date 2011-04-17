package com.wasabi.addicube.objects 
{
	import com.wasabi.addicube.data.CubeAnimation;
	import com.wasabi.addicube.data.CubeSpriteGroup;
	import com.wasabi.addicube.data.CubeState;
	import com.wasabi.addicube.data.Direction;
	import com.wasabi.addicube.data.Disposition;
	import com.wasabi.addicube.sound.SoundSet;
	import com.wasabi.addicube.states.PlayingState;
	import com.wasabi.addicube.Main;
	import com.wasabi.addicube.Utility;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class Cube extends GameObject
	{

		//[Embed(source = '../../../../../assets/cubes/neutral.cube.png')]
		[Embed(source = '../../../../../assets/cubes/test-Cube.png')]
		private static const GFX_CUBE : Class;
		
		//[Embed(source = '../../../../../assets/cubes/neutral.face.png')]
		[Embed(source = '../../../../../assets/cubes/test-Eyes.png')]
		private static const GFX_EYES : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.mouth.png')]
		private static const GFX_MOUTH : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.nose01.png')]
		private static const GFX_NOSE_01 : Class;
		
		[Embed(source = '../../../../../assets/cubes/neutral.nose02.png')]
		private static const GFX_NOSE_02 : Class;
		
		[Embed(source = '../../../../../assets/cubes/test-Details.png')]
		private static const GFX_DETAILS : Class;
		
		//	=============================================================================
		//	Constants
		//	=============================================================================
		
		public static const CUBE_HEALTH : Number = 450;
		
		public static const CUBE_SPRITE_SIZE : int = 100;
		
		//	Food related behaviors
		public static const FOOD_TO_SPLIT : int = 18;
		public static const FOOD_TO_GROW : int = 6;
						
		//	Cube size constants
		public static const SIZE_SMALL : Number = 0.5;
		public static const SIZE_MEDIUM : Number = 0.75;
		public static const SIZE_LARGE : Number = 1.0;
		
		private static const MOPING_TIME : Number = 2.0;
		private static const HOOVER_TIME : Number = 1.5;
		private static const CONFUSION_TIME : Number = 2.5;
		private static const CHEW_TIME : Number = 1.5;
		private static const STUN_TIME : Number = 3.0;
		
		//	=============================================================================
		//	Collision objects
		//	=============================================================================
		
		public var bodyCollider : CubeBodyCollider;
		public var baseCollider : FlxSprite;
		
		//	=============================================================================
		//	Food management
		//	=============================================================================
		
		public var targetFoodPoof : FoodPoof;
		public var foodPoofOrigin : FlxPoint;
		public var foodPoofTarget : FlxPoint;
		
		//	=============================================================================
		//	Chasing and seeking data
		//	=============================================================================
		
		public var targetPoint : FlxPoint;
		public var targetObject : GameObject;
		
		public var lookAtTarget : FlxPoint;
		
		//	=============================================================================
		//	Animation data
		//	=============================================================================
		
		public var currentAnimation : String;
		
		//	=============================================================================
		//	Sprites
		//	=============================================================================
		
		public var spriteGroup : CubeSpriteGroup;
		public var bodySprite : FlxSprite;
		public var faceSprite : FlxSprite;
		public var noseSprite : FlxSprite;
		public var backgroundNoseSprite : FlxSprite;
		
		private var noseGraphics : Class;
		
		private var debugText : FlxText;
		
		private var maxHealth : Number;
		
		//	=============================================================================
		//	Internal state
		//	=============================================================================
		
		/**
		 * The base state of the cube, from the CubeState class
		 */
		public var currentState : int;
		
		/**
		 * The direction the cube is facing, from the Direction class
		 */
		public var direction : int;
		
		/**
		 * The cube's disposition, from the Disposition class
		 */
		private var disposition : int;
		
		private var totalFoodConsumed : int;
		private var foodConsumed : Object;
		
		private var currentSize : Number;
		
		private var eatingClock : Number;
		private var mopingClock : Number;
		private var stunnedTime : Number;
		
		private var speed : Number;
		
		private var targetCube : Cube;
		private var dashDirection : FlxPoint;
		
		private var angerRadius : Number;
		private var envyRadius : Number;
		
		private var previousPosition : FlxPoint;
		
		public var followerCube : Cube;
		
		private var lastWalkBeatId : int;
		private var lastChewingBeatId : int;
		private var lastHooverBeatId : int;
		
		public function Cube() 
		{
			this.createGraphic(2, 2, 0x00FF0000);
			
			this.lastWalkBeatId = -1;
			this.lastChewingBeatId = -1;
			this.lastHooverBeatId = -1;
			
			this.mopingClock = 0;
			this.eatingClock = 0;
			this.stunnedTime = 0;
			this.speed = 100;
			this.angerRadius = 300;
			this.envyRadius = 300;
			
			this.totalFoodConsumed = 0;
			
			this.foodConsumed = new Object();
			this.foodConsumed[Disposition.RED] = 0;
			this.foodConsumed[Disposition.GREEN] = 0;
			this.foodConsumed[Disposition.BLUE] = 0;
			
			this.idleAnimationClock = 0;
			this.direction = Direction.SOUTH;
			
			this.targetPoint = new FlxPoint();
			this.targetCube = null;
			this.dashDirection = new FlxPoint();
			
			this.spriteGroup = new CubeSpriteGroup(this);
			
			this.noseGraphics = (FlxU.random() < 0.5 ? Cube.GFX_NOSE_01 : Cube.GFX_NOSE_02);
			this.noseGraphics = Cube.GFX_DETAILS;
			
			this.backgroundNoseSprite = new FlxSprite();
			this.backgroundNoseSprite.loadGraphic(this.noseGraphics, true, false,  Cube.CUBE_SPRITE_SIZE, Cube.CUBE_SPRITE_SIZE, false);
			this.spriteGroup.add(this.backgroundNoseSprite);
			
			this.bodySprite = new FlxSprite();
			this.bodySprite.loadGraphic(Cube.GFX_CUBE, true, false, Cube.CUBE_SPRITE_SIZE, Cube.CUBE_SPRITE_SIZE, false);
			this.spriteGroup.add(this.bodySprite);
			
			this.faceSprite = new FlxSprite();
			this.faceSprite.loadGraphic(Cube.GFX_EYES, true, false,  Cube.CUBE_SPRITE_SIZE, Cube.CUBE_SPRITE_SIZE, false);
			this.spriteGroup.add(this.faceSprite);
			
			this.noseSprite = new FlxSprite();
			this.noseSprite.loadGraphic(this.noseGraphics, true, false,  Cube.CUBE_SPRITE_SIZE, Cube.CUBE_SPRITE_SIZE, false);
			this.spriteGroup.add(this.noseSprite);
			
			this.debugText = new FlxText(0, 0, this.bodySprite.width, "Debug");
			this.debugText.y = this.bodySprite.height - this.debugText.height;
			if (Main.DEBUG) this.spriteGroup.add(this.debugText);
			
			this.bodyCollider = new CubeBodyCollider(0, 0, null);
			this.bodyCollider.cube = this;
			this.bodyCollider.createGraphic(this.bodySprite.width / 2, this.bodySprite.height / 2, 0x22FF0000);
			this.bodyCollider.solid = true;
			this.bodyCollider.fixed = false;
			if (Main.DEBUG) this.spriteGroup.add(this.bodyCollider);
			
			CubeAnimation.createAnimations();
			
			CubeAnimation.addAnimationsToSprite(this.bodySprite);
			CubeAnimation.addAnimationsToSprite(this.faceSprite, CubeAnimation.FRAMES_FACE);
			CubeAnimation.addAnimationsToSprite(this.noseSprite, CubeAnimation.FRAMES_NOSE);
			CubeAnimation.addAnimationsToSprite(this.backgroundNoseSprite, CubeAnimation.FRAMES_NOSE);
			
			this.setSize(Cube.SIZE_MEDIUM);
			this.setDisposition(Disposition.BLUE);
			
			this.health = this.maxHealth = Cube.CUBE_HEALTH;
			
			this.previousPosition = new FlxPoint();
			
			this.followerCube = null;
			
			this.setDirection(Direction.SOUTH);
			this.switchAnimation("Idle");
		}

		//	=============================================================================
		//	C'tor support functions
		//	=============================================================================
		
		//	=============================================================================
		//	Update functions
		//	=============================================================================
		
		override public function update():void 
		{
			this.previousPosition.x = this.bodySprite.x;
			this.previousPosition.y = this.bodySprite.y;
			
			super.update();
			
			this.health -= PlayingState.instance.petriDish.dirtiness * FlxG.elapsed;
			if (this.health <= 0)
			{
				this.kill();
			}
			
			/*if (this.followerCube != null)
			{
				if (this.followerCube.color += Disposition.GREEN)
				{
					this.setFollowerCube(null);
				}
			}*/
			
			if (this.targetCube != null)
			{
				if (
					this.disposition != Disposition.GREEN &&
					this.disposition != Disposition.RED
				)
				{
					this.targetCube.setFollowerCube(null);
					this.targetCube = null;
				}
			}
			
			if (
				this.targetFoodPoof == null &&
				(
					this.currentState == CubeState.EATING_START ||
					this.currentState == CubeState.EATING_HOOVER ||
					this.currentState == CubeState.EATING_CHEW
				)
			)
			{
				FlxG.log("Idle because of food poof loss");
				this.currentState = CubeState.IDLE;
				this.switchAnimation("Idle");
			}
			
			switch (this.currentState)
			{
				case CubeState.AVOIDING_OTHERS:
				case CubeState.CHARGING:
				case CubeState.CHASING:
				case CubeState.HEAD_BUTTING:
					this.updateHeadbutting();
					break;
				case CubeState.EATING_CHEW:
					this.updateEating();
					break;
				case CubeState.EATING_HOOVER:
					this.updateEating();
					break;
				case CubeState.EATING_START:
					this.updateEating();
					break;
				case CubeState.IDLE:
					this.updateIdle();
					break;
				case CubeState.IDLE_STUNNED:
					this.updateStunned();
					break;
				case CubeState.IDLE_MOPING:
					this.updateIdle();
					break;
				case CubeState.IDLE_CONFUSED:
					this.updateIdleConfused();
					break;
				case CubeState.MOVING:
					this.updateMoving();
					break;
				case CubeState.MOVING_TO_FOOD:
					this.updateMoving();
					break;
				default:
			}
						
			this.updateDebug();
			
			if (this.currentState == CubeState.MOVING && !PlayingState.instance.isPointInsideDish(this.center.x, this.center.y))
			{
				this.reset(
					this.previousPosition.x,
					this.previousPosition.y
				);
				
				FlxG.log("Idle because of dish boundary");
				this.currentState = CubeState.IDLE;
			}
		}
		
		public function updateDebug() : void
		{
			//this.debugText.text = "State: " + this.currentState + " / " + this.targetFoodPoof;
			this.debugText.text =
				"RGB: " +
				this.foodConsumed[Disposition.RED] + ", " +
				this.foodConsumed[Disposition.GREEN] + ", " +
				this.foodConsumed[Disposition.BLUE] + "\n" +
				"Anim: " + this.currentAnimation
			;
			
			if (FlxG.keys.justPressed("RIGHT"))
			{
				this.direction++;
				if (this.direction > Direction.MAX_VALUE)
				{
					this.direction = 0;
				}
				
				this.switchAnimation("Fidget");
			}
			
			if
			(
				this.disposition == Disposition.DEBUG_FACE_MOUSE &&
				this.currentState == CubeState.IDLE
			)
			{
				this.turnToFace(FlxG.mouse.x, FlxG.mouse.y);
			}
		}
		
		private var idleAnimationClock : Number;
		
		private function updateStunned() : void
		{
			if (this.currentAnimation != "Stunned")
			{
				this.switchAnimation("Stunned");
				this.stunnedTime = Cube.STUN_TIME;
			}
			
			this.stunnedTime -= FlxG.elapsed;
			
			if (this.stunnedTime <= 0)
			{
				FlxG.log("Idle because of end-of-stun time");
				this.currentState = CubeState.IDLE;
			}
		}
		
		private var confusedClock : Number = 0;
		
		public function updateIdleConfused() : void
		{
			this.setDirection(Direction.SOUTH);
			
			this.confusedClock += FlxG.elapsed;
			
			if (
				this.currentState == CubeState.IDLE_CONFUSED &&
				this.confusedClock >= Cube.CONFUSION_TIME &&
				this.bodySprite.finished
			)
			{
				this.lookAt(null);
				this.currentState = CubeState.IDLE;
				
				FlxG.log("Idle because of end-of-confusion");
				this.switchAnimation("Idle");
				return;
			}
			
			if (this.currentAnimation == "LookLeft")
			{
				if (this.bodySprite.finished) this.switchAnimation("LookCenterFromLeft");
			}
			else if (this.currentAnimation == "LookCenterFromLeft")
			{
				if (this.bodySprite.finished) this.switchAnimation("LookRight");
			}
			else if (this.currentAnimation == "LookRight")
			{
				if (this.bodySprite.finished) this.switchAnimation("LookCenterFromRight");
			}
			else 
			{
				this.switchAnimation("LookLeft");
			}
		}
		
		public function updateIdle() : void
		{
			this.setDirection(Direction.SOUTH);
			
			if (this.currentState == CubeState.IDLE_STUNNED)
			{
				this.switchAnimation("Stunned");
			}
			else
			{
				if (this.currentAnimation == "Idle" && this.lookAtTarget == null)
				{
					this.idleAnimationClock -= FlxG.elapsed;
					if (this.idleAnimationClock <= 0)
					{
						this.switchAnimation("Fidget");
					}
				}
				
				if (this.currentAnimation == "Fidget" && this.bodySprite.finished)
				{
					FlxG.log("Idle animation becasue of end-of-fidget");
					this.switchAnimation("Idle");
					this.idleAnimationClock = FlxU.random() * 3.0 + 1.0;
				}
			}
			
			if (this.currentState == CubeState.IDLE)
			{
				this.checkForFood();			
			}
			
			if (this.currentState == CubeState.IDLE_MOPING)
			{
				this.mopingClock += FlxG.elapsed;
				
				if (this.mopingClock >= Cube.MOPING_TIME)
				{
					this.findFood(Disposition.BLUE);
					this.mopingClock = 0;
				}
			}
			else if (this.currentState == CubeState.IDLE)
			{
				if (this.disposition == Disposition.BLUE)
				{
					this.mopingClock += FlxG.elapsed;
					
					if (this.mopingClock >= Cube.MOPING_TIME)
					{
						this.currentState = CubeState.IDLE_MOPING;
						this.mopingClock = 0;
					}
				}
			}
			
			if (
				!this.eating &&
				this.disposition == Disposition.RED &&
				this.currentState == CubeState.IDLE 
			)
			{
				this.findHeadbuttTarget();
			}
			
			if (
				!this.eating &&
				this.disposition == Disposition.GREEN &&
				this.currentState == CubeState.IDLE
			)
			{
				this.findFollowTarget();
			}
		}
		
		public function startEating(poof : FoodPoof) : void
		{
			if (this.targetFoodPoof != null) return;
			
			if (poof.ownerChain != null)
			{
				poof = poof.ownerChain.getHeadPoof();
				
				var d : Number = FlxPoint.distance(poof.center, this.center);
				
				if (d > 80)
				{
					this.moveTo(poof.center.x, poof.center.y);
					return;
				}
			}
			
			this.eatingClock = 0;
			
			this.targetFoodPoof = poof;
			this.targetFoodPoof.ownerCube = this;
			this.currentState = CubeState.EATING_START;
			this.foodPoofOrigin = new FlxPoint(poof.center.x, poof.center.y);
			this.foodPoofTarget = new FlxPoint(this.center.x, this.center.y);
			this.turnToFace(poof.center.x, poof.center.y);
		}
		
		public function relinquishFood() : void
		{
			FlxG.log("Relinquishing food: " + this.targetFoodPoof);
			
			if (this.targetFoodPoof != null)
			{
				//this.currentState = CubeState.IDLE;
				this.play("Idle");
				this.targetFoodPoof.visible = true;
				this.targetFoodPoof.ownerCube = null;
				this.targetFoodPoof = null;
				FlxG.log("Cube done relinquishing");
			}
		}
		
		public function relinquishSpecificFood(poof : FoodPoof) : void
		{
			if  (this.targetFoodPoof == poof)
			{
				this.relinquishFood();
			}
		}
		
		public function updateEating() : void 
		{
			var p : Number;
			
			if (this.currentState == CubeState.EATING_START)
			{
				if (this.currentAnimation != "StartSucking")
				{
					this.switchAnimation("StartSucking");
				}
				else if (this.bodySprite.finished)
				{
					this.currentState = CubeState.EATING_HOOVER;
					this.switchAnimation("Sucking");
				}
			}
			
			if (this.currentState == CubeState.EATING_HOOVER)
			{
				this.lastHooverBeatId = PlayingState.instance.currentSoundTrack.enqueueEventSound(
					"balanced", SoundSet.EVENT_HOOVER, this.lastHooverBeatId, 2
				);
				
				this.eatingClock += FlxG.elapsed;
				
				p = this.eatingClock / Cube.HOOVER_TIME;
				
				this.targetFoodPoof.x = (this.foodPoofTarget.x - this.foodPoofOrigin.x) * p + this.foodPoofOrigin.x - this.targetFoodPoof.width / 2;
				this.targetFoodPoof.y = (this.foodPoofTarget.y - this.foodPoofOrigin.y) * p + this.foodPoofOrigin.y - this.targetFoodPoof.height / 2;
				
				if (this.eatingClock >= Cube.HOOVER_TIME)
				{
					this.currentState = CubeState.EATING_CHEW;
					this.eatingClock = 0;
					this.targetFoodPoof.visible = false;
					this.switchAnimation("Chewing");
				}
			}
			
			if (this.currentState == CubeState.EATING_CHEW)
			{
				this.lastChewingBeatId = PlayingState.instance.currentSoundTrack.enqueueEventSound(
					"balanced", SoundSet.EVENT_CHEW, this.lastChewingBeatId, 2
				);
				
				this.eatingClock += FlxG.elapsed;
				
				if (this.eatingClock >= Cube.CHEW_TIME && this.targetFoodPoof != null)
				{
					var nextPoof : FoodPoof = null;
					var chain : FoodChain = null;
					
					chain = this.targetFoodPoof.ownerChain;
					
					this.addConsumedFood(this.targetFoodPoof.colorId);
					FlxG.log("TFP: " + this.targetFoodPoof);
					this.targetFoodPoof.kill();
					
					if (chain != null)
					{
						nextPoof = chain.getHeadPoof();
					}
					
					this.targetFoodPoof = null;
					
					if (nextPoof)
					{
						this.startEating(nextPoof);
					}
					else
					{
						this.currentState = CubeState.IDLE;
						this.switchAnimation("Idle");
						FlxG.log("Idle because of end-of-eating");
					}
				}
			}
		}
		
		private function updateHeadbutting() : void
		{
			var distanceToTarget : Number;
			var previousPosition : FlxPoint;
			
			this.updateMoving();
			
			//FlxG.log("headbutting: " + this.targetCube);
			
			if (this.targetCube != null)
			{
				if (this.bodyCollider.overlaps(this.targetCube.bodyCollider))
				{
					previousPosition = new FlxPoint(this.targetCube.x, this.targetCube.y);
					
					this.targetCube.reset(
						this.targetCube.x + 20 * this.dashDirection.x,
						this.targetCube.y + 20 * this.dashDirection.y
					);
					
					//FlxG.log("Hit target cube");
					
					if (!PlayingState.instance.isPointInsideDish(this.targetCube.center.x, this.targetCube.center.y))
					{
						this.targetCube.reset(previousPosition.x, previousPosition.y);
					}
					
					//FlxG.log("dashdir: " + this.dashDirection);
					var o : FlxPoint = new FlxPoint();
					var d : Number;
					var dds : FlxPoint = new FlxPoint();
					
					o.x = 6 * this.dashDirection.x;
					o.y = 6 * this.dashDirection.y;
					
					//FlxG.log("Offset: " + o);
					
					d = 5 + this.bodyCollider.width / 2 + this.targetCube.bodyCollider.width / 2;
					
					dds.x = (this.dashDirection.x < 0 ? -1 : 1);
					dds.y = (this.dashDirection.y < 0 ? -1 : 1);
					
					o.x = this.targetCube.center.x - d * (this.dashDirection.x);
					o.y = this.targetCube.center.y - d * (this.dashDirection.y);
					
					this.center = o;
					
					this.currentState = CubeState.IDLE;
					//FlxG.log("Idle because of end-of-headbutting");
					
					this.targetCube.stun();
					this.targetCube = null;
				}
			}
		}
		
		private function updateMoving() : void
		{
			var toTarget : FlxPoint;
			var distance : Number;
			
			this.lastWalkBeatId = PlayingState.instance.currentSoundTrack.enqueueEventSound(
				"balanced", SoundSet.EVENT_WALK, this.lastWalkBeatId
			);
			
			if (this.currentAnimation == "StartWalk" && this.bodySprite.finished)
			{
				this.switchAnimation("Walk");
			}
			
			if (this.currentAnimation == "StartCharging" && this.bodySprite.finished)
			{
				this.switchAnimation("Charging");
			}
			
			toTarget = new FlxPoint(
				this.targetPoint.x - this.center.x,
				this.targetPoint.y - this.center.y
			);
			
			distance = toTarget.length();
			
			if (distance < 10)
			{
				this.lookAt(null);
				
				if (!this.checkForFood())
				{
					this.confusedClock = 0.0;
					this.currentState = CubeState.IDLE_CONFUSED;
					this.switchAnimation("LookLeft");
				}
			}
			else
			{
				toTarget = FlxPoint.normalizeWithDistance(toTarget, distance);
				
				this.reset(
					x + toTarget.x * FlxG.elapsed * this.speed,
					y + toTarget.y * FlxG.elapsed * this.speed
				);
				this.turnToFacePoint(this.targetPoint);
			}
		}
		
		public function setSize(s : Number) : void
		{
			this.currentSize = s;
			
			for (var i : int = 0; i < this.spriteGroup.members.length; i++)
			{
				this.spriteGroup.members[i].antialiasing = true;
				this.spriteGroup.members[i].scale = new FlxPoint(this.currentSize, this.currentSize);
			}
			
			this.debugText.scale.x = this.debugText.scale.y = 1.0;
			
			this.bodyCollider.createGraphic(
				this.bodySprite.width * this.bodySprite.scale.x / 1.8,
				this.bodySprite.height * this.bodySprite.scale.y / 1.8, 0x22FF0000
			);
			this.bodyCollider.scale.x = this.bodyCollider.scale.y = 1;
			this.bodyCollider.reset(
				this.center.x - this.bodyCollider.width / 2,
				this.center.y - this.bodyCollider.height / 2
			);
		}
		
		public function set currentDisposition(d : int) : void
		{
			this.setDisposition(d);
		}
		
		public function get currentDisposition() : int
		{
			return this.disposition;
		}
		
		public function setDisposition(d : int) : void
		{
			this.disposition = d;
			
			this.bodySprite.color = Disposition.TINT_COLOR[this.disposition];
			this.noseSprite.color = Disposition.TINT_COLOR[this.disposition];
			this.backgroundNoseSprite.color = Disposition.TINT_COLOR[this.disposition];
			
			if (this.disposition == Disposition.BLUE)
			{
				this.speed = 60;
			}
			else
			{
				this.speed = 100;
			}
		}
		
		//	=============================================================================
		//	Animation support functions
		//	=============================================================================
		
		public function turnToFace(x : int, y : int) : void
		{
			var facing : Number;
			var facingDegress : Number;
			var adjustedFacingDegress : Number;
			var facingId : int;
			
			facing = Math.atan2(
				y - this.center.y,
				x - this.center.x
			);
			facingDegress = Utility.RadiansToDegrees(facing);
			if (facingDegress < 0) facingDegress += 360;
			
			adjustedFacingDegress = facingDegress - 22.5;
			facingId = ((adjustedFacingDegress / 45) + 1) % 8;
			
			this.setDirection(facingId);
		}
		
		public function turnToFacePoint(p : FlxPoint) : void
		{
			this.turnToFace(p.x, p.y);
		}
		
		public function moveTo(x : int, y : int) : void
		{
			/*if (this.disposition == Disposition.BLUE && this.currentState == CubeState.IDLE_MOPING)
			{
				return;
			}*/
			
			this.currentState = CubeState.MOVING;
			this.targetPoint.x = x;
			this.targetPoint.y = y;
			
			this.switchAnimation("StartWalk");
		}
		
		public function lookAt(p : FlxPoint) : void
		{
			if (p == null)
			{
				this.lookAtTarget = null;
				if (this.currentState == CubeState.IDLE) this.switchAnimation("Idle");
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
		
		/**
		 * Changes the currently playing animation
		 * @param	animation	The name of the new animation to play
		 * @param	restart		Whether or not to restart the animation from frame 0 when switching 
		 */
		public function switchAnimation(animation : String, restart : Boolean = true) : void
		{
			var i : int;
			
			this.currentAnimation = animation;		
			
			for (i = 0; i < this.spriteGroup.members.length; i++)
			{
				this.spriteGroup.members[i].play(animation + this.direction);
			}
		}
		
		private function setDirection(newDirection : int) : void
		{
			/*
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
			*/
			
			//	Set the animation to correspond to the direction the cube is facing
			if (this.direction != newDirection)
			{
				var currentFrame : int = this.spriteGroup.members[0].frame;
				
				this.direction = newDirection;
				this.adjustAnimationForDirection();
			}
		}
		
		private function adjustAnimationForDirection() : void
		{
			var i : int;
			
			for (i = 0; i < this.spriteGroup.members.length; i++)
			{
				this.spriteGroup.members[i].playWithoutInterruption(this.currentAnimation + this.direction);
			}
			
			if (
				this.direction == Direction.SOUTHEAST ||
				this.direction == Direction.SOUTH ||
				this.direction == Direction.SOUTHWEST
			)
			{
				this.faceSprite.visible = true;
			}
			else
			{
				this.faceSprite.visible = false;
			}
			
			if (
				this.direction == Direction.WEST ||
				this.direction == Direction.EAST || 
				this.direction == Direction.SOUTHEAST ||
				this.direction == Direction.SOUTH ||
				this.direction == Direction.SOUTHWEST
			)
			{
				if (
					this.direction == Direction.WEST || 
					this.direction == Direction.EAST
				)
				{
					this.noseSprite.visible = false;
					this.backgroundNoseSprite.visible = true;
				}
				else
				{
					this.noseSprite.visible = true;
					this.backgroundNoseSprite.visible = false;
				}
			}
			else
			{
				this.noseSprite.visible = false;
				this.backgroundNoseSprite.visible = false;
			}
			
		}
		
		public function get eating() : Boolean
		{
			return (
				this.currentState == CubeState.EATING_CHEW ||
				this.currentState == CubeState.EATING_HOOVER ||
				this.currentState == CubeState.EATING_START ||
				this.targetFoodPoof != null
			);
		}
		
		//	=============================================================================
		//	Position information
		//	=============================================================================
		
		override public function get center() : FlxPoint
		{ 
			return new FlxPoint(
				this.spriteGroup.members[0].x + this.spriteGroup.members[0].width / 2,
				this.spriteGroup.members[0].y + this.spriteGroup.members[0].height / 2
			);
		}
		
		override public function set center(p : FlxPoint) : void 
		{
			this.reset(
				p.x - this.spriteGroup.members[0].width / 2,
				p.y - this.spriteGroup.members[0].height / 2
			);
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			
			this.spriteGroup.reset(X, Y);
			
			this.bodyCollider.reset(
				this.center.x - this.bodyCollider.width / 2,
				this.center.y - this.bodyCollider.height / 2
			);
		}
		
		private function modifyDisposition() : void
		{
			var min : int;
			var max : int;
			
			var minD : int;
			var maxD : int;
			
			max = min = this.foodConsumed[Disposition.RED];
			minD = maxD = Disposition.RED;	
			
			if (this.foodConsumed[Disposition.GREEN] < min)
			{
				min = this.foodConsumed[Disposition.GREEN];
				minD = Disposition.GREEN;
			}
			if (this.foodConsumed[Disposition.GREEN] > max)
			{
				max = this.foodConsumed[Disposition.GREEN];
				maxD = Disposition.GREEN;
			}
			
			if (this.foodConsumed[Disposition.BLUE] < min)
			{
				min = this.foodConsumed[Disposition.BLUE];
				minD = Disposition.BLUE;
			}
			if (this.foodConsumed[Disposition.BLUE] > max)
			{
				max = this.foodConsumed[Disposition.BLUE];
				maxD = Disposition.BLUE;
			}
			
			if (max - min >= 2)
			{
				this.setDisposition(maxD);
			}
			else
			{
				this.setDisposition(Disposition.BALANCED);
			}
			
			//	Reset food balance counters after growth
			this.foodConsumed[Disposition.BLUE] = 0;
			this.foodConsumed[Disposition.RED] = 0;
			this.foodConsumed[Disposition.GREEN] = 0;
		}
		
		public function addConsumedFood(color : int, amount : int = 1) : void
		{
			var splitDelta : FlxPoint;
			
			this.totalFoodConsumed += amount;
			this.foodConsumed[color] += amount;
			this.health = this.maxHealth;
			
			if (this.currentSize == Cube.SIZE_SMALL && this.totalFoodConsumed >= Cube.FOOD_TO_GROW)
			{
				this.setSize(Cube.SIZE_MEDIUM);
				this.modifyDisposition();
			}
			else if (this.currentSize == Cube.SIZE_MEDIUM && this.totalFoodConsumed >= Cube.FOOD_TO_GROW * 2)
			{
				this.setSize(Cube.SIZE_LARGE);
				this.modifyDisposition();
			}
			else if (this.currentSize == Cube.SIZE_LARGE && this.totalFoodConsumed >= Cube.FOOD_TO_SPLIT)
			{
				this.setSize(Cube.SIZE_SMALL);
				this.totalFoodConsumed = 0;
				this.foodConsumed[Disposition.RED] = 0;
				this.foodConsumed[Disposition.GREEN] = 0;
				this.foodConsumed[Disposition.BLUE] = 0;
				
				var cube : Cube;
				
				this.reset(this.center.x - 60 - this.bodySprite.width / 2, this.y);
				this.switchAnimation("Idle");
				this.setDirection(Direction.SOUTH);
				this.currentState = CubeState.IDLE;
				//	TODO: Need to indicate that the cube has split to force food to be
				//	relinquished later in the updateEating method
				
				cube = new Cube();
				cube.reset(this.center.x + 60 - this.bodySprite.width / 2, this.y);
				cube.setSize(Cube.SIZE_SMALL);
				cube.setDisposition(this.disposition);
				PlayingState.instance.addCube(cube, true);
				cube.switchAnimation("Idle");
				cube.setDirection(Direction.SOUTH);
				
				if (!PlayingState.instance.isPointInsideDish(this.center.x, this.center.y))
				{
					splitDelta = this.moveIntoDish();
					cube.x += splitDelta.x;
					cube.y += splitDelta.y;
				}
				else if (!PlayingState.instance.isPointInsideDish(cube.center.x, cube.center.y))
				{
					splitDelta = this.moveIntoDish();
					this.x += splitDelta.x;
					this.y += splitDelta.y;
				}
			}
		}
		
		public function findFood(foodColorId : int) : Boolean
		{
			var poof : FoodPoof;
			
			poof = PlayingState.instance.getClosestFoodPoof(this.center, Number.MAX_VALUE, foodColorId);
			
			if (poof == null)
			{
				return false;
			}
			
			this.moveTo(poof.center.x, poof.center.y);
			return true;
		}

		public function checkForFood() : Boolean
		{
			var group : FlxGroup;
			var i : int;
			var length : int;
			var poof : FoodPoof;
			var bestY : Number;
			var bestPoof : FoodPoof;
			
			if (PlayingState.instance.tutorial.currentStepBlocksEating && PlayingState.instance.tutorialTextIsVisible) return false;
			
			bestY = -10000;
			bestPoof = null;
			
			group = PlayingState.instance.foodPoofGroup;
			length = group.members.length;
			
			for (i = 0; i < length; i++)
			{
				poof = group.members[i] as FoodPoof;
				
				if (!poof.isReady || poof.ownerCube != null) continue;
				
				if (this.bodyCollider.overlaps(poof))
				{
					if (poof.y >= bestY)
					{
						bestPoof = poof;
						bestY = poof.y;
					}
				}
			}
			
			if (
				bestPoof != null &&
				(bestPoof.ownerChain == null || bestPoof.ownerChain != PlayingState.instance.currentTweezerChain)
			)
			{
				if (
					this.followerCube != null &&
					this.followerCube.targetFoodPoof == null &&
					this.followerCube.currentState != CubeState.IDLE_CONFUSED
				)
				{
					var d : Number;
					
					d = FlxPoint.distance(this.center, this.followerCube.center);
					
					if (d < 150)
					{
						this.followerCube.startEating(bestPoof);
						return true;
					}
				}
				
				this.startEating(bestPoof);
				return true;
			}
			
			return false;
		}
		
		public function stun() : void
		{
			this.relinquishFood();
			
			/*
			if (this.targetFoodPoof != null)
			{
				this.targetFoodPoof.ownerCube = null;
				this.targetFoodPoof = null;
			}
			*/
			
			this.currentState = CubeState.IDLE_STUNNED;
			this.stunnedTime = Cube.STUN_TIME;
			this.setDirection(Direction.SOUTH);
		}
		
		public function findHeadbuttTarget() : void
		{
			var cube : Cube;
			
			cube = PlayingState.instance.getClosestCube(this.center, this, true);
			
			this.targetCube = cube;
			//FlxG.log("Going to headbut: " + cube);
			
			if (this.targetCube != null)
			{
				this.dashDirection.x = this.targetCube.center.x - this.center.x;
				this.dashDirection.y = this.targetCube.center.y - this.center.y;
				
				if (FlxPoint.distance(this.center, this.targetCube.center) < this.angerRadius)
				{
					this.targetPoint = this.targetCube.center;
					this.dashDirection = FlxPoint.normalize(this.dashDirection);
					this.currentState = CubeState.HEAD_BUTTING;
					this.switchAnimation("StartCharging");
				}
				else
				{
					this.currentState = CubeState.IDLE;
					this.switchAnimation("Idle");
				}
			}
			else
			{
				this.currentState = CubeState.IDLE;
				this.switchAnimation("Idle");
			}
		}
		
		public function findFollowTarget() : void
		{
			var cube : Cube;
			
			cube = PlayingState.instance.getClosestCube(this.center, this, true);
			
			if (cube == null)
			{
				this.targetCube = null;
				return;
			}
			
			if (FlxPoint.distance(this.center, cube.center) < this.envyRadius)
			{
				if (this.targetCube != null)
				{
					this.targetCube.setFollowerCube(null);
				}
				
				this.targetCube = cube;
				
				if (cube != null)
				{
					this.targetCube = cube;
					this.targetCube.setFollowerCube(this);
					this.moveTo(this.targetCube.center.x, this.targetCube.center.y);
				}
			}
		}
		
		override public function kill():void 
		{
			PlayingState.instance.removeCube(this);
			
			super.kill();
			
			var i : int;
			
			for (i = 0; i < this.spriteGroup.members.length; i++)
			{
				this.spriteGroup.members[i].kill();
			}
		}
		
		public function setFollowerCube(c : Cube) : void
		{
			this.followerCube = c;
		}
		
		public function get movementDelta() : FlxPoint
		{
			return new FlxPoint(
				this.bodySprite.x - this.previousPosition.x,
				this.bodySprite.y - this.previousPosition.y
			);
		}
		
		public function moveIntoDish() : FlxPoint
		{
			var p : FlxPoint = new FlxPoint();
			var dx : int;
			var dy : int;
			
			while (!PlayingState.instance.isPointInsideDish(this.center.x, this.center.y))
			{
				dx = dy = 0;
				
				if (this.x > PlayingState.instance.petriDish.center.x) { dx = -2; p.x -= 2; }
				else if (this.x < PlayingState.instance.petriDish.center.x) { dx = 2; p.x += 2; }
				
				if (this.y > PlayingState.instance.petriDish.center.y) { dy = -2; p.y -= 2; }
				else if (this.y < PlayingState.instance.petriDish.center.y) { dy += 2; p.y += 2 }
				
				this.reset(this.x + dx, this.y + dy);
			}
			
			return p;
		}
	}
	
}