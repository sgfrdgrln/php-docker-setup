--TEST--
Document type (DBRef sub-documents): DBRef with additional fields
--DESCRIPTION--
Generated by scripts/convert-bson-corpus-tests.php

DO NOT EDIT THIS FILE
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$canonicalBson = hex2bin('4400000003646272656600380000000224726566000b000000636f6c6c656374696f6e00072469640058921b3e6e32ab156a22b59e02666f6f0004000000626172000000');
$canonicalExtJson = '{"dbref": {"$ref": "collection", "$id": {"$oid": "58921b3e6e32ab156a22b59e"}, "foo": "bar"}}';

// Canonical BSON -> Native -> Canonical BSON
echo bin2hex(fromPHP(toPHP($canonicalBson))), "\n";

// Canonical BSON -> BSON object -> Canonical BSON
echo bin2hex((string) MongoDB\BSON\Document::fromBSON($canonicalBson)), "\n";

// Canonical BSON -> Canonical extJSON
echo json_canonicalize(toCanonicalExtendedJSON($canonicalBson)), "\n";

// Canonical BSON -> BSON object -> Canonical extJSON
echo json_canonicalize(MongoDB\BSON\Document::fromBSON($canonicalBson)->toCanonicalExtendedJSON()), "\n";

// Canonical extJSON -> Canonical BSON
echo bin2hex(fromJSON($canonicalExtJson)), "\n";

// Canonical extJSON -> BSON object -> Canonical BSON
echo bin2hex((string) MongoDB\BSON\Document::fromJSON($canonicalExtJson)), "\n";

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
4400000003646272656600380000000224726566000b000000636f6c6c656374696f6e00072469640058921b3e6e32ab156a22b59e02666f6f0004000000626172000000
4400000003646272656600380000000224726566000b000000636f6c6c656374696f6e00072469640058921b3e6e32ab156a22b59e02666f6f0004000000626172000000
{"dbref":{"$ref":"collection","$id":{"$oid":"58921b3e6e32ab156a22b59e"},"foo":"bar"}}
{"dbref":{"$ref":"collection","$id":{"$oid":"58921b3e6e32ab156a22b59e"},"foo":"bar"}}
4400000003646272656600380000000224726566000b000000636f6c6c656374696f6e00072469640058921b3e6e32ab156a22b59e02666f6f0004000000626172000000
4400000003646272656600380000000224726566000b000000636f6c6c656374696f6e00072469640058921b3e6e32ab156a22b59e02666f6f0004000000626172000000
===DONE===