<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Avaliacao extends Model
{
    use HasFactory;

    protected $table = 'avaliacoes';

    protected $fillable = [
        'user_id',
        'espaco_id',
        'reserva_id',
        'nota',
        'comentario',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function espaco()
    {
        return $this->belongsTo(Espaco::class);
    }

    public function reserva()
    {
        return $this->belongsTo(Reserva::class);
    }
}