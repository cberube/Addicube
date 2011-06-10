<?php

$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
echo "Create: " . socket_strerror(socket_last_error($socket));

socket_set_block($socket);
echo "Set block: " . socket_strerror(socket_last_error($socket));

socket_bind($socket, '127.0.0.1', 50000);
echo "Bind: " . socket_strerror(socket_last_error($socket));

socket_listen($socket);
echo "Listen: " . socket_strerror(socket_last_error($socket));

$data = '';
$r = array($socket);
$w = null;
$e = null;

socket_select($r, $w, $e, 0);
socket_accept($socket);

do
{
	$r = array($socket);
	$w = null;
	$e = null;
	socket_select($r, $w, $e, 0);
	$length = @socket_recv($socket, $data, 1024, 0);
	printf('%s', $data);
} while ($length !== 0);

socket_close($socket);
