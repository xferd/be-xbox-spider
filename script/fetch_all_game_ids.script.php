<?php
require __DIR__.'/script_init.php';
require __DIR__.'/common.inc.php';
define('ALL_GAME_URL', 'https://www.xbox.com/en-US/games/xbox-one/js/xcat-bi-urls.json');

Log::debug("request productIds. url=".ALL_GAME_URL);
$request = MCurl::curlGetRequest(ALL_GAME_URL);
$response = $request->sendRequest();
Log::debug("request done");

$productIds = null;
if (preg_match_all('/"([A-Z0-9]{12})"/', $response, $reg)) {
    $productIds = array_unique($reg[1]);
    Log::debug("fetch productIds ".count($productIds));
}

if (is_null($productIds)) {
    Log::die("fetch productIds failed.");
}

$fp = fopen(BIGID_PATH, 'w');
if (false === $fp) {
    Log::die("open file failed. file=".BIGID_PATH);
}

foreach ($productIds as $id) {
    fputs($fp, $id."\n");
}
fclose($fp);

Log::debug("write to db");
$db = new DBMysql(Config::rc("database.$.".DBXBOX.".w"))->connect();
foreach (array_chunk($productIds, 100) as $ids) {
    foreach ($ids as $id) {
        $sql = "SELECT ProductId
                FROM products
                WHERE ProductId='$id'";
        $ProductId = $db->rs2value($sql);
        if (!is_null($ProductId)) {
            continue;
        }
        $arrIns = array(
            'ProductId' => $id,
        );
        $db->insert('products', $arrIns);
    }
}

Log::debug("done!");
