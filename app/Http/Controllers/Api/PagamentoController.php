<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pagamento;
use App\Models\Reserva;
use Illuminate\Http\Request;

class PagamentoController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'reserva_id' => 'required|exists:reservas,id',
            'metodo_pagamento' => 'required|in:cartao_credito,cartao_debito,pix,boleto',
            'dados_pagamento' => 'required|array',
        ]);

        $reserva = Reserva::where('user_id', $request->user()->id)
            ->findOrFail($request->reserva_id);

        $pagamento = Pagamento::create([
            'reserva_id' => $request->reserva_id,
            'user_id' => $request->user()->id,
            'valor' => $reserva->valor_total,
            'metodo_pagamento' => $request->metodo_pagamento,
            'dados_pagamento' => $request->dados_pagamento,
            'status' => 'processando',
        ]);

        // Simular processamento do pagamento
        $this->processarPagamento($pagamento);

        return response()->json($pagamento->load('reserva'), 201);
    }

    public function show(Request $request, $id)
    {
        $pagamento = Pagamento::where('user_id', $request->user()->id)
            ->with(['reserva.espaco'])
            ->findOrFail($id);

        return response()->json($pagamento);
    }

    public function index(Request $request)
    {
        $pagamentos = Pagamento::where('user_id', $request->user()->id)
            ->with(['reserva.espaco'])
            ->orderBy('created_at', 'desc')
            ->paginate(10);

        return response()->json($pagamentos);
    }

    private function processarPagamento($pagamento)
    {
        // Simulação de processamento
        // Em produção, aqui seria integrado com gateway de pagamento
        
        $sucesso = rand(1, 10) > 2; // 80% de sucesso
        
        if ($sucesso) {
            $pagamento->update([
                'status' => 'aprovado',
                'data_pagamento' => now(),
                'transaction_id' => 'TXN_' . uniqid(),
            ]);
            
            // Confirmar reserva
            $pagamento->reserva->update(['status' => 'confirmada']);
        } else {
            $pagamento->update(['status' => 'recusado']);
        }
    }
}