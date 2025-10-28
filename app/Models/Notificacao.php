<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notificacao extends Model
{
    use HasFactory;

    protected $table = 'notificacoes';

    protected $fillable = [
        'user_id',
        'titulo',
        'mensagem',
        'tipo',
        'lida',
        'dados',
    ];

    protected function casts(): array
    {
        return [
            'lida' => 'boolean',
            'dados' => 'array',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function scopeNaoLidas($query)
    {
        return $query->where('lida', false);
    }
}