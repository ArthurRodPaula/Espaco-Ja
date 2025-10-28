<?php

namespace App\Http\Controllers;

use App\Models\Contato;
use Illuminate\Http\Request;

class ContatoController extends Controller
{
    public function index()
    {
        return view('contato');
    }

    public function store(Request $request)
    {
        $request->validate([
            'nome' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'assunto' => 'required|string|max:255',
            'mensagem' => 'required|string|max:2000'
        ]);

        Contato::create($request->all());

        return redirect()->route('contato')->with('success', 'Mensagem enviada com sucesso!');
    }
}