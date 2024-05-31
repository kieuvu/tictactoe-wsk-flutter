<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class GameEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    /**
     * Create a new event instance.
     */
    public function __construct(public int $status, public int $turn, public string $roomId)
    {
    }

    public function broadcastOn()
    {
        return ["game.notification.{$this->roomId}"];
    }

    public function broadcastAs()
    {
        return 'game.notification';
    }
}
