package com.wasabi.addicube.data 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Charles Berube
	 */
	public class CubeAnimation 
	{
		
		//	Constants for offsets into the animationList array (defined below)
		//	Name, Frames, FrameRate, Loops?, FrameListCache
		private static const ALI_NAME : int = 0;
		private static const ALI_FRAMES : int = 1;
		private static const ALI_FRAME_RATE : int = 2;
		private static const ALI_LOOP : int = 3;
		private static const ALI_CACHE : int = 4;
		
		public static const FRAMES_STANDARD : int = 0;
		public static const FRAMES_NOSE : int = 1;
		public static const FRAMES_FACE : int = 2;
		
		//private static const FRAMES_PER_ROW : int = 33;
		private static const FRAMES_PER_ROW : int = 71;
		private static const FACE_ANIMATION_OFFSET : int = 0 * CubeAnimation.FRAMES_PER_ROW;
		private static const NOSE_ANIMATION_OFFSET : int = 0 * CubeAnimation.FRAMES_PER_ROW;
		
		//	Defines animations for the cube:
		//	[ Name, [ frames, ... ], FrameRate, Loops?, [ frame cache ] ]
		private static var animationList : Array =
		[
			/*
			[ "Idle", [ 0 ], 1, true, [ ] ],
			[ "Fidget", [ 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3 ], 8, true, [ ] ],
			[ "StartWalk", [ 21, 22, 23 ], 12, false, [ ] ],
			[ "Walk", [ 24, 25, 26, 27, 28, 29, 30, 31, 32 ], 12, true, [ ] ],
			[ "StartSucking", [ 15, 16, 17, 18 ], 12, false, [ ] ],
			[ "Sucking", [ 18 ], 12, true, [ ] ],
			[ "StopSucking", [ 19, 20 ], 12, false, [ ] ],
			[ "LookRight", [ 12, 13, 14 ], 8, false, [ ] ],
			[ "LookLeft", [ 9, 10, 11 ], 8, false, [ ] ],
			[ "LookCenterFromRight", [ 14, 13, 12 ], 8, false, [ ] ],
			[ "LookCenterFromLeft", [ 11, 10, 9 ], 8, false, [ ] ],
			*/
			[ "Idle", [ 0 ], 1, true, [ ] ],
			[ "Stunned", [ 0 ], 1, true, [ ] ],
			[ "Fidget", [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 ], 16, false, [ ] ],
			[ "StartWalk", [ 56, 57, 58, 59, 60, 61 ], 24, false, [ ] ],
			[ "Walk", [ 62, 63, 64, 65, 66, 67, 68, 69, 70 ], 24, true, [ ] ],
			[ "StartCharging", [ 56, 57, 58, 59, 60, 61 ], 24, false, [ ] ],
			[ "Charging", [ 62, 63, 64, 65, 66, 67, 68, 69, 70 ], 24, true, [ ] ],
			[ "StartSucking", [ 30, 31, 32, 33, 34 ], 12, false, [ ] ],
			[ "Sucking", [ 35, 36, 37, 38, 39 ], 12, true, [ ] ],
			[ "StopSucking", [ 40, 41, 42, 43, 44, 45 ], 12, false, [ ] ],
			[ "LookLeft", [ 18, 19, 20, 21, 22, 23 ], 8, false, [ ] ],
			[ "LookRight", [ 24, 25, 26, 27, 28, 29 ], 8, false, [ ] ],
			[ "LookCenterFromLeft", [ 23, 22, 21, 20, 19, 18 ], 8, false, [ ] ],
			[ "LookCenterFromRight", [ 28, 27, 26, 25, 24 ], 8, false, [ ] ],
			[ "Chewing", [ 46, 47, 48, 49, 50, 51, 52, 53, 54, 55 ], 16, true, [ ] ],
		];
		
		private static var animationsExist : Boolean = false;
		
		public static function createAnimations() : void
		{
			if (CubeAnimation.animationsExist) return;
			
			var i : int;
			var facingId : int;
			var animationId : int;
			
			var animationsLength : int = CubeAnimation.animationList.length;
			var facingCount : int = Direction.MAX_VALUE;
			
			var baseFrame : int;
			
			var frames : Array;
			var noseFrames : Array;
			var faceFrames : Array;
			
			for (animationId = 0; animationId < animationsLength; animationId++)
			{
				for (facingId = 0; facingId <= facingCount; facingId++)
				{
					baseFrame = facingId * CubeAnimation.FRAMES_PER_ROW /*+ Cube.animationList[animationId][1]*/;
					
					//	Build the array of frames for the animation
					frames = new Array();
					noseFrames = new Array();
					faceFrames = new Array();
					
					for (i = 0; i < CubeAnimation.animationList[animationId][CubeAnimation.ALI_FRAMES].length; i++)
					{
						frames.push(CubeAnimation.animationList[animationId][CubeAnimation.ALI_FRAMES][i] + baseFrame);
						noseFrames.push(CubeAnimation.animationList[animationId][CubeAnimation.ALI_FRAMES][i] + baseFrame - CubeAnimation.NOSE_ANIMATION_OFFSET);
						faceFrames.push(CubeAnimation.animationList[animationId][CubeAnimation.ALI_FRAMES][i] + baseFrame - CubeAnimation.FACE_ANIMATION_OFFSET);
					}
					
					CubeAnimation.animationList[animationId][CubeAnimation.ALI_CACHE][facingId] = [
						frames, noseFrames, faceFrames
					];						
				}
			}
		}
		
		public static function addAnimationsToSprite(sprite : FlxSprite, frameSet : int = CubeAnimation.FRAMES_STANDARD) : void
		{
			var animationId : int;
			var facingId : int;
			
			var animationsLength : int = CubeAnimation.animationList.length;
			var facingCount : int = Direction.MAX_VALUE;
			
			var animationName : String;
			var frameRate : int;
			var loops : Boolean;
			var frames : Array;

			for (animationId = 0; animationId < animationsLength; animationId++)
			{
				for (facingId = 0; facingId <= facingCount; facingId++)
				{
					animationName = CubeAnimation.animationList[animationId][CubeAnimation.ALI_NAME] + facingId;
					frameRate = CubeAnimation.animationList[animationId][CubeAnimation.ALI_FRAME_RATE];
					loops = CubeAnimation.animationList[animationId][CubeAnimation.ALI_LOOP];
					frames = CubeAnimation.animationList[animationId][CubeAnimation.ALI_CACHE][facingId][frameSet];
					
					sprite.addAnimation(
						animationName,
						frames,
						frameRate,
						loops
					);
				}
			}
		}
		
		public function CubeAnimation() 
		{		
		}
		
	}
	
}