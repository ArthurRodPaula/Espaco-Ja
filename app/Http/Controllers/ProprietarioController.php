<?php

namespace App\Http\Controllers;

use App\Models\Reserva;
use Illuminate\Http\Request;

class ProprietarioController extends Controller
{
    public function reservasPendentes()
    {
        $reservas = Reserva::whereHas('espaco', function($query) {
            $query->where('user_id', auth()->id());
        })->where('status', 'pendente')->with(['espaco', 'user'])->get();
        
        return view('proprietario.reservas-pendentes', compact('reservas'));
    }

    public function aprovarReserva(Reserva $reserva)
    {
        if ($reserva->espaco->user_id !== auth()->id()) {
            abort(403);
        }

        $reserva->update(['status' => 'confirmada']);
        return back()->with('success', 'Reserva aprovada com sucesso!');
    }

    public function rejeitarReserva(Reserva $reserva)
    {
        if ($reserva->espaco->user_id !== auth()->id()) {
            abort(403);
        }

        $reserva->update(['status' => 'cancelada']);
        return back()->with('success', 'Reserva rejeitada.');
    }
}