<?php

class MainWebService extends WebService {

    public function uriWillRoute($uri) {
        if (false !== strpos($uri, '/debug/')) {
            Config::set('is_debug', true);
            $uri = (string)substr($uri, strlen('/debug'));
        }
        $uri = parent::uriWillRoute($uri);

        return $uri;
    }

}
