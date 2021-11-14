<?php

namespace App\Providers;

use App\Models\Chatroom;
use App\Observers\ChatroomObserver;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Chatroom::observe(ChatroomObserver::class);
    }
}
