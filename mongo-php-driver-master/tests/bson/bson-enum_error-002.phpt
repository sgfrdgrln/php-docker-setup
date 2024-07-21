--TEST--
Backed enum cannot implement Unserializable
--SKIPIF--
<?php require __DIR__ . "/../utils/basic-skipif.inc"; ?>
<?php skip_if_php_version('<', '8.1.0'); ?>
--FILE--
<?php

enum MyBackedEnum: int implements MongoDB\BSON\Unserializable
{
    case A = 1;

    public function bsonUnserialize(array $data): void {}
}

?>
===DONE===
<?php exit(0); ?>
--EXPECTF--
Fatal error: Enum class MyBackedEnum cannot implement interface MongoDB\BSON\Unserializable in %s on line %d
