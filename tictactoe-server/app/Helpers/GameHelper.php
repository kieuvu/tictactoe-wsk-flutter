<?php
namespace App\Helpers;

use App\Constants\GameConstant;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;

class GameHelper
{
    public static function getStatus(string $roomId): int
    {
        $roomData = GameHelper::getRoom($roomId);

        $board  = $roomData["board"];
        $player = $roomData["turn"];

        $firstRow       = $board[0] === $player && $board[1] === $player && $board[2] === $player;
        $secondRow      = $board[3] === $player && $board[4] === $player && $board[5] === $player;
        $thirdRow       = $board[6] === $player && $board[7] === $player && $board[8] === $player;
        $firstCol       = $board[0] === $player && $board[3] === $player && $board[6] === $player;
        $secondCol      = $board[1] === $player && $board[4] === $player && $board[7] === $player;
        $thirdCol       = $board[2] === $player && $board[5] === $player && $board[8] === $player;
        $firstDiagonal  = $board[0] === $player && $board[4] === $player && $board[8] === $player;
        $secondDiagonal = $board[2] === $player && $board[4] === $player && $board[6] === $player;

        $isWinner = $firstRow || $secondRow || $thirdRow || $firstCol || $secondCol || $thirdCol || $firstDiagonal || $secondDiagonal;

        if ($isWinner) {
            return $player === GameConstant::PLAYER_X ? GameConstant::X_WIN : GameConstant::O_WIN;
        }

        if (in_array(null, $board, true)) {
            return GameConstant::CONTINUE;
        }

        return GameConstant::DRAW;
    }

    private static function getRoomKey(string $roomId): string
    {
        return "room_" . $roomId;
    }

    public static function getRoom(string $roomId) : array
    {
        return Cache::get(GameHelper::getRoomKey($roomId));
    }

    public static function hasRoom(string $roomId): bool
    {
        return Cache::has(GameHelper::getRoomKey($roomId));
    }

    public static function createRoom(): string
    {
        return "room_" . Str::random(5);
    }

    public static function getRoomName(string $roomId): string
    {
        return str_replace("room_", "", $roomId);
    }

    public static function saveGame(string $roomId, array $data): void
    {
        Cache::put(GameHelper::getRoomKey($roomId), $data);
    }

    public static function clearGame(string $roomId): void {
        Cache::forget(GameHelper::getRoomKey($roomId));
    }
}
