<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'whatsapp',
        'tipo_usuario',
        'descricao',
        'foto_perfil',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function espacos()
    {
        return $this->hasMany(Espaco::class);
    }

    public function reservas()
    {
        return $this->hasMany(Reserva::class);
    }

    public function avaliacoes()
    {
        return $this->hasMany(Avaliacao::class);
    }

    public function mensagensEnviadas()
    {
        return $this->hasMany(Mensagem::class, 'remetente_id');
    }

    public function mensagensRecebidas()
    {
        return $this->hasMany(Mensagem::class, 'destinatario_id');
    }

    public function pagamentos()
    {
        return $this->hasMany(Pagamento::class);
    }

    public function isAnfitriao()
    {
        return in_array($this->tipo_usuario, ['anfitriao', 'ambos']);
    }

    public function isLocatario()
    {
        return in_array($this->tipo_usuario, ['locatario', 'ambos']);
    }
}