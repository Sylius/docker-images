<?php

declare(strict_types=1);

$dbUser = $argv[1];
$dbPassword = $argv[2];
$appEnv = $argv[3];

try {
    $pdo = new PDO("mysql:host=mysql;port=3306", $dbUser, $dbPassword);

    $stmt = $pdo->prepare('SHOW DATABASES');
    $stmt->execute();

    if (is_array($result = $stmt->fetchAll(PDO::FETCH_ASSOC))) {
        foreach ($result as $row) {
            if ($row['Database'] === "sylius_$appEnv") {
                echo 'connected';
                exit;
            }
        }
    }

    echo "connected but couldn't find a database";
} catch (\PDOException $ex) {
    echo $ex->getMessage();
}
