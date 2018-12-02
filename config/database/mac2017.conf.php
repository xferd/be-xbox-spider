<?php
define('DBDEMO', 'DBDEMO');
define('DBXBOX', 'DBXBOX');

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
        DBXBOX => [
            'r' => [
                'hosts' => [['h' => '127.0.0.1', 'p' => '3306'],],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'xbox',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
            'w' => [
                'hosts' => [['h' => '127.0.0.1', 'p' => '3306'],],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'xbox',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
        ],
    ],
]);
