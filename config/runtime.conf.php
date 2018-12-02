<?php
define('C_RUNTIME_DEFAULT', 'runtime_default');
define('C_RUNTIME_LOCAL', 'runtime_local');
define('C_RUNTIME_105', 'runtime_105');
define('C_RUNTIME_228', 'runtime_228');
define('C_RUNTIME_MAC2017', 'mac2017');

$runtime = C_RUNTIME_DEFAULT;

if (defined('RUNTIME')) {
    $runtime = RUNTIME;
} elseif (file_exists('/var/.iam105')) {
    $runtime = C_RUNTIME_105;
} elseif (file_exists('/var/.iam228')) {
    $runtime = C_RUNTIME_228;
} elseif (file_exists('/var/.iammac2017')) {
    $runtime = C_RUNTIME_MAC2017;
}

Config::set('runtime', $runtime);
