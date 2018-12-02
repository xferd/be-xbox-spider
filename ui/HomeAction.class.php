<?php
/**
 * Homepage
 *
 * Filename: HomeAction.class.php
 *
 * @author setimouse@gmail.com
 * @since 2014 3 14
 */
class HomeAction extends BaseAction {

    public function execute() {
        print_r(Config::conf());
    }

}
