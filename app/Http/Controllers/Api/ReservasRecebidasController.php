<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reserva;
use App\Models\Espaco;
use Illuminate\Http\Request;

class ReservasRecebidasController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        
        \Log::info('Usuário logado: ' . $user->id . ' - ' . $user->name);
        
        // Buscar reservas dos espaços do usuário usando join
        $query = Reserva::join('espacos', 'reservas.espaco_id', '=', 'espacos.id')
            ->where('espacos.user_id', $user->id)
            ->select('reservas.*')
            ->with(['user', 'espaco']);
            
        // Filtrar por status se fornecido
        if ($request->has('status') && $request->status !== 'todas') {
            $query->where('reservas.status', $request->status);
            \Log::info('Filtrando por status: ' . $request->status);
        }
        
        $reservas = $query->orderBy('reservas.created_at', 'desc')->get();
        
        \Log::info('Reservas encontradas: ' . $reservas->count());
        \Log::info('Reservas: ' . $reservas->toJson());
        
        return response()->json($reservas);
    }
    
    public function update(Request $request, $id)
    {
        $user = $request->user();
        
        // Verificar se a reserva pertence a um espaço do usuário
        $reserva = Reserva::whereHas('espaco', function($query) use ($user) {
            $query->where('user_id', $user->id);
        })->findOrFail($id);
        
        $request->validate([
            'status' => 'required|in:pendente,confirmada,cancelada',
        ]);
        
        $reserva->update(['status' => $request->status]);
        
        return response()->json($reserva->load(['user', 'espaco']));
    }
}