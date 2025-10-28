<?php

namespace App\Patterns;

use PDO;
use PDOException;

/**
 * Padrão Singleton para conexão com banco de dados
 * Garante uma única instância de conexão durante toda a aplicação
 */
class DatabaseConnection
{
    private static ?DatabaseConnection $instance = null;
    private ?PDO $connection = null;

    private function __construct()
    {
        try {
            $this->connection = new PDO(
                'sqlite:' . database_path('database.sqlite'),
                null,
                null,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]
            );
        } catch (PDOException $e) {
            throw new \Exception("Erro na conexão: " . $e->getMessage());
        }
    }

    public static function getInstance(): DatabaseConnection
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection(): PDO
    {
        return $this->connection;
    }

    // Previne clonagem
    private function __clone() {}

    // Previne deserialização
    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }
}