<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Espaco;
use App\Models\Reserva;
use App\Models\Pagamento;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function anfitriao(Request $request)
    {
        $user = $request->user();
        
        if (!in_array($user->tipo_usuario, ['anfitriao', 'ambos'])) {
            return response()->json(['message' => 'Acesso negado'], 403);
        }

        $espacos = Espaco::where('user_id', $user->id)->get();
        $espacoIds = $espacos->pluck('id');

        // Estatísticas
        $totalEspacos = $espacos->count();
        $totalReservas = Reserva::whereIn('espaco_id', $espacoIds)->count();
        $reservasHoje = Reserva::whereIn('espaco_id', $espacoIds)
            ->whereDate('data', today())
            ->count();
        
        $receitaTotal = Pagamento::whereHas('reserva', function($query) use ($espacoIds) {
            $query->whereIn('espaco_id', $espacoIds);
        })->where('status', 'aprovado')->sum('valor');

        $receitaMes = Pagamento::whereHas('reserva', function($query) use ($espacoIds) {
            $query->whereIn('espaco_id', $espacoIds);
        })
        ->where('status', 'aprovado')
        ->whereMonth('created_at', now()->month)
        ->sum('valor');

        // Reservas recentes
        $reservasRecentes = Reserva::whereIn('espaco_id', $espacoIds)
            ->with(['user', 'espaco'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        // Espaços mais populares
        $espacosPopulares = $espacos->map(function($espaco) {
            $espaco->total_reservas = $espaco->reservas()->count();
            return $espaco;
        })->sortByDesc('total_reservas')->take(3);

        return response()->json([
            'estatisticas' => [
                'total_espacos' => $totalEspacos,
                'total_reservas' => $totalReservas,
                'reservas_hoje' => $reservasHoje,
                'receita_total' => $receitaTotal,
                'receita_mes' => $receitaMes,
            ],
            'reservas_recentes' => $reservasRecentes,
            'espacos_populares' => $espacosPopulares->values(),
            'espacos' => $espacos,
        ]);
    }

    public function meusEspacos(Request $request)
    {
        $espacos = Espaco::where('user_id', $request->user()->id)
            ->withCount('reservas')
            ->with(['reservas' => function($query) {
                $query->latest()->limit(3);
            }])
            ->paginate(10);

        return response()->json($espacos);
    }

    public function reservasEspaco(Request $request, $espacoId)
    {
        $espaco = Espaco::where('user_id', $request->user()->id)
            ->findOrFail($espacoId);

        $reservas = Reserva::where('espaco_id', $espacoId)
            ->with(['user', 'pagamentos'])
            ->orderBy('data', 'desc')
            ->orderBy('horario_inicio', 'desc')
            ->paginate(15);

        return response()->json($reservas);
    }
}