<?php
require __DIR__.'/script_init.php';
require __DIR__.'/common.inc.php';

$db = new DBMysql(Config::rc("database.$.".DBXBOX.".w"));
$db->connect();

$sql = "SELECT ProductId
        FROM products";
$ProductIds = $db->rs2column($sql);
foreach ($ProductIds as $id) {
    $filename = SKU_PATH.$id;
    $data = file_get_contents($filename);
    $json = json_decode($data, true);
    $Markets = $json["LocalizedProperties"][0]["Markets"];
    foreach ($Markets as $mkt) {
        $arrIns = array(
            'product_id' => $id,
            'market' => $mkt,
        );
        $db->insert('game_market', $arrIns);
    }
}
