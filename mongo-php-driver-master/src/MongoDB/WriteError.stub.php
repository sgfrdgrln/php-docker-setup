<?php

/**
 * @generate-class-entries static
 * @generate-function-entries static
 */

namespace MongoDB\Driver;

final class WriteError
{
    final private function __construct() {}

    final public function getCode(): int {}

    final public function getIndex(): int {}

    final public function getInfo(): ?object {}

    final public function getMessage(): string {}
}
