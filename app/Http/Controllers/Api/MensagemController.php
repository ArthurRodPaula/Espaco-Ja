<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mensagem;
use Illuminate\Http\Request;

class MensagemController extends Controller
{
    public function index(Request $request)
    {
        $conversas = Mensagem::where('remetente_id', $request->user()->id)
            ->orWhere('destinatario_id', $request->user()->id)
            ->with(['remetente', 'destinatario', 'reserva'])
            ->orderBy('created_at', 'desc')
            ->get()
            ->groupBy(function($mensagem) use ($request) {
                $outroUsuario = $mensagem->remetente_id === $request->user()->id 
                    ? $mensagem->destinatario_id 
                    : $mensagem->remetente_id;
                return $outroUsuario;
            })
            ->map(function($mensagens) {
                return $mensagens->first();
            });

        return response()->json($conversas->values());
    }

    public function show(Request $request, $userId)
    {
        $mensagens = Mensagem::where(function($query) use ($request, $userId) {
            $query->where('remetente_id', $request->user()->id)
                  ->where('destinatario_id', $userId);
        })->orWhere(function($query) use ($request, $userId) {
            $query->where('remetente_id', $userId)
                  ->where('destinatario_id', $request->user()->id);
        })
        ->with(['remetente', 'destinatario'])
        ->orderBy('created_at', 'asc')
        ->get();

        // Marcar como lidas
        Mensagem::where('remetente_id', $userId)
            ->where('destinatario_id', $request->user()->id)
            ->where('lida', false)
            ->update(['lida' => true]);

        return response()->json($mensagens);
    }

    public function store(Request $request)
    {
        $request->validate([
            'destinatario_id' => 'required|exists:users,id',
            'mensagem' => 'required|string|max:1000',
            'reserva_id' => 'nullable|exists:reservas,id',
        ]);

        $mensagem = Mensagem::create([
            'remetente_id' => $request->user()->id,
            'destinatario_id' => $request->destinatario_id,
            'reserva_id' => $request->reserva_id,
            'mensagem' => $request->mensagem,
        ]);

        return response()->json($mensagem->load(['remetente', 'destinatario']), 201);
    }

    public function naoLidas(Request $request)
    {
        $count = Mensagem::where('destinatario_id', $request->user()->id)
            ->naoLidas()
            ->count();

        return response()->json(['count' => $count]);
    }
}