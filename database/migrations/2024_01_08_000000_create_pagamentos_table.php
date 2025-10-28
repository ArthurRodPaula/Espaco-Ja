<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pagamentos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('reserva_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->decimal('valor', 10, 2);
            $table->enum('metodo_pagamento', ['cartao_credito', 'cartao_debito', 'pix', 'boleto']);
            $table->enum('status', ['pendente', 'processando', 'aprovado', 'recusado', 'cancelado'])->default('pendente');
            $table->string('transaction_id')->nullable();
            $table->json('dados_pagamento')->nullable();
            $table->timestamp('data_vencimento')->nullable();
            $table->timestamp('data_pagamento')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pagamentos');
    }
};