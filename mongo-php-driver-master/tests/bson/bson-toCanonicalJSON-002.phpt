--TEST--
MongoDB\BSON\toCanonicalExtendedJSON(): Encoding extended JSON types
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$tests = [
    [ '_id' => new MongoDB\BSON\ObjectId('56315a7c6118fd1b920270b1') ],
    [ 'binary' => new MongoDB\BSON\Binary('foo', MongoDB\BSON\Binary::TYPE_GENERIC) ],
    [ 'date' => new MongoDB\BSON\UTCDateTime(1445990400000) ],
    [ 'timestamp' => new MongoDB\BSON\Timestamp(1234, 5678) ],
    [ 'regex' => new MongoDB\BSON\Regex('pattern', 'i') ],
    [ 'code' => new MongoDB\BSON\Javascript('function() { return 1; }') ],
    [ 'code_ws' => new MongoDB\BSON\Javascript('function() { return a; }', ['a' => 1]) ],
    [ 'minkey' => new MongoDB\BSON\MinKey ],
    [ 'maxkey' => new MongoDB\BSON\MaxKey ],
];

foreach ($tests as $value) {
    $bson = fromPHP($value);
    echo toCanonicalExtendedJSON($bson), "\n";
}

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
{ "_id" : { "$oid" : "56315a7c6118fd1b920270b1" } }
{ "binary" : { "$binary" : { "base64" : "Zm9v", "subType" : "00" } } }
{ "date" : { "$date" : { "$numberLong" : "1445990400000" } } }
{ "timestamp" : { "$timestamp" : { "t" : 5678, "i" : 1234 } } }
{ "regex" : { "$regularExpression" : { "pattern" : "pattern", "options" : "i" } } }
{ "code" : { "$code" : "function() { return 1; }" } }
{ "code_ws" : { "$code" : "function() { return a; }", "$scope" : { "a" : { "$numberInt" : "1" } } } }
{ "minkey" : { "$minKey" : 1 } }
{ "maxkey" : { "$maxKey" : 1 } }
===DONE===
