<?php

$input=$_GET["mac"];

echo sha1($input."salt");

?>
