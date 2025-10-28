<?php

namespace App\Http\Controllers;

use App\Models\Espaco;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        $espacosDestaque = Espaco::ativo()->take(6)->get();
        return view('home', compact('espacosDestaque'));
    }
}