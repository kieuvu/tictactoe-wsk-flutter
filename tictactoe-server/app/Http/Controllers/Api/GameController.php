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

class GameController extends Controller
{
    public function __construct()
    {
          // Init Dependencies
    }

    public function getRooms()
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
            $roomId = GameHelper::createRoom();
        } while (GameHelper::hasRoom($roomId));

        Cache::put($roomId, GameConstant::INIT_DATA);

        return response()->json([
            "status"  => true,
            "room_id" => GameHelper::getRoomName($roomId),
        ], 200);
    }

    public function updateBoard(Request $request, string $roomId): JsonResponse
    {
        if (!GameHelper::hasRoom($roomId)) {
            return response()->json([
                "status"  => false,
                "message" => "Room not found",
            ], 400);
        }

        $boardIndex = intval($request->input("boardIndex"));
        $player = intval($request->input("player"));

        logger()->info("", [$request->all()]);
        logger()->info($boardIndex,);

        $roomData = GameHelper::getRoom($roomId);

        $roomData["board"][$boardIndex] = $player;

        GameHelper::saveGame($roomId, $roomData);

        $roomData["status"] = GameHelper::getStatus($roomId);

        $roomData["turn"] = $player === GameConstant::PLAYER_X ? GameConstant::PLAYER_O : GameConstant::PLAYER_X;

        GameHelper::saveGame($roomId, $roomData);

        event(new GameEvent($roomId, $roomData));

        return response()->json([
            "status" => true,
            "data" => $roomData
        ], 200);
    }

    public function joinRoom(string $roomId)
    {
        logger()->info($roomId);

        if (!GameHelper::hasRoom($roomId)) {
            return response()->json([
                "status"  => false,
                "message" => "Room not found",
            ], 400);
        }

        $roomData = GameHelper::getRoom($roomId);

        return response()->json([
            "status"  => true,
            "data" => $roomData,
        ], 200);
    }

    public function deleteRoom()
    {
          // Implementing
    }
}
