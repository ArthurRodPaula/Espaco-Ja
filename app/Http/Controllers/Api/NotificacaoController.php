<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notificacao;
use Illuminate\Http\Request;

class NotificacaoController extends Controller
{
    public function index(Request $request)
    {
        $notificacoes = Notificacao::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json($notificacoes);
    }

    public function naoLidas(Request $request)
    {
        $count = Notificacao::where('user_id', $request->user()->id)
            ->naoLidas()
            ->count();

        return response()->json(['count' => $count]);
    }

    public function marcarComoLida(Request $request, $id)
    {
        $notificacao = Notificacao::where('user_id', $request->user()->id)
            ->findOrFail($id);
        
        $notificacao->update(['lida' => true]);

        return response()->json(['message' => 'Notificação marcada como lida']);
    }

    public function marcarTodasComoLidas(Request $request)
    {
        Notificacao::where('user_id', $request->user()->id)
            ->naoLidas()
            ->update(['lida' => true]);

        return response()->json(['message' => 'Todas as notificações foram marcadas como lidas']);
    }
}