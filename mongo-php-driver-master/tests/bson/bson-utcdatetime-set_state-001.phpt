--TEST--
MongoDB\BSON\UTCDateTime::__set_state()
--FILE--
<?php

$tests = [
    '0',
    '-1416445411987',
    '1416445411987',
];

foreach ($tests as $milliseconds) {
    var_export(MongoDB\BSON\UTCDateTime::__set_state([
        'milliseconds' => $milliseconds,
    ]));
    echo "\n\n";
}

?>
===DONE===
<?php exit(0); ?>
--EXPECTF--
%r\\?%rMongoDB\BSON\UTCDateTime::__set_state(array(
   'milliseconds' => '0',
))

%r\\?%rMongoDB\BSON\UTCDateTime::__set_state(array(
   'milliseconds' => '-1416445411987',
))

%r\\?%rMongoDB\BSON\UTCDateTime::__set_state(array(
   'milliseconds' => '1416445411987',
))

===DONE===
