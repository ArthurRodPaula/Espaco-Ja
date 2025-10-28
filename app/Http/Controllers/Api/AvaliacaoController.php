<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Avaliacao;
use App\Models\Reserva;
use Illuminate\Http\Request;

class AvaliacaoController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'reserva_id' => 'required|exists:reservas,id',
            'nota' => 'required|integer|min:1|max:5',
            'comentario' => 'nullable|string|max:1000',
        ]);

        $reserva = Reserva::where('user_id', $request->user()->id)
            ->where('id', $request->reserva_id)
            ->where('status', 'confirmada')
            ->firstOrFail();

        $avaliacao = Avaliacao::create([
            'user_id' => $request->user()->id,
            'espaco_id' => $reserva->espaco_id,
            'reserva_id' => $request->reserva_id,
            'nota' => $request->nota,
            'comentario' => $request->comentario,
        ]);

        // Atualizar média do espaço
        $this->atualizarMediaEspaco($reserva->espaco_id);

        return response()->json($avaliacao->load(['user', 'espaco']), 201);
    }

    public function index(Request $request, $espacoId)
    {
        $avaliacoes = Avaliacao::with('user')
            ->where('espaco_id', $espacoId)
            ->orderBy('created_at', 'desc')
            ->paginate(10);

        return response()->json($avaliacoes);
    }

    private function atualizarMediaEspaco($espacoId)
    {
        $avaliacoes = Avaliacao::where('espaco_id', $espacoId)->get();
        $media = $avaliacoes->avg('nota');
        $total = $avaliacoes->count();

        \App\Models\Espaco::where('id', $espacoId)->update([
            'avaliacao_media' => round($media, 2),
            'total_avaliacoes' => $total,
        ]);
    }
}