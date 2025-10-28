<?php

namespace App\Services;

use App\Repositories\Interfaces\EspacoRepositoryInterface;
use App\Repositories\Interfaces\ReservaRepositoryInterface;

/**
 * Service Layer para lógica de negócio de espaços
 * Implementa orientação a objetos com separação de responsabilidades
 */
class EspacoService
{
    private $espacoRepository;
    private $reservaRepository;

    public function __construct(
        EspacoRepositoryInterface $espacoRepository,
        ReservaRepositoryInterface $reservaRepository
    ) {
        $this->espacoRepository = $espacoRepository;
        $this->reservaRepository = $reservaRepository;
    }

    public function buscarEspacosDisponiveis(array $filtros): array
    {
        $espacos = $this->espacoRepository->search($filtros);
        
        // Se há filtros de data/horário, verificar disponibilidade
        if (isset($filtros['data']) && isset($filtros['horario_inicio']) && isset($filtros['horario_fim'])) {
            $espacos = $this->espacoRepository->findAvailable(
                $filtros['data'],
                $filtros['horario_inicio'],
                $filtros['horario_fim']
            );
        }

        return $espacos->toArray();
    }

    public function verificarDisponibilidade(int $espacoId, string $data, string $horaInicio, string $horaFim): bool
    {
        $conflitos = $this->reservaRepository->findConflicts($espacoId, $data, $horaInicio, $horaFim);
        return $conflitos->isEmpty();
    }

    public function obterEstatisticasEspaco(int $espacoId): array
    {
        $espaco = $this->espacoRepository->find($espacoId);
        $reservas = $this->reservaRepository->findByEspaco($espacoId);

        return [
            'total_reservas' => $reservas->count(),
            'receita_total' => $reservas->sum('valor_total'),
            'taxa_ocupacao' => $this->calcularTaxaOcupacao($reservas),
            'avaliacao_media' => 4.5
        ];
    }

    private function calcularTaxaOcupacao($reservas): float
    {
        $diasComReserva = $reservas->groupBy('data')->count();
        $diasNoMes = 30;
        
        return ($diasComReserva / $diasNoMes) * 100;
    }
}