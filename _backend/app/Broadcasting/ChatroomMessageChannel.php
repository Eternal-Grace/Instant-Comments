<?php

namespace App\Broadcasting;

use App\Models\User;

/**
 * Class ChatroomMessageChannel
 * @package App\Broadcasting
 */
class ChatroomMessageChannel
{
    /**
     * Create a new channel instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Authenticate the user's access to the channel.
     *
     * @param User|null $user
     * @return bool
     */
    public function join(User $user = null): bool
    {
        return true;
    }
}
