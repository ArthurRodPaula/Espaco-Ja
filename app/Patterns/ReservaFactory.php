<?php

namespace App\Patterns;

use App\Models\Reserva;
use Carbon\Carbon;

/**
 * Padrão Factory Method para criação de diferentes tipos de reservas
 * Centraliza a lógica de criação de reservas com diferentes configurações
 */
class ReservaFactory
{
    public static function criarReserva(string $tipo, array $dados): Reserva
    {
        switch ($tipo) {
            case 'normal':
                return self::criarReservaNormal($dados);
            case 'recorrente':
                return self::criarReservaRecorrente($dados);
            case 'promocional':
                return self::criarReservaPromocional($dados);
            default:
                throw new \InvalidArgumentException("Tipo de reserva inválido: {$tipo}");
        }
    }

    private static function criarReservaNormal(array $dados): Reserva
    {
        $reserva = new Reserva();
        $reserva->fill($dados);
        $reserva->tipo = 'normal';
        $reserva->desconto = 0;
        return $reserva;
    }

    private static function criarReservaRecorrente(array $dados): Reserva
    {
        $reserva = new Reserva();
        $reserva->fill($dados);
        $reserva->tipo = 'recorrente';
        $reserva->desconto = 10; // 10% desconto para reservas recorrentes
        $reserva->valor_total = $dados['valor_total'] * 0.9;
        return $reserva;
    }

    private static function criarReservaPromocional(array $dados): Reserva
    {
        $reserva = new Reserva();
        $reserva->fill($dados);
        $reserva->tipo = 'promocional';
        $reserva->desconto = 20; // 20% desconto promocional
        $reserva->valor_total = $dados['valor_total'] * 0.8;
        return $reserva;
    }

    public static function calcularValorTotal(int $espacoId, string $horaInicio, string $horaFim): float
    {
        $espaco = \App\Models\Espaco::find($espacoId);
        $inicio = Carbon::createFromFormat('H:i', $horaInicio);
        $fim = Carbon::createFromFormat('H:i', $horaFim);
        $horas = $fim->diffInHours($inicio);
        
        return $espaco->preco_por_hora * $horas;
    }
}