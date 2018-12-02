<?php
define('PRJ', realpath(__DIR__.'/../').'/');
include(PRJ.'init.php');
include(PRJ.'MainWebService.class.php');

startWebService(new MainWebService());