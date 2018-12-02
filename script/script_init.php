<?php
define('PRJ', realpath(dirname(__FILE__).'/../').'/');
include(PRJ.'init.php');
include(PRJ.'MainCliService.class.php');

startCliService(new MainCliService());
