<?php

namespace App\Casts;

use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
use Illuminate\Database\Eloquent\Model;

class UTF8String implements CastsAttributes
{
    /**
     * Cast the given value.
     *
     * @param  Model  $model
     * @param  string $key
     * @param  mixed  $value
     * @param  array $attributes
     * @return mixed|string
     */
    public function get($model, string $key, $value, array $attributes): string
    {
        return htmlspecialchars_decode(html_entity_decode($value, ENT_QUOTES), ENT_QUOTES);
    }

    /**
     * Prepare the given value for storage.
     *
     * @param  Model  $model
     * @param  string $key
     * @param  mixed  $value
     * @param  array $attributes
     * @return mixed|string
     */
    public function set($model, string $key, $value, array $attributes): string
    {
        return e(filter_var(strip_tags(preg_replace('/\s+/', ' ', trim((string)$value))), FILTER_SANITIZE_STRING));
    }
}
