<?php

try {
    $pdo = new PDO("mysql:host=mysql;port=3306", $_ENV['DOCKER_DB_USER'], $_ENV['DOCKER_DB_PASSWORD']);

    $stmt = $pdo->prepare('select 1');
    $stmt->execute();

    if (is_array($stmt->fetch())) {
        echo 1;
        exit;
    }

    echo 0;
} catch (\PDOException) {
    echo 0;
}
