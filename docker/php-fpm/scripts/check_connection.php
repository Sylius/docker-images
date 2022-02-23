<?php

declare(strict_types=1);

try {
    $pdo = new PDO("mysql:host=mysql;port=3306", $_ENV['DOCKER_DB_USER'], $_ENV['DOCKER_DB_PASSWORD']);

    $stmt = $pdo->prepare('SHOW DATABASES');
    $stmt->execute();

    if (is_array($result = $stmt->fetchAll(PDO::FETCH_ASSOC))) {
        foreach ($result as $row) {
            if ($row['Database'] === 'sylius_' . $_ENV['DOCKER_APP_ENV']) {
                echo 1;
                exit;
            }
        }
    }

    echo 0;
} catch (\PDOException) {
    echo 0;
}
