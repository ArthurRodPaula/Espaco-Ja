<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('reservas', function (Blueprint $table) {
            $table->integer('adultos')->default(1);
            $table->integer('criancas')->default(0);
            $table->integer('bebes')->default(0);
            $table->integer('pets')->default(0);
            $table->decimal('taxa_adicional', 8, 2)->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('reservas', function (Blueprint $table) {
            $table->dropColumn(['adultos', 'criancas', 'bebes', 'pets', 'taxa_adicional']);
        });
    }
};