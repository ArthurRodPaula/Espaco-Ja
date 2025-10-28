<?php

namespace App\Repositories;

use App\Models\Espaco;
use App\Repositories\Interfaces\EspacoRepositoryInterface;
use App\Patterns\DatabaseConnection;
use Illuminate\Database\Eloquent\Collection;

class EspacoRepository implements EspacoRepositoryInterface
{
    private $model;
    private $db;

    public function __construct(Espaco $model)
    {
        $this->model = $model;
        $this->db = DatabaseConnection::getInstance()->getConnection();
    }

    public function all(): Collection
    {
        return $this->model->where('ativo', true)->get();
    }

    public function find(int $id): ?Espaco
    {
        return $this->model->find($id);
    }

    public function findWithImages(int $id): ?Espaco
    {
        return $this->model->find($id);
    }

    public function create(array $data): Espaco
    {
        return $this->model->create($data);
    }

    public function update(int $id, array $data): bool
    {
        $espaco = $this->find($id);
        return $espaco ? $espaco->update($data) : false;
    }

    public function delete(int $id): bool
    {
        $espaco = $this->find($id);
        return $espaco ? $espaco->delete() : false;
    }

    public function findByUser(int $userId): Collection
    {
        return $this->model->where('user_id', $userId)->get();
    }

    public function search(array $filters): Collection
    {
        $query = $this->model->where('ativo', true);

        if (!empty($filters['busca'])) {
            $query->where(function($q) use ($filters) {
                $q->where('nome', 'like', '%' . $filters['busca'] . '%')
                  ->orWhere('descricao', 'like', '%' . $filters['busca'] . '%')
                  ->orWhere('cidade', 'like', '%' . $filters['busca'] . '%');
            });
        }

        if (!empty($filters['cidade'])) {
            $query->where('cidade', 'like', '%' . $filters['cidade'] . '%');
        }

        if (!empty($filters['comodidade'])) {
            $query->whereJsonContains('amenidades', $filters['comodidade']);
        }

        if (!empty($filters['capacidade'])) {
            switch($filters['capacidade']) {
                case '1-5':
                    $query->whereBetween('capacidade', [1, 5]);
                    break;
                case '6-15':
                    $query->whereBetween('capacidade', [6, 15]);
                    break;
                case '16-30':
                    $query->whereBetween('capacidade', [16, 30]);
                    break;
                case '30+':
                    $query->where('capacidade', '>', 30);
                    break;
            }
        }

        if (!empty($filters['preco_max'])) {
            $query->where('preco_por_hora', '<=', $filters['preco_max']);
        }

        // Ordenação
        switch($filters['ordenar'] ?? '') {
            case 'preco_asc':
                $query->orderBy('preco_por_hora', 'asc');
                break;
            case 'preco_desc':
                $query->orderBy('preco_por_hora', 'desc');
                break;
            case 'capacidade':
                $query->orderBy('capacidade', 'desc');
                break;
            default:
                $query->orderBy('created_at', 'desc');
        }

        return $query->get();
    }

    public function findAvailable(string $data, string $horaInicio, string $horaFim): Collection
    {
        return $this->model->where('ativo', true)

            ->whereDoesntHave('reservas', function ($query) use ($data, $horaInicio, $horaFim) {
                $query->where('data', $data)
                    ->where('status', '!=', 'cancelada')
                    ->where(function ($q) use ($horaInicio, $horaFim) {
                        $q->whereBetween('horario_inicio', [$horaInicio, $horaFim])
                          ->orWhereBetween('horario_fim', [$horaInicio, $horaFim])
                          ->orWhere(function ($subQ) use ($horaInicio, $horaFim) {
                              $subQ->where('horario_inicio', '<=', $horaInicio)
                                   ->where('horario_fim', '>=', $horaFim);
                          });
                    });
            })
            ->get();
    }
}