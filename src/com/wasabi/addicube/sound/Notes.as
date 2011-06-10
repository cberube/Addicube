package com.wasabi.addicube.sound 
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Charles Berube (The Wasabi Project)
	 */
	public class Notes
	{
		
		public static const SHIFT_PITCH : uint = 0;
		public static const SHIFT_LENGTH : uint = 3;
		public static const SHIFT_GROUP : uint = 6;
		public static const SHIFT_PAN : uint = 9;
		public static const SHIFT_VOLUME : uint = 11;
		public static const SHIFT_SILENCE : uint = 15;
		
		public static const MASK_PITCH  		: uint = 0x7 << Notes.SHIFT_PITCH;
		public static const MASK_LENGTH 		: uint = 0x7 << Notes.SHIFT_LENGTH;
		public static const MASK_GROUP  		: uint = 0x7 << Notes.SHIFT_GROUP;
		public static const MASK_PAN			: uint = 0x3 << Notes.SHIFT_PAN;
		public static const MASK_VOLUME 		: uint = 0xF << Notes.SHIFT_VOLUME;
		public static const MASK_SILENCE		: uint = 0x1 << Notes.SHIFT_SILENCE;
		
		public static const MASK_ALL_NOTE_DATA	: uint = SoundBuffer.MAX_EMPTY_COUNT;
		
		[Embed(source = '../../../../../assets/audio/notes/a1-0.mp3')]
		public static const A_1_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a1-1.mp3')]
		public static const A_1_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a1-2.mp3')]
		public static const A_1_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a1-3.mp3')]
		public static const A_1_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a1-4.mp3')]
		public static const A_1_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a1-5.mp3')]
		public static const A_1_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-0.mp3')]
		public static const A_2_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-1.mp3')]
		public static const A_2_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-2.mp3')]
		public static const A_2_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-3.mp3')]
		public static const A_2_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-4.mp3')]
		public static const A_2_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a2-5.mp3')]
		public static const A_2_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-0.mp3')]
		public static const A_4_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-1.mp3')]
		public static const A_4_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-2.mp3')]
		public static const A_4_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-3.mp3')]
		public static const A_4_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-4.mp3')]
		public static const A_4_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a4-5.mp3')]
		public static const A_4_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-0.mp3')]
		public static const A_8_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-1.mp3')]
		public static const A_8_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-2.mp3')]
		public static const A_8_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-3.mp3')]
		public static const A_8_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-4.mp3')]
		public static const A_8_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a8-5.mp3')]
		public static const A_8_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-0.mp3')]
		public static const A_16_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-1.mp3')]
		public static const A_16_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-2.mp3')]
		public static const A_16_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-3.mp3')]
		public static const A_16_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-4.mp3')]
		public static const A_16_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a16-5.mp3')]
		public static const A_16_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-0.mp3')]
		public static const A_32_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-1.mp3')]
		public static const A_32_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-2.mp3')]
		public static const A_32_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-3.mp3')]
		public static const A_32_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-4.mp3')]
		public static const A_32_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/a32-5.mp3')]
		public static const A_32_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-0.mp3')]
		public static const B_1_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-1.mp3')]
		public static const B_1_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-2.mp3')]
		public static const B_1_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-3.mp3')]
		public static const B_1_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-4.mp3')]
		public static const B_1_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b1-5.mp3')]
		public static const B_1_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-0.mp3')]
		public static const B_2_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-1.mp3')]
		public static const B_2_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-2.mp3')]
		public static const B_2_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-3.mp3')]
		public static const B_2_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-4.mp3')]
		public static const B_2_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b2-5.mp3')]
		public static const B_2_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-0.mp3')]
		public static const B_4_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-1.mp3')]
		public static const B_4_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-2.mp3')]
		public static const B_4_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-3.mp3')]
		public static const B_4_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-4.mp3')]
		public static const B_4_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b4-5.mp3')]
		public static const B_4_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-0.mp3')]
		public static const B_8_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-1.mp3')]
		public static const B_8_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-2.mp3')]
		public static const B_8_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-3.mp3')]
		public static const B_8_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-4.mp3')]
		public static const B_8_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b8-5.mp3')]
		public static const B_8_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-0.mp3')]
		public static const B_16_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-1.mp3')]
		public static const B_16_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-2.mp3')]
		public static const B_16_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-3.mp3')]
		public static const B_16_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-4.mp3')]
		public static const B_16_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b16-5.mp3')]
		public static const B_16_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-0.mp3')]
		public static const B_32_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-1.mp3')]
		public static const B_32_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-2.mp3')]
		public static const B_32_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-3.mp3')]
		public static const B_32_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-4.mp3')]
		public static const B_32_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/b32-5.mp3')]
		public static const B_32_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-0.mp3')]
		public static const G_1_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-1.mp3')]
		public static const G_1_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-2.mp3')]
		public static const G_1_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-3.mp3')]
		public static const G_1_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-4.mp3')]
		public static const G_1_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g1-5.mp3')]
		public static const G_1_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-0.mp3')]
		public static const G_2_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-1.mp3')]
		public static const G_2_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-2.mp3')]
		public static const G_2_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-3.mp3')]
		public static const G_2_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-4.mp3')]
		public static const G_2_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g2-5.mp3')]
		public static const G_2_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-0.mp3')]
		public static const G_4_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-1.mp3')]
		public static const G_4_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-2.mp3')]
		public static const G_4_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-3.mp3')]
		public static const G_4_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-4.mp3')]
		public static const G_4_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g4-5.mp3')]
		public static const G_4_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-0.mp3')]
		public static const G_8_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-1.mp3')]
		public static const G_8_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-2.mp3')]
		public static const G_8_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-3.mp3')]
		public static const G_8_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-4.mp3')]
		public static const G_8_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g8-5.mp3')]
		public static const G_8_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-0.mp3')]
		public static const G_16_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-1.mp3')]
		public static const G_16_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-2.mp3')]
		public static const G_16_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-3.mp3')]
		public static const G_16_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-4.mp3')]
		public static const G_16_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g16-5.mp3')]
		public static const G_16_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-0.mp3')]
		public static const G_32_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-1.mp3')]
		public static const G_32_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-2.mp3')]
		public static const G_32_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-3.mp3')]
		public static const G_32_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-4.mp3')]
		public static const G_32_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/g32-5.mp3')]
		public static const G_32_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-0.mp3')]
		public static const N_1_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-1.mp3')]
		public static const N_1_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-2.mp3')]
		public static const N_1_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-3.mp3')]
		public static const N_1_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-4.mp3')]
		public static const N_1_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n1-5.mp3')]
		public static const N_1_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-0.mp3')]
		public static const N_2_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-1.mp3')]
		public static const N_2_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-2.mp3')]
		public static const N_2_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-3.mp3')]
		public static const N_2_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-4.mp3')]
		public static const N_2_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n2-5.mp3')]
		public static const N_2_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-0.mp3')]
		public static const N_4_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-1.mp3')]
		public static const N_4_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-2.mp3')]
		public static const N_4_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-3.mp3')]
		public static const N_4_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-4.mp3')]
		public static const N_4_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n4-5.mp3')]
		public static const N_4_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-0.mp3')]
		public static const N_8_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-1.mp3')]
		public static const N_8_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-2.mp3')]
		public static const N_8_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-3.mp3')]
		public static const N_8_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-4.mp3')]
		public static const N_8_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n8-5.mp3')]
		public static const N_8_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-0.mp3')]
		public static const N_16_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-1.mp3')]
		public static const N_16_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-2.mp3')]
		public static const N_16_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-3.mp3')]
		public static const N_16_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-4.mp3')]
		public static const N_16_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n16-5.mp3')]
		public static const N_16_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-0.mp3')]
		public static const N_32_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-1.mp3')]
		public static const N_32_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-2.mp3')]
		public static const N_32_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-3.mp3')]
		public static const N_32_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-4.mp3')]
		public static const N_32_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/n32-5.mp3')]
		public static const N_32_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-0.mp3')]
		public static const T_1_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-1.mp3')]
		public static const T_1_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-2.mp3')]
		public static const T_1_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-3.mp3')]
		public static const T_1_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-4.mp3')]
		public static const T_1_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t1-5.mp3')]
		public static const T_1_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-0.mp3')]
		public static const T_2_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-1.mp3')]
		public static const T_2_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-2.mp3')]
		public static const T_2_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-3.mp3')]
		public static const T_2_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-4.mp3')]
		public static const T_2_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t2-5.mp3')]
		public static const T_2_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-0.mp3')]
		public static const T_3_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-1.mp3')]
		public static const T_3_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-2.mp3')]
		public static const T_3_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-3.mp3')]
		public static const T_3_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-4.mp3')]
		public static const T_3_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t3-5.mp3')]
		public static const T_3_5 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-0.mp3')]
		public static const T_4_0 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-1.mp3')]
		public static const T_4_1 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-2.mp3')]
		public static const T_4_2 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-3.mp3')]
		public static const T_4_3 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-4.mp3')]
		public static const T_4_4 : Class;

		[Embed(source = '../../../../../assets/audio/notes/t4-5.mp3')]
		public static const T_4_5 : Class;

		public static var soundMap : Object = {
			"0": A_1_0,
			"1": A_1_1,
			"2": A_1_2,
			"3": A_1_3,
			"4": A_1_4,
			"5": A_1_5,
			"8": A_2_0,
			"9": A_2_1,
			"10": A_2_2,
			"11": A_2_3,
			"12": A_2_4,
			"13": A_2_5,
			"16": A_4_0,
			"17": A_4_1,
			"18": A_4_2,
			"19": A_4_3,
			"20": A_4_4,
			"21": A_4_5,
			"24": A_8_0,
			"25": A_8_1,
			"26": A_8_2,
			"27": A_8_3,
			"28": A_8_4,
			"29": A_8_5,
			"32": A_16_0,
			"33": A_16_1,
			"34": A_16_2,
			"35": A_16_3,
			"36": A_16_4,
			"37": A_16_5,
			"40": A_32_0,
			"41": A_32_1,
			"42": A_32_2,
			"43": A_32_3,
			"44": A_32_4,
			"45": A_32_5,
			"64": B_1_0,
			"65": B_1_1,
			"66": B_1_2,
			"67": B_1_3,
			"68": B_1_4,
			"69": B_1_5,
			"72": B_2_0,
			"73": B_2_1,
			"74": B_2_2,
			"75": B_2_3,
			"76": B_2_4,
			"77": B_2_5,
			"80": B_4_0,
			"81": B_4_1,
			"82": B_4_2,
			"83": B_4_3,
			"84": B_4_4,
			"85": B_4_5,
			"88": B_8_0,
			"89": B_8_1,
			"90": B_8_2,
			"91": B_8_3,
			"92": B_8_4,
			"93": B_8_5,
			"96": B_16_0,
			"97": B_16_1,
			"98": B_16_2,
			"99": B_16_3,
			"100": B_16_4,
			"101": B_16_5,
			"104": B_32_0,
			"105": B_32_1,
			"106": B_32_2,
			"107": B_32_3,
			"108": B_32_4,
			"109": B_32_5,
			"128": G_1_0,
			"129": G_1_1,
			"130": G_1_2,
			"131": G_1_3,
			"132": G_1_4,
			"133": G_1_5,
			"136": G_2_0,
			"137": G_2_1,
			"138": G_2_2,
			"139": G_2_3,
			"140": G_2_4,
			"141": G_2_5,
			"144": G_4_0,
			"145": G_4_1,
			"146": G_4_2,
			"147": G_4_3,
			"148": G_4_4,
			"149": G_4_5,
			"152": G_8_0,
			"153": G_8_1,
			"154": G_8_2,
			"155": G_8_3,
			"156": G_8_4,
			"157": G_8_5,
			"160": G_16_0,
			"161": G_16_1,
			"162": G_16_2,
			"163": G_16_3,
			"164": G_16_4,
			"165": G_16_5,
			"168": G_32_0,
			"169": G_32_1,
			"170": G_32_2,
			"171": G_32_3,
			"172": G_32_4,
			"173": G_32_5,
			"192": N_1_0,
			"193": N_1_1,
			"194": N_1_2,
			"195": N_1_3,
			"196": N_1_4,
			"197": N_1_5,
			"200": N_2_0,
			"201": N_2_1,
			"202": N_2_2,
			"203": N_2_3,
			"204": N_2_4,
			"205": N_2_5,
			"208": N_4_0,
			"209": N_4_1,
			"210": N_4_2,
			"211": N_4_3,
			"212": N_4_4,
			"213": N_4_5,
			"216": N_8_0,
			"217": N_8_1,
			"218": N_8_2,
			"219": N_8_3,
			"220": N_8_4,
			"221": N_8_5,
			"224": N_16_0,
			"225": N_16_1,
			"226": N_16_2,
			"227": N_16_3,
			"228": N_16_4,
			"229": N_16_5,
			"232": N_32_0,
			"233": N_32_1,
			"234": N_32_2,
			"235": N_32_3,
			"236": N_32_4,
			"237": N_32_5,
			"264": T_1_0,
			"265": T_1_1,
			"266": T_1_2,
			"267": T_1_3,
			"268": T_1_4,
			"269": T_1_5,
			"272": T_2_0,
			"273": T_2_1,
			"274": T_2_2,
			"275": T_2_3,
			"276": T_2_4,
			"277": T_2_5,
			"280": T_3_0,
			"281": T_3_1,
			"282": T_3_2,
			"283": T_3_3,
			"284": T_3_4,
			"285": T_3_5,
			"288": T_4_0,
			"289": T_4_1,
			"290": T_4_2,
			"291": T_4_3,
			"292": T_4_4,
			"293": T_4_5
		};
		
		private static var noteGroupMap : Object =
		{
			"a": 0,
			"b": 64,
			"g": 128,
			"n": 192,
			"t": 256
		};
		
		private static var noteLengthMap : Object =
		{
			"1": 0,
			"2": 1,
			"4": 2,
			"8": 3,
			"16": 4,
			"32": 5
		};
		
		public function Notes() 
		{
		}
		
		public static function noteId(group : String, length : int, pitch : int) : int
		{
			var value : int = 0;
			
			if (group == 't')
			{
				value =
					((Notes.noteGroupMap[group]) & Notes.MASK_GROUP) |
					((length << Notes.SHIFT_LENGTH) & Notes.MASK_LENGTH) |
					((pitch << Notes.SHIFT_PITCH) & Notes.MASK_PITCH)
				;
			}
			else
			{
				value =
					((Notes.noteGroupMap[group]) & Notes.MASK_GROUP) |
					((Notes.noteLengthMap[length] << Notes.SHIFT_LENGTH) & Notes.MASK_LENGTH) |
					((pitch << Notes.SHIFT_PITCH) & Notes.MASK_PITCH)
				;
			}
			
			FlxG.log("NG: " + group + " -> " + Notes.noteGroupMap[group]);
			FlxG.log("Note: " + group + "-" + (length) + "-" + (pitch) + " => " + value);
			
			return value;
		}
	}

}