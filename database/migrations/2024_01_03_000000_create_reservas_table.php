<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reservas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('espaco_id')->constrained()->onDelete('cascade');
            $table->date('data');
            $table->time('horario_inicio');
            $table->time('horario_fim');
            $table->decimal('valor_total', 8, 2);
            $table->enum('status', ['pendente', 'confirmada', 'cancelada'])->default('pendente');
            $table->string('tipo')->default('reserva');
            $table->decimal('desconto', 8, 2)->default(0);
            $table->text('observacoes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reservas');
    }
};