<?php

namespace App\Http\Controllers;

use App\Models\Espaco;
use Illuminate\Http\Request;

class EspacoController extends Controller
{
    public function index(Request $request)
    {
        $espacos = Espaco::ativo()->get();
        return view('espacos', compact('espacos'));
    }

    public function show($id)
    {
        $espaco = Espaco::findOrFail($id);
        return view('espaco-detalhes', compact('espaco'));
    }

    public function verificarDisponibilidade(Request $request, $id)
    {
        $espaco = Espaco::findOrFail($id);
        
        $disponivel = $espaco->isDisponivel(
            $request->data,
            $request->hora_inicio,
            $request->hora_fim
        );

        return response()->json(['disponivel' => $disponivel]);
    }
}