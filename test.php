<?php
require 'vendor/autoload.php'; // Include Composer's autoloader

$client = new MongoDB\Client("mongodb://mongo:27017");
$collection = $client->test->users;

$result = $collection->insertOne(['name' => 'John Doe', 'email' => 'john@example.com']);
echo "Inserted with Object ID '{$result->getInsertedId()}'";

echo "Hello, World! This is PHP 8.2.12 with MongoDB.";
