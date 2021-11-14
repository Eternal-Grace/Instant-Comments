<?php

namespace App\Http\Controllers\Api;

use App\Events\ChatroomMessageEvent;
use App\Http\Controllers\Controller;
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
     * @param Request $request
     * @return JsonResponse
     */
    public function sendMessage(Request $request): JsonResponse
    {
        $params = $request->only(['message', 'id']);
        $validator = $this->validator($params);
        if (! $validator->fails()) {
            broadcast(new ChatroomMessageEvent([
                'id' => $params['id'],
                'message' => filter_var(trim(preg_replace('/\s+/', ' ', strip_tags($params['message']))), FILTER_SANITIZE_STRING),
            ]));
            return response()->json([], ResponseAlias::HTTP_OK, [], JSON_NUMERIC_CHECK);
        }
        return response()->json($validator->getMessageBag(), ResponseAlias::HTTP_UNPROCESSABLE_ENTITY, [], JSON_NUMERIC_CHECK);
    }
}
