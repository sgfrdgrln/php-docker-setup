--TEST--
MongoDB\BSON\Document::__unserialize() throws on errors
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$tests = [
    'Empty string' => '',
    'Last byte is non-zero' => pack(
        'VCa*xVa*',
        4 + 1 + 4 + 4 + 2, // Size: 4 bytes for size, 1 byte for type, 4 bytes for key, 4 bytes for string length, 2 bytes for string
        0x02,
        'foo',
        2,
        'a'
    ),
    'Length does not match document length' => pack('VCa*Va*xx', 7, 0x02, 'foo', 1, 'a'),
];

foreach ($tests as $test) {
    echo throws(function() use ($test) {
        $data = base64_encode($test);
        $dataLength = strlen($data);

        $payload = sprintf(
            'O:%d:"%s":1:{s:4:"data";s:%d:"%s";}',
            strlen(MongoDB\BSON\Document::class),
            MongoDB\BSON\Document::class,
            $dataLength,
            $data
        );

        unserialize($payload);
    }, MongoDB\Driver\Exception\InvalidArgumentException::class), "\n";
}

?>
===DONE===
<?php exit(0); ?>
--EXPECTF--
OK: Got MongoDB\Driver\Exception\InvalidArgumentException
MongoDB\BSON\Document initialization requires valid BSON
OK: Got MongoDB\Driver\Exception\InvalidArgumentException
MongoDB\BSON\Document initialization requires valid BSON
OK: Got MongoDB\Driver\Exception\InvalidArgumentException
MongoDB\BSON\Document initialization requires valid BSON
===DONE===
