<?php

namespace App\Http\Controllers;

use App\Http\Resources\ChatroomResourceCollection;
use App\Models\Chatroom;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response as ResponseAlias;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        // $this->middleware('auth');
    }

    public function test()
    {
        $res = Chatroom::all();
        return response()->json($res->toArray(), ResponseAlias::HTTP_OK, [], JSON_NUMERIC_CHECK);
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        return view('home');
    }
}
