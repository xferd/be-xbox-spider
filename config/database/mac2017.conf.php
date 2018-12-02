<?php
define('DBDEMO',    'DBDEMO');

Config::set('database', [
    C_RUNTIME_MAC2017 => [
        DBDEMO => [
            'r' => [
                'hosts' => ['127.0.0.1:3306'],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'demo',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
            'w' => [
                'hosts' => ['127.0.0.1:3306'],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'demo',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
        ],
    ],
]);
