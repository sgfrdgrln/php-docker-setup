--TEST--
MongoDB\BSON\Javascript::__set_state() does not allow code to contain null bytes
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

echo throws(function() {
    MongoDB\BSON\Javascript::__set_state(['code' => "function() { return '\0'; }"]);
}, 'MongoDB\Driver\Exception\InvalidArgumentException'), "\n";

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
OK: Got MongoDB\Driver\Exception\InvalidArgumentException
Code cannot contain null bytes
===DONE===
