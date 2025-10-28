<?php

namespace App\Repositories\Interfaces;

use App\Models\Espaco;
use Illuminate\Database\Eloquent\Collection;

interface EspacoRepositoryInterface
{
    public function all(): Collection;
    public function find(int $id): ?Espaco;
    public function findWithImages(int $id): ?Espaco;
    public function create(array $data): Espaco;
    public function update(int $id, array $data): bool;
    public function delete(int $id): bool;
    public function findByUser(int $userId): Collection;
    public function search(array $filters): Collection;
    public function findAvailable(string $data, string $horaInicio, string $horaFim): Collection;
}