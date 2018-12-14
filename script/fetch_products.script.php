<?php
require __DIR__.'/script_init.php';
require __DIR__.'/common.inc.php';
define('PRODUCT_URL_FORMAT', 'https://displaycatalog.mp.microsoft.com/v7.0/products?bigIds=%s&market=%s&languages=%s&MS-CV=DAU1mcuxoWMMp+F.1');

$urls = all_urls();
foreach ($urls as $url) {
    Log::debug("fetch url: ".$url);
    $curl = MCurl::curlGetRequest($url);
    $response = $curl->sendRequest();
    $json = json_decode($response, true);
    if (false === $json) {
        Log::die("json decode fail.");
    }
    $products = $json['Products'];
    foreach ($products as $product) {
        $ProductId = $product['ProductId'];

        save_product($ProductId, json_encode($product));
        // Log::debug("save product, bigid=".$ProductId);
    }
}

//=======================

function all_urls() {
    foreach (load_bigids() as $arrBigIds) {
        $bigIds = join(",", $arrBigIds);
        foreach (['HK', 'TW'] as $market) {
            yield product_url($bigIds, $market, 'zh-cn');
        }
    }
}

function product_url($bigIds, $market, $languages) {
    return sprintf(PRODUCT_URL_FORMAT, $bigIds, $market, $languages);
}

function load_bigids() {
    $fp = fopen(BIGID_PATH, 'r');
    $bigIds = [];
    while ($id = fgets($fp)) {
        $bigIds[] = trim($id);
        if (count($bigIds) >= 50) {
            yield $bigIds;
            $bigIds = [];
        }
    }
}

function save_product($ProductId, $data) {
    $path = SKU_PATH.$ProductId;
    return file_put_contents($path, $data);
}
