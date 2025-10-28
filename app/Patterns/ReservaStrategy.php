<?php

namespace App\Patterns;

use App\Models\Reserva;
use Carbon\Carbon;

/**
 * Padrão Strategy para diferentes estratégias de cálculo de preço
 * Permite alternar entre diferentes algoritmos de precificação
 */
interface PricingStrategy
{
    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float;
}

class PrecoPadraoStrategy implements PricingStrategy
{
    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float
    {
        return $precoBase * $horas;
    }
}

class PrecoPromocionalStrategy implements PricingStrategy
{
    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float
    {
        $desconto = $parametros['desconto'] ?? 0.1; // 10% padrão
        return ($precoBase * $horas) * (1 - $desconto);
    }
}

class PrecoFimDeSemanaStrategy implements PricingStrategy
{
    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float
    {
        $multiplicador = $parametros['multiplicador'] ?? 1.5; // 50% mais caro
        return ($precoBase * $horas) * $multiplicador;
    }
}

class PrecoHorarioNoturnoStrategy implements PricingStrategy
{
    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float
    {
        $desconto = $parametros['desconto'] ?? 0.2; // 20% desconto noturno
        return ($precoBase * $horas) * (1 - $desconto);
    }
}

class ReservaPricingContext
{
    private PricingStrategy $strategy;

    public function __construct(PricingStrategy $strategy)
    {
        $this->strategy = $strategy;
    }

    public function setStrategy(PricingStrategy $strategy): void
    {
        $this->strategy = $strategy;
    }

    public function calcularPreco(float $precoBase, int $horas, array $parametros = []): float
    {
        return $this->strategy->calcularPreco($precoBase, $horas, $parametros);
    }

    public static function obterEstrategia(string $data, string $horaInicio): PricingStrategy
    {
        $dataReserva = Carbon::parse($data);
        $hora = (int) explode(':', $horaInicio)[0];

        // Fim de semana
        if ($dataReserva->isWeekend()) {
            return new PrecoFimDeSemanaStrategy();
        }

        // Horário noturno (após 18h)
        if ($hora >= 18) {
            return new PrecoHorarioNoturnoStrategy();
        }

        // Padrão
        return new PrecoPadraoStrategy();
    }
}