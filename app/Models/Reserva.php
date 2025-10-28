<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reserva extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'espaco_id',
        'data',
        'horario_inicio',
        'horario_fim',
        'valor_total',
        'status',
        'tipo',
        'desconto',
        'observacoes',
        'adultos',
        'criancas',
        'bebes',
        'pets',
        'taxa_adicional',
    ];

    protected function casts(): array
    {
        return [
            'data' => 'date',
            'horario_inicio' => 'datetime:H:i',
            'horario_fim' => 'datetime:H:i',
            'valor_total' => 'decimal:2',
            'desconto' => 'decimal:2',
            'taxa_adicional' => 'decimal:2',
        ];
    }
    
    public function getTotalHospedesAttribute()
    {
        return $this->adultos + $this->criancas + $this->bebes;
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function espaco()
    {
        return $this->belongsTo(Espaco::class);
    }

    public function scopePendente($query)
    {
        return $query->where('status', 'pendente');
    }

    public function scopeConfirmada($query)
    {
        return $query->where('status', 'confirmada');
    }

    public function scopeCancelada($query)
    {
        return $query->where('status', 'cancelada');
    }
}