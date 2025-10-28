<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\EspacoController;
use App\Http\Controllers\Api\ReservaController;
use App\Http\Controllers\Api\PerfilController;

// Rotas de autenticação
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Rotas públicas
Route::get('/espacos', [EspacoController::class, 'index']);
Route::get('/espacos/{id}', [EspacoController::class, 'show']);
Route::get('/espacos/{id}/disponibilidade', [EspacoController::class, 'disponibilidade']);

// Upload de imagens (protegida)
Route::post('/upload-image', [App\Http\Controllers\Api\UploadController::class, 'uploadImage'])->middleware('auth:sanctum');
Route::delete('/delete-image', [App\Http\Controllers\Api\UploadController::class, 'deleteImage'])->middleware('auth:sanctum');

// Rotas protegidas
Route::middleware('auth:sanctum')->group(function () {
    // Autenticação
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    
    // Perfil
    Route::get('/perfil', [PerfilController::class, 'show']);
    Route::put('/perfil', [PerfilController::class, 'update']);
    
    // Espaços (CRUD completo para proprietários)
    Route::post('/espacos', [EspacoController::class, 'store']);
    Route::put('/espacos/{id}', [EspacoController::class, 'update']);
    Route::delete('/espacos/{id}', [EspacoController::class, 'destroy']);
    
    // Reservas
    Route::get('/reservas', [ReservaController::class, 'index']);
    Route::post('/reservas', [ReservaController::class, 'store']);
    Route::put('/reservas/{id}', [ReservaController::class, 'update']);
    Route::delete('/reservas/{id}', [ReservaController::class, 'destroy']);
    
    // Avaliações
    Route::post('/avaliacoes', [App\Http\Controllers\Api\AvaliacaoController::class, 'store']);
    Route::get('/espacos/{id}/avaliacoes', [App\Http\Controllers\Api\AvaliacaoController::class, 'index']);
    
    // Mensagens
    Route::get('/mensagens', [App\Http\Controllers\Api\MensagemController::class, 'index']);
    Route::get('/mensagens/{userId}', [App\Http\Controllers\Api\MensagemController::class, 'show']);
    Route::post('/mensagens', [App\Http\Controllers\Api\MensagemController::class, 'store']);
    Route::get('/mensagens/nao-lidas/count', [App\Http\Controllers\Api\MensagemController::class, 'naoLidas']);
    
    // Pagamentos
    Route::get('/pagamentos', [App\Http\Controllers\Api\PagamentoController::class, 'index']);
    Route::post('/pagamentos', [App\Http\Controllers\Api\PagamentoController::class, 'store']);
    Route::get('/pagamentos/{id}', [App\Http\Controllers\Api\PagamentoController::class, 'show']);
    
    // Dashboard Anfitrião
    Route::get('/dashboard/anfitriao', [App\Http\Controllers\Api\DashboardController::class, 'anfitriao']);
    Route::get('/dashboard/meus-espacos', [App\Http\Controllers\Api\DashboardController::class, 'meusEspacos']);
    Route::get('/dashboard/espacos/{id}/reservas', [App\Http\Controllers\Api\DashboardController::class, 'reservasEspaco']);
    
    // Reservas Recebidas
    Route::get('/dashboard/reservas-recebidas', [App\Http\Controllers\Api\ReservasRecebidasController::class, 'index']);
    Route::put('/dashboard/reservas-recebidas/{id}', [App\Http\Controllers\Api\ReservasRecebidasController::class, 'update']);
    
    // Notificações
    Route::get('/notificacoes', [App\Http\Controllers\Api\NotificacaoController::class, 'index']);
    Route::get('/notificacoes/nao-lidas/count', [App\Http\Controllers\Api\NotificacaoController::class, 'naoLidas']);
    Route::put('/notificacoes/{id}/lida', [App\Http\Controllers\Api\NotificacaoController::class, 'marcarComoLida']);
    Route::put('/notificacoes/marcar-todas-lidas', [App\Http\Controllers\Api\NotificacaoController::class, 'marcarTodasComoLidas']);
});