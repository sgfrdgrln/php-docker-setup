--TEST--
MongoDB\Driver\CursorId unserialization errors (__serialize and __unserialize)
--FILE--
<?php

require_once __DIR__ . "/../utils/basic.inc";

echo throws(function() {
    unserialize('O:23:"MongoDB\Driver\CursorId":1:{s:2:"id";i:0;}');
}, 'MongoDB\Driver\Exception\InvalidArgumentException'), "\n";

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
OK: Got MongoDB\Driver\Exception\InvalidArgumentException
MongoDB\Driver\CursorId initialization requires "id" string field
===DONE===
