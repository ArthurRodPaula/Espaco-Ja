<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EspacoImagem extends Model
{
    protected $table = 'espaco_imagens';
    
    protected $fillable = ['espaco_id', 'caminho', 'ordem'];

    public function espaco()
    {
        return $this->belongsTo(Espaco::class);
    }
}