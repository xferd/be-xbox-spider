<?php
require __DIR__.'/script_init.php';
define('ALL_GAME_URL', 'https://www.xbox.com/en-US/games/xbox-one/js/xcat-bi-urls.json');
define('SAVE_PATH', '/data/xbox/bigids');

Log::debug("request bigIDs. url=".ALL_GAME_URL);
$request = MCurl::curlGetRequest(ALL_GAME_URL);
$response = $request->sendRequest();
Log::debug("request done");

$bigIDs = null;
if (preg_match_all('/"([A-Z0-9]{12})"/', $response, $reg)) {
    $bigIDs = array_unique($reg[1]);
    Log::debug("fetch bigIDs ".count($bigIDs));
}

if (is_null($bigIDs)) {
    Log::die("fetch bigIDs failed.");
}

$fp = fopen(SAVE_PATH, 'w');
if (false === $fp) {
    Log::die("open file failed. file=".SAVE_PATH);
}

foreach ($bigIDs as $id) {
    fputs($fp, $id."\n");
}
fclose($fp);

Log::debug("done!");
