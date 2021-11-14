<?php

namespace App\Observers;

use App\Events\ChatroomMessageEvent;
use App\Models\Chatroom;

class ChatroomObserver
{
    /**
     * Handle the chatroom "created" event.
     *
     * @param Chatroom $chatroom
     * @return void
     */
    public function created(Chatroom $chatroom): void
    {
        broadcast(new ChatroomMessageEvent($chatroom->makeHidden(['created_at', 'updated_at'])->toArray()));
    }

    /**
     * Handle the chatroom "updated" event.
     *
     * @param Chatroom $chatroom
     * @return void
     */
    public function updated(Chatroom $chatroom)
    {
        //
    }

    /**
     * Handle the chatroom "deleted" event.
     *
     * @param Chatroom $chatroom
     * @return void
     */
    public function deleted(Chatroom $chatroom)
    {
        //
    }

    /**
     * Handle the chatroom "restored" event.
     *
     * @param Chatroom $chatroom
     * @return void
     */
    public function restored(Chatroom $chatroom)
    {
        //
    }

    /**
     * Handle the chatroom "force deleted" event.
     *
     * @param Chatroom $chatroom
     * @return void
     */
    public function forceDeleted(Chatroom $chatroom)
    {
        //
    }
}
