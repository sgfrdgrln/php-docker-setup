--TEST--
Decimal128: [basx065] strings without E cannot generate E in result
--DESCRIPTION--
Generated by scripts/convert-bson-corpus-tests.php

DO NOT EDIT THIS FILE
--FILE--
<?php

require_once __DIR__ . '/../utils/basic.inc';

$canonicalBson = hex2bin('18000000136400185C0ACE0000000000000000000038B000');
$canonicalExtJson = '{"d" : {"$numberDecimal" : "-345678.5432"}}';
$degenerateExtJson = '{"d" : {"$numberDecimal" : "-0345678.5432"}}';

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
18000000136400185c0ace0000000000000000000038b000
18000000136400185c0ace0000000000000000000038b000
{"d":{"$numberDecimal":"-345678.5432"}}
{"d":{"$numberDecimal":"-345678.5432"}}
18000000136400185c0ace0000000000000000000038b000
18000000136400185c0ace0000000000000000000038b000
18000000136400185c0ace0000000000000000000038b000
18000000136400185c0ace0000000000000000000038b000
===DONE===