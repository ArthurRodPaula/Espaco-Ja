<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('avaliacoes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('espaco_id')->constrained()->onDelete('cascade');
            $table->foreignId('reserva_id')->constrained()->onDelete('cascade');
            $table->integer('nota')->min(1)->max(5);
            $table->text('comentario')->nullable();
            $table->timestamps();
            
            $table->unique(['user_id', 'reserva_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('avaliacoes');
    }
};