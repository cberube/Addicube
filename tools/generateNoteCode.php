<?php

/*
Snnnnnnn

VVVV pppG GGnn nPPP

F    E

S: 1 = silence, 0 = notes
nnnnnnn: Number of notes
*/

$pitchShift = 0;
$lengthShift = 3;
$groupShift = 6;
$panShift = 9;
$volumnShift = 12;

$pitchMask = 0x7;
$lengthMask = 0x7 << $lengthShift;
$groupMask = 0x7 << $groupShift;
$panMask = 0x7 << $panShift;
$volumnMask = 0xF << $volumnShift;

$format = "%1$016b" . PHP_EOL; 
$valueFormat = '%1$016b = %1$3d (%2$s)' . PHP_EOL; 

/*
printf($format, $pitchMask);
printf($format, $lengthMask);
printf($format, $groupMask);
printf($format, $panMask);
printf($format, $volumnMask);
*/

//	Angred, Blue, Greenvious, Neutral (balanced), Tools
$groups = array('a', 'b', 'g', 'n', 't');
//$toolGroup = count($groups);

$lengths = array('1', '2', '4', '8', '16', '32');
$pitches = array('0', '1', '2', '3', '4', '5');

//$groupRemap = array('a' => 'n', 'b' => 'n', 'g' => 'n');

$inits = array();

//echo "Group $toolGroup: " . ($toolGroup << $groupShift);
//die();

foreach($groups as $g => $group)
{
	foreach($lengths as $l => $length)
	{
		if ($group == 't' && ($l == 0 || $l == 5)) continue;
		
		foreach($pitches as $p => $pitch)
		{	
			if (isset($groupRemap[$group]))
			{
				$groupFile = $groupRemap[$group];
			}
			else
			{
				$groupFile = $group;
			}
			
			$value =
				($g << $groupShift & $groupMask) |
				($l << $lengthShift & $lengthMask) |
				($p << $pitchShift & $pitchMask)
			;
			
			if ($group == 't')
			{
				$fileName = 't' . $l . '-' . $pitch . '.mp3';
				$constName = strtoupper($group . '_' . $l . '_' . $pitch);
			}
			else
			{
				$fileName = $groupFile . $length . '-' . $pitch . '.mp3';
				$constName = strtoupper($group . '_' . $length . '_' . $pitch);
			}
			
			//printf($valueFormat, $value, $name);
			
			//[Embed(source = '../../../../../assets/audio/notes/b32-5.mp3')]
			//public static const B_32_5 : Class;
			
			$embed = "[Embed(source = '../../../../../assets/audio/notes/$fileName')]";
			$const = "public static const $constName : Class;"; 
			
			$embeds[] = array($embed, $const);
			$inits[] = "\t\t\t\"$value\": $constName";
		}
	}
}

/*
for($t = 1; $t <= 4; $t++)
{
	for($v = 0; $v <= 5; $v++)
	{
		$fileName = 't' . $t . '-' . $v . '.mp3';
		$constName = strtoupper("T$t" . '_' . $v);
		
		$value =
			($toolGroup << $groupShift & $groupMask) |
			($t << $lengthShift & $lengthMask) |
			($v << $pitchShift & $pitchMask)
		;
		$embed = "[Embed(source = '../../../../../assets/audio/notes/$fileName')]";
		$const = "public static const $constName : Class;"; 
		
		$embeds[] = array($embed, $const);
		$inits[] = "\t\t\t\"$value\": $constName";
	}
}
*/

$initializer = implode(",\n", $inits);

foreach($embeds as $embed)
{
	$e = $embed[0];
	$c = $embed[1];
	
	echo "\t\t$e\n";
	echo "\t\t$c\n\n";
}

echo "\t\tpublic static var soundMap : Object = {\n";
echo $initializer;
echo "\n\t\t};";
