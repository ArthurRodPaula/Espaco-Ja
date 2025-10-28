<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Mensagem extends Model
{
    use HasFactory;

    protected $table = 'mensagens';

    protected $fillable = [
        'remetente_id',
        'destinatario_id',
        'reserva_id',
        'mensagem',
        'lida',
    ];

    protected function casts(): array
    {
        return [
            'lida' => 'boolean',
        ];
    }

    public function remetente()
    {
        return $this->belongsTo(User::class, 'remetente_id');
    }

    public function destinatario()
    {
        return $this->belongsTo(User::class, 'destinatario_id');
    }

    public function reserva()
    {
        return $this->belongsTo(Reserva::class);
    }

    public function scopeNaoLidas($query)
    {
        return $query->where('lida', false);
    }
}