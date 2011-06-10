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
$volumnShift = 11;
$silenceShift = 15;

$pitchMask = 0x7;
$lengthMask = 0x7 << $lengthShift;
$groupMask = 0x7 << $groupShift;
$panMask = 0x3 << $panShift;
$volumnMask = 0xF << $volumnShift;
$silenceMask = 0x1 << $silenceShift;

$format = "%1$016b" . PHP_EOL; 
$valueFormat = '%1$016b = %1$3d (%2$s)' . PHP_EOL; 

printf("Pitch:   " . $format, $pitchMask);
printf("Length:  " . $format, $lengthMask);
printf("Group:   " . $format, $groupMask);
printf("Pan:     " . $format, $panMask);
printf("Volume:  " . $format, $volumnMask);
printf("Silence: " . $format, $silenceMask);
printf("Max emt: " . $format, 32767);

die();

$groups = array('a', 'b', 'g', /*'t'*/);
$lengths = array('1', '2', '4', '8', '16', '32');
$pitches = array('0', '1', '2', '3', '4', '5');

$inits = array();

foreach($groups as $g => $group)
{
	$value =
		($g << $groupShift & $groupMask)
		//($l << $lengthShift & $lengthMask) |
		//($p << $pitchShift & $pitchMask)
	;
	
	echo "\t\t$group: $value," . PHP_EOL;
}
