<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Espaco extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'nome',
        'descricao',
        'preco_por_hora',
        'capacidade',
        'endereco',
        'cidade',
        'estado',
        'cep',
        'latitude',
        'longitude',
        'amenidades',
        'imagens',
        'ativo',
    ];

    protected function casts(): array
    {
        return [
            'amenidades' => 'array',
            'imagens' => 'array',
            'ativo' => 'boolean',
            'preco_por_hora' => 'decimal:2',
            'latitude' => 'decimal:8',
            'longitude' => 'decimal:8',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reservas()
    {
        return $this->hasMany(Reserva::class);
    }

    public function scopeAtivo($query)
    {
        return $query->where('ativo', true);
    }

    public function scopePorCidade($query, $cidade)
    {
        return $query->where('cidade', 'like', "%{$cidade}%");
    }

    public function scopePorCapacidade($query, $capacidade)
    {
        return $query->where('capacidade', '>=', $capacidade);
    }
}