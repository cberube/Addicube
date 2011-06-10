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
