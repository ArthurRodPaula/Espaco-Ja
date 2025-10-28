<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pagamento extends Model
{
    use HasFactory;

    protected $fillable = [
        'reserva_id',
        'user_id',
        'valor',
        'metodo_pagamento',
        'status',
        'transaction_id',
        'dados_pagamento',
        'data_vencimento',
        'data_pagamento',
    ];

    protected function casts(): array
    {
        return [
            'valor' => 'decimal:2',
            'dados_pagamento' => 'array',
            'data_vencimento' => 'datetime',
            'data_pagamento' => 'datetime',
        ];
    }

    public function reserva()
    {
        return $this->belongsTo(Reserva::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function scopeAprovados($query)
    {
        return $query->where('status', 'aprovado');
    }

    public function scopePendentes($query)
    {
        return $query->where('status', 'pendente');
    }
}