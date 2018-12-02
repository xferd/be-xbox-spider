<?php
define('DBDEMO',    'DBDEMO');

Config::set('database', [
    C_RUNTIME_228 => [
        DBDEMO => [
            'r' => [
                'hosts' => [
                    ['h' => '127.0.0.1', 'p' => 3306],
                ],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'demo',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
            'w' => [
                'hosts' => [
                    ['h' => '127.0.0.1', 'p' => 3306],
                ],
                'username' => 'root',
                'password' => 'root',
                'dbname' => 'demo',
                'charset' => 'utf8',
                'timeout' => 1, //sec
            ],
        ],
    ],
]);
