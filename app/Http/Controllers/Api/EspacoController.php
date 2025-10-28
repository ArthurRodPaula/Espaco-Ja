<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Espaco;
use App\Models\Reserva;
use Illuminate\Http\Request;

class EspacoController extends Controller
{
    public function index(Request $request)
    {
        $query = Espaco::with('user')->ativo();

        if ($request->has('cidade')) {
            $query->porCidade($request->cidade);
        }

        if ($request->has('capacidade')) {
            $query->porCapacidade($request->capacidade);
        }

        if ($request->has('busca')) {
            $busca = $request->busca;
            $query->where(function($q) use ($busca) {
                $q->where('nome', 'like', "%{$busca}%")
                  ->orWhere('descricao', 'like', "%{$busca}%")
                  ->orWhere('cidade', 'like', "%{$busca}%");
            });
        }

        if ($request->has('amenidades')) {
            $amenidades = explode(',', $request->amenidades);
            foreach ($amenidades as $amenidade) {
                $query->whereJsonContains('amenidades', trim($amenidade));
            }
        }

        $espacos = $query->paginate(12);

        return response()->json($espacos);
    }

    public function show($id)
    {
        $espaco = Espaco::with('user')->findOrFail($id);
        return response()->json($espaco);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome' => 'required|string|max:255',
            'descricao' => 'required|string',
            'preco_por_hora' => 'required|numeric|min:0',
            'capacidade' => 'required|integer|min:1',
            'endereco' => 'required|string',
            'cidade' => 'required|string',
            'estado' => 'required|string',
            'cep' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'amenidades' => 'nullable|array',
            'imagens' => 'nullable|array',
        ]);

        $espaco = Espaco::create([
            'user_id' => $request->user()->id,
            ...$validated
        ]);

        return response()->json($espaco, 201);
    }

    public function update(Request $request, $id)
    {
        $espaco = Espaco::where('user_id', $request->user()->id)->findOrFail($id);

        $validated = $request->validate([
            'nome' => 'required|string|max:255',
            'descricao' => 'required|string',
            'preco_por_hora' => 'required|numeric|min:0',
            'capacidade' => 'required|integer|min:1',
            'endereco' => 'required|string',
            'cidade' => 'required|string',
            'estado' => 'required|string',
            'cep' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'amenidades' => 'nullable|array',
            'imagens' => 'nullable|array',
        ]);

        $espaco->update($validated);

        return response()->json($espaco);
    }

    public function destroy(Request $request, $id)
    {
        $espaco = Espaco::where('user_id', $request->user()->id)->findOrFail($id);
        $espaco->delete();

        return response()->json(['message' => 'Espaço removido com sucesso']);
    }

    public function disponibilidade($id, Request $request)
    {
        $request->validate([
            'data' => 'required|date',
        ]);

        $reservas = Reserva::where('espaco_id', $id)
            ->where('data', $request->data)
            ->where('status', '!=', 'cancelada')
            ->select('horario_inicio', 'horario_fim')
            ->get();

        return response()->json([
            'reservas' => $reservas,
            'disponivel' => $reservas->isEmpty()
        ]);
    }
}