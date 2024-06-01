<?php
namespace App\Constants;

class GameConstant
{
    public const PLAYER_X = 1;
    public const PLAYER_O = 2;

    public const X_WIN    = 1;
    public const O_WIN    = 2;
    public const DRAW     = 3;
    public const CONTINUE = 4;

    public const INIT_DATA = [
        'status' => GameConstant::CONTINUE,
        'turn'   => GameConstant::PLAYER_X,
        'board'  => [
            null, null, null,
            null, null, null,
            null, null, null
        ]
    ];
}
