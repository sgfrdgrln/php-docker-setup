# PHP-MongoDB-Docker Setup

This repository contains a setup for running a PHP 8.2.12 application with MongoDB using Docker and Docker Compose. The setup includes a Dockerfile for building the PHP application and a `docker-compose.yml` file for orchestrating the PHP and MongoDB services.

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system

## Getting Started

### Clone the Repository

```sh
git clone https://github.com/your-username/php-docker-setup.git
cd php-docker-setup
```
## Project Structure

```sh

php-docker-setup/
├── composer.json
├── docker-compose.yml
├── Dockerfile
└── test.php
```
### Build and Run the Containers

  1. Build the Docker image:

```sh
docker-compose build
```

2. Start the Docker containers:
```sh
docker-compose up -d
```

3. Verify the containers are running:
```sh
docker ps
```
## Access the PHP Application

Open a web browser and navigate to http://localhost:8080. You should see the output from test.php.
Running Composer Commands

To run Composer commands inside the PHP container, use the docker exec command. For example, to run composer update:

```sh
docker exec -it php-app composer update
```
## Example PHP Code

Here is an example test.php file that interacts with MongoDB:

```php
<?php
require 'vendor/autoload.php'; // Include Composer's autoloader

$client = new MongoDB\Client("mongodb://mongo:27017");
$collection = $client->test->users;

// Insert a document
$result = $collection->insertOne(['name' => 'John Doe', 'email' => 'john@example.com']);
echo "Inserted with Object ID '{$result->getInsertedId()}'<br>";

// Retrieve and display the document
$document = $collection->findOne(['name' => 'John Doe']);
echo "Name: " . $document['name'] . "<br>";
echo "Email: " . $document['email'] . "<br>";

echo "Hello, World! This is PHP 8.2.12 with MongoDB.";
```
## Stopping and Removing Containers

To stop the running containers:

```sh
docker-compose down
```
## Updating Dependencies

To update PHP dependencies, run composer update inside the PHP container:

```sh
docker exec -it php-app composer update
```
## Cleaning Up

To remove all containers, networks, and volumes created by docker-compose up:

```sh
docker-compose down -v
```
## Troubleshooting

  - Ensure Docker and Docker Compose are installed and running.
  - Verify that ports 8080 (for PHP) and 27017 (for MongoDB) are not being used by other services on your host machine.

## License

This project is licensed under the MIT License.

## Acknowledgments

  - <a href="https://www.docker.com/">Docker</a>
  - <a href="https://getcomposer.org/">Composer</a>
  - <a href="https://www.mongodb.com/">MongoDB</a>
