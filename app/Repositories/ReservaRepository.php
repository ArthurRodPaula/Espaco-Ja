<?php

namespace App\Repositories;

use App\Models\Reserva;
use App\Repositories\Interfaces\ReservaRepositoryInterface;
use App\Patterns\DatabaseConnection;
use Illuminate\Database\Eloquent\Collection;

class ReservaRepository implements ReservaRepositoryInterface
{
    private $model;
    private $db;

    public function __construct(Reserva $model)
    {
        $this->model = $model;
        $this->db = DatabaseConnection::getInstance()->getConnection();
    }

    public function all(): Collection
    {
        return $this->model->with(['user', 'espaco'])->get();
    }

    public function find(int $id): ?Reserva
    {
        return $this->model->with(['user', 'espaco'])->find($id);
    }

    public function create(array $data): Reserva
    {
        return $this->model->create($data);
    }

    public function update(int $id, array $data): bool
    {
        $reserva = $this->find($id);
        return $reserva ? $reserva->update($data) : false;
    }

    public function delete(int $id): bool
    {
        $reserva = $this->find($id);
        return $reserva ? $reserva->delete() : false;
    }

    public function findByUser(int $userId): Collection
    {
        return $this->model->with(['espaco'])
            ->where('user_id', $userId)
            ->orderBy('data', 'desc')
            ->get();
    }

    public function findByEspaco(int $espacoId): Collection
    {
        return $this->model->with(['user'])
            ->where('espaco_id', $espacoId)
            ->where('status', '!=', 'cancelada')
            ->orderBy('data', 'asc')
            ->get();
    }

    public function findConflicts(int $espacoId, string $data, string $horaInicio, string $horaFim): Collection
    {
        return $this->model->where('espaco_id', $espacoId)
            ->where('data', $data)
            ->where('status', '!=', 'cancelada')
            ->where(function ($query) use ($horaInicio, $horaFim) {
                $query->whereBetween('horario_inicio', [$horaInicio, $horaFim])
                      ->orWhereBetween('horario_fim', [$horaInicio, $horaFim])
                      ->orWhere(function ($q) use ($horaInicio, $horaFim) {
                          $q->where('horario_inicio', '<=', $horaInicio)
                            ->where('horario_fim', '>=', $horaFim);
                      });
            })
            ->get();
    }
}