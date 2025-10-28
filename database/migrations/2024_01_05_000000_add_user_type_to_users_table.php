<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->enum('tipo_usuario', ['locatario', 'anfitriao', 'ambos'])->default('locatario');
            $table->text('descricao')->nullable();
            $table->string('foto_perfil')->nullable();
            $table->decimal('avaliacao_media', 3, 2)->default(0);
            $table->integer('total_avaliacoes')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['tipo_usuario', 'descricao', 'foto_perfil', 'avaliacao_media', 'total_avaliacoes']);
        });
    }
};