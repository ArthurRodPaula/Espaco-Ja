<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\EspacoRepositoryInterface;
use App\Repositories\Interfaces\ReservaRepositoryInterface;
use App\Patterns\ReservaFactory;
use App\Patterns\ReservaPricingContext;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReservaController extends Controller
{
    private $espacoRepository;
    private $reservaRepository;

    public function __construct(
        EspacoRepositoryInterface $espacoRepository,
        ReservaRepositoryInterface $reservaRepository
    ) {
        $this->espacoRepository = $espacoRepository;
        $this->reservaRepository = $reservaRepository;
    }

    public function store(Request $request, int $espacoId)
    {
        $request->validate([
            'data' => 'required|date|after_or_equal:today',
            'horario_inicio' => 'required',
            'horario_fim' => 'required|after:horario_inicio',
            'tipo' => 'in:normal,recorrente,promocional'
        ]);

        $espaco = $this->espacoRepository->find($espacoId);
        if (!$espaco) {
            abort(404);
        }

        // Verificar conflitos usando repository
        $conflitos = $this->reservaRepository->findConflicts(
            $espacoId,
            $request->data,
            $request->horario_inicio,
            $request->horario_fim
        );

        if ($conflitos->count() > 0) {
            return back()->withErrors(['horario' => 'Horário não disponível']);
        }

        // Calcular preço usando Strategy
        $strategy = ReservaPricingContext::obterEstrategia($request->data, $request->horario_inicio);
        $context = new ReservaPricingContext($strategy);
        
        $horas = \Carbon\Carbon::parse($request->horario_fim)->diffInHours(\Carbon\Carbon::parse($request->horario_inicio));
        $valorTotal = $context->calcularPreco($espaco->preco_por_hora, $horas);

        // Criar reserva usando Factory e Repository
        $tipo = $request->tipo ?? 'normal';
        $reservaData = [
            'user_id' => Auth::id(),
            'espaco_id' => $espaco->id,
            'data' => $request->data,
            'horario_inicio' => $request->horario_inicio,
            'horario_fim' => $request->horario_fim,
            'valor_total' => $valorTotal,
            'observacoes' => $request->observacoes
        ];

        $reserva = ReservaFactory::criarReserva($tipo, $reservaData);
        $this->reservaRepository->create($reserva->toArray());

        return redirect()->route('perfil')->with('success', 'Reserva criada com sucesso!');
    }
}