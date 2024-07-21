--TEST--
Decimal128: [dqbsr531] negatives (Rounded)
--DESCRIPTION--
Generated by scripts/convert-bson-corpus-tests.php

DO NOT EDIT THIS FILE
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$canonicalBson = hex2bin('1800000013640099761CC7B548F377DC80A131C836FEAF00');
$canonicalExtJson = '{"d" : {"$numberDecimal" : "-1.111111111111111111111111111112345"}}';
$degenerateExtJson = '{"d" : {"$numberDecimal" : "-1.1111111111111111111111111111123450"}}';

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

// Degenerate extJSON -> Canonical BSON
echo bin2hex(fromJSON($degenerateExtJson)), "\n";

// Degenerate extJSON -> BSON object -> Canonical BSON
echo bin2hex((string) MongoDB\BSON\Document::fromJSON($degenerateExtJson)), "\n";

?>
===DONE===
<?php exit(0); ?>
--EXPECT--
1800000013640099761cc7b548f377dc80a131c836feaf00
1800000013640099761cc7b548f377dc80a131c836feaf00
{"d":{"$numberDecimal":"-1.111111111111111111111111111112345"}}
{"d":{"$numberDecimal":"-1.111111111111111111111111111112345"}}
1800000013640099761cc7b548f377dc80a131c836feaf00
1800000013640099761cc7b548f377dc80a131c836feaf00
1800000013640099761cc7b548f377dc80a131c836feaf00
1800000013640099761cc7b548f377dc80a131c836feaf00
===DONE===