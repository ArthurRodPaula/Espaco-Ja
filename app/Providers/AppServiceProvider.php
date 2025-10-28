<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Repositories\Interfaces\EspacoRepositoryInterface;
use App\Repositories\EspacoRepository;
use App\Repositories\Interfaces\ReservaRepositoryInterface;
use App\Repositories\ReservaRepository;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Registra os repositórios
        $this->app->bind(EspacoRepositoryInterface::class, EspacoRepository::class);
        $this->app->bind(ReservaRepositoryInterface::class, ReservaRepository::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
