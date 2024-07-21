--TEST--
Array: Single Element Array with index set incorrectly to ab
--DESCRIPTION--
Generated by scripts/convert-bson-corpus-tests.php

DO NOT EDIT THIS FILE
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$canonicalBson = hex2bin('140000000461000C0000001030000A0000000000');
$degenerateBson = hex2bin('150000000461000D000000106162000A0000000000');
$canonicalExtJson = '{"a" : [{"$numberInt": "10"}]}';

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

// Degenerate BSON -> Native -> Canonical BSON
echo bin2hex(fromPHP(toPHP($degenerateBson))), "\n";

// Degenerate BSON -> BSON object -> Canonical BSON
echo bin2hex(fromPHP(MongoDB\BSON\Document::fromBSON($degenerateBson)->toPHP())), "\n";

// Degenerate BSON -> Canonical extJSON
echo json_canonicalize(toCanonicalExtendedJSON($degenerateBson)), "\n";

// Degenerate BSON -> BSON object -> Canonical extJSON
echo json_canonicalize(MongoDB\BSON\Document::fromBSON($degenerateBson)->toCanonicalExtendedJSON()), "\n";

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
140000000461000c0000001030000a0000000000
140000000461000c0000001030000a0000000000
{"a":[{"$numberInt":"10"}]}
{"a":[{"$numberInt":"10"}]}
140000000461000c0000001030000a0000000000
140000000461000c0000001030000a0000000000
140000000461000c0000001030000a0000000000
140000000461000c0000001030000a0000000000
{"a":[{"$numberInt":"10"}]}
{"a":[{"$numberInt":"10"}]}
===DONE===