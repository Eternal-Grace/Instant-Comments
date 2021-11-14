<?php

namespace App\Models;

use App\Casts\UTF8String;
use Illuminate\Database\Eloquent\Model;

class Chatroom extends Model
{
    protected $primaryKey = null;

    public $incrementing = false;

    protected $table = "chatroom";

    protected $fillable = [
        'id', 'message'
    ];

    protected $casts = [
        'id' => 'string',
        'message' => UTF8String::class,
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
