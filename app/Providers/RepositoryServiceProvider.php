<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Repositories\Interfaces\EspacoRepositoryInterface;
use App\Repositories\Interfaces\ReservaRepositoryInterface;
use App\Repositories\EspacoRepository;
use App\Repositories\ReservaRepository;

class RepositoryServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(EspacoRepositoryInterface::class, EspacoRepository::class);
        $this->app->bind(ReservaRepositoryInterface::class, ReservaRepository::class);
    }

    public function boot(): void
    {
        //
    }
}