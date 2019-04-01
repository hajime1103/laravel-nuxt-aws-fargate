#!/bin/bash

# migrate lunch
php artisan cache:clear
php artisan migrate

# php-fpm sever lunch
php-fpm