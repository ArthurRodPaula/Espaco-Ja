<?php

namespace App\Patterns;

use App\Models\Reserva;
use App\Models\User;

/**
 * Padrão Observer para notificações de reservas
 * Permite notificar múltiplos observadores quando uma reserva é criada/alterada
 */
interface ReservaObserver
{
    public function update(Reserva $reserva, string $evento): void;
}

class EmailNotificationObserver implements ReservaObserver
{
    public function update(Reserva $reserva, string $evento): void
    {
        switch ($evento) {
            case 'criada':
                $this->enviarEmailConfirmacao($reserva);
                break;
            case 'cancelada':
                $this->enviarEmailCancelamento($reserva);
                break;
            case 'confirmada':
                $this->enviarEmailConfirmacao($reserva);
                break;
        }
    }

    private function enviarEmailConfirmacao(Reserva $reserva): void
    {
        // Simula envio de email
        \Log::info("Email de confirmação enviado para: {$reserva->user->email}");
    }

    private function enviarEmailCancelamento(Reserva $reserva): void
    {
        // Simula envio de email
        \Log::info("Email de cancelamento enviado para: {$reserva->user->email}");
    }
}

class SMSNotificationObserver implements ReservaObserver
{
    public function update(Reserva $reserva, string $evento): void
    {
        if ($reserva->user->telefone) {
            $this->enviarSMS($reserva, $evento);
        }
    }

    private function enviarSMS(Reserva $reserva, string $evento): void
    {
        // Simula envio de SMS
        \Log::info("SMS de {$evento} enviado para: {$reserva->user->telefone}");
    }
}

class ReservaSubject
{
    private array $observers = [];

    public function attach(ReservaObserver $observer): void
    {
        $this->observers[] = $observer;
    }

    public function detach(ReservaObserver $observer): void
    {
        $key = array_search($observer, $this->observers, true);
        if ($key !== false) {
            unset($this->observers[$key]);
        }
    }

    public function notify(Reserva $reserva, string $evento): void
    {
        foreach ($this->observers as $observer) {
            $observer->update($reserva, $evento);
        }
    }
}