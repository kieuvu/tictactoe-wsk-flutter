<?php

use App\Http\Controllers\Api\GameController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/game/rooms', [GameController::class, 'getRooms']);
Route::post('/game/create', [GameController::class, 'createRoom']);
Route::get('/game/{roomId}/join', [GameController::class, 'joinRoom']);
Route::post('/game/{roomId}/update', [GameController::class, 'updateBoard']);
