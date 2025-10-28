<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Reserva;
use App\Models\Espaco;
use App\Models\Notificacao;
use Illuminate\Http\Request;
use Carbon\Carbon;

class ReservaController extends Controller
{
    public function index(Request $request)
    {
        $reservas = Reserva::with(['espaco', 'user'])
            ->where('user_id', $request->user()->id)
            ->orderBy('data', 'desc')
            ->orderBy('horario_inicio', 'desc')
            ->paginate(10);

        return response()->json($reservas);
    }

    public function store(Request $request)
    {
        $request->validate([
            'espaco_id' => 'required|exists:espacos,id',
            'data' => 'required|date|after_or_equal:today',
            'horario_inicio' => 'required|date_format:H:i',
            'horario_fim' => 'required|date_format:H:i|after:horario_inicio',
            'adultos' => 'required|integer|min:1',
            'criancas' => 'nullable|integer|min:0',
            'bebes' => 'nullable|integer|min:0',
            'pets' => 'nullable|integer|min:0',
            'observacoes' => 'nullable|string',
        ]);

        // Verificar disponibilidade
        $conflito = Reserva::where('espaco_id', $request->espaco_id)
            ->where('data', $request->data)
            ->where('status', '!=', 'cancelada')
            ->where(function($query) use ($request) {
                $query->whereBetween('horario_inicio', [$request->horario_inicio, $request->horario_fim])
                      ->orWhereBetween('horario_fim', [$request->horario_inicio, $request->horario_fim])
                      ->orWhere(function($q) use ($request) {
                          $q->where('horario_inicio', '<=', $request->horario_inicio)
                            ->where('horario_fim', '>=', $request->horario_fim);
                      });
            })
            ->exists();

        if ($conflito) {
            return response()->json(['message' => 'Horário não disponível'], 422);
        }

        $espaco = Espaco::findOrFail($request->espaco_id);
        
        // Validar capacidade total
        $totalHospedes = $request->adultos + ($request->criancas ?? 0) + ($request->bebes ?? 0);
        if ($totalHospedes > $espaco->capacidade) {
            return response()->json(['message' => 'Número de hóspedes excede a capacidade do espaço'], 422);
        }
        
        // Calcular valor total
        $inicio = Carbon::createFromFormat('H:i', $request->horario_inicio);
        $fim = Carbon::createFromFormat('H:i', $request->horario_fim);
        
        // Se o horário fim for menor que início, assumir que é no dia seguinte
        if ($fim->lessThan($inicio)) {
            $fim->addDay();
        }
        
        $horas = $fim->diffInHours($inicio);
        $valorBase = $horas * $espaco->preco_por_hora;
        
        // Calcular taxas adicionais
        $taxaAdicional = 0;
        if (($request->pets ?? 0) > 0) {
            $taxaAdicional += ($request->pets * 20); // R$ 20 por pet
        }
        if ($totalHospedes > 4) {
            $taxaAdicional += (($totalHospedes - 4) * 10); // R$ 10 por pessoa adicional
        }
        
        $valorTotal = $valorBase + $taxaAdicional;

        $reserva = Reserva::create([
            'user_id' => $request->user()->id,
            'espaco_id' => $request->espaco_id,
            'data' => $request->data,
            'horario_inicio' => $request->horario_inicio,
            'horario_fim' => $request->horario_fim,
            'valor_total' => $valorTotal,
            'adultos' => $request->adultos,
            'criancas' => $request->criancas ?? 0,
            'bebes' => $request->bebes ?? 0,
            'pets' => $request->pets ?? 0,
            'taxa_adicional' => $taxaAdicional,
            'observacoes' => $request->observacoes,
        ]);

        // Criar notificação para o proprietário do espaço
        Notificacao::create([
            'user_id' => $espaco->user_id,
            'tipo' => 'nova_reserva',
            'titulo' => 'Nova Reserva Recebida',
            'mensagem' => "Você recebeu uma nova reserva para {$espaco->nome} de {$request->user()->name}",
            'dados' => [
                'reserva_id' => $reserva->id,
                'espaco_id' => $espaco->id,
                'cliente_nome' => $request->user()->name,
            ],
        ]);

        return response()->json($reserva->load(['espaco', 'user']), 201);
    }

    public function update(Request $request, $id)
    {
        $reserva = Reserva::where('user_id', $request->user()->id)->findOrFail($id);

        if ($reserva->status === 'cancelada') {
            return response()->json(['message' => 'Reserva já foi cancelada'], 422);
        }

        $request->validate([
            'status' => 'required|in:pendente,confirmada,cancelada',
        ]);

        $reserva->update(['status' => $request->status]);

        return response()->json($reserva->load(['espaco', 'user']));
    }

    public function destroy(Request $request, $id)
    {
        $reserva = Reserva::where('user_id', $request->user()->id)->findOrFail($id);
        
        if ($reserva->status === 'cancelada') {
            return response()->json(['message' => 'Reserva já foi cancelada'], 422);
        }

        $reserva->update(['status' => 'cancelada']);

        return response()->json(['message' => 'Reserva cancelada com sucesso']);
    }
}