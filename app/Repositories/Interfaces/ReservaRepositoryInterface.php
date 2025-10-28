<?php

namespace App\Repositories\Interfaces;

use App\Models\Reserva;
use Illuminate\Database\Eloquent\Collection;

interface ReservaRepositoryInterface
{
    public function all(): Collection;
    public function find(int $id): ?Reserva;
    public function create(array $data): Reserva;
    public function update(int $id, array $data): bool;
    public function delete(int $id): bool;
    public function findByUser(int $userId): Collection;
    public function findByEspaco(int $espacoId): Collection;
    public function findConflicts(int $espacoId, string $data, string $horaInicio, string $horaFim): Collection;
}