<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ChatroomResourceCollection;
use App\Models\Chatroom;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response as ResponseAlias;

/**
 * Class ChatroomController
 * @package App\Http\Controllers\Api
 */
class ChatroomController extends Controller
{
    /**
     * @var Request
     */
    protected Request $request;

    /**
     * @param Request $request
     */
    public function __construct(Request $request)
    {
        $this->request = $request;
    }

    /**
     * @param array $params
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $params): \Illuminate\Contracts\Validation\Validator
    {
        return Validator::make($params, [
            'id' => ['bail', 'required', 'string', 'alpha_num'],
            'message' => ['bail', 'required', 'string', 'min:1', 'max:50']
        ]);
    }

    /**
     * @return JsonResponse
     */
    public function getMessages(): JsonResponse
    {
        $chatroomData = Chatroom::where('created_at', '>=', Carbon::now()->subMinutes(30)->toDateTimeString())->get();
        return response()->json(new ChatroomResourceCollection($chatroomData), ResponseAlias::HTTP_OK, [], JSON_NUMERIC_CHECK);
    }

    /**
     * @return JsonResponse
     */
    public function sendMessage(): JsonResponse
    {
        # Retrieve ONLY 'id' and 'message'. Nothing else.
        $params = $this->request->only(['id', 'message']);
        # Validator pass
        $validator = $this->validator($params);
        # If fail => return error.
        if (! $validator->fails()) {
            #! TODO: Watch 'App\Models\Chatroom' & 'App\Casts\UTF8String' & 'App\Observers\ChatroomObserver'
            # lol. Believe me when I say that this code is bug-proof.
            # Parse Data => Create entry in DDB => Save in DDB => Send Broadcast to Event/Channel
            return response()->json(Chatroom::create($params), ResponseAlias::HTTP_OK, [], JSON_NUMERIC_CHECK);
        }
        return response()->json($validator->getMessageBag(), ResponseAlias::HTTP_UNPROCESSABLE_ENTITY, [], JSON_NUMERIC_CHECK);
    }
}
