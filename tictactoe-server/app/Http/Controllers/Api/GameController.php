<?php

namespace App\Http\Controllers\Api;

use App\Constants\GameConstant;
use App\Events\GameEvent;
use App\Helpers\GameHelper;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class GameController extends Controller
{
    public function __construct()
    {
          // Init Dependencies
    }

    public function getFreeRooms()
    {
        $prefix = "laravel_cache_room_";
        $rooms = array_map(fn($room) => str_replace($prefix, "", $room), DB::table("cache")
            ->where("key", "LIKE", "{$prefix}%")
            ->pluck("key")
            ->toArray());

        return response()->json([
            "rooms" => $rooms,
            "status" => true
        ], 200);
    }

    public function createRoom(): JsonResponse
    {
        do {
            $roomId = "room_" . Str::random(5);
        } while (Cache::has($roomId));

        Cache::put($roomId, GameConstant::INIT_DATA);

        return response()->json([
            "status"  => true,
            "room_id" => $roomId,
        ], 200);
    }

    public function updateBoard(string $roomId, int $player, int $boardIndex): JsonResponse
    {
        if (!Cache::has($roomId)) {
            return response()->json([
                "status"  => false,
                "message" => "Room not found",
            ], 400);
        }

        $roomData = Cache::get($roomId);

        $roomData["board"][$boardIndex] = $player;

        $roomData["status"] = GameHelper::getStatus($roomId);

        $roomData["turn"] = $player === GameConstant::PLAYER_X ? GameConstant::PLAYER_O : GameConstant::PLAYER_X;

        Cache::put($roomId, $roomData);

        event(new GameEvent($roomData["status"], $roomData["turn"], $roomId));

        return response()->json([
            "status" => true,
        ], 200);
    }

    public function joinRoom()
    {
          // Implementing
    }

    public function deleteRoom()
    {
          // Implementing
    }
}
