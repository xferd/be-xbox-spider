<?php
require PRJ.'../dojet4/dojet.php';
require PRJ.'../be-global/init.php';

define('UI', PRJ.'ui/');
define('CONFIG', PRJ.'config/');
define('MODEL', PRJ.'model/');

Config::load([
    CONFIG.'runtime',
    CONFIG.'route',
    CONFIG.'database',
]);

Autoloader::getInstance()->addAutoloadPath([

]);

Trace::init(['level' => Trace::TRACE_ALL]);
