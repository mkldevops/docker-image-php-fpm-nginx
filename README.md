# Dockerfile README

This Dockerfile is designed to create a PHP-FPM container with Nginx, Composer, and various PHP extensions. The container can be used for development purposes and comes in two variants: `builder` and `dev`.

## Base Variant

### Description

The `base` variant serves as the foundation for both the `builder` and `dev` variants. It includes PHP-FPM (version specified by the `PHP_VERSION` build argument), Nginx, and other necessary dependencies.

### Installed PHP Extensions

The following PHP extensions are installed in the `base` variant:
- `@composer`: Composer package manager
- `apcu`: APCu extension
- `intl`: Internationalization extension
- `opcache`: OPcache extension
- `pdo_mysql`: PDO MySQL driver
- `sysvsem`: SysV semaphore support
- `uuid`: UUID
- `xsl`: XSL extension

### Nginx Configuration

Nginx is configured with the following files:
- `nginx.conf`: Main Nginx configuration file
- `conf.d`: Additional configuration files for Nginx (default server)

### PHP-FPM Configuration

PHP-FPM is configured with the following files:
- `www.conf`: PHP-FPM pool configuration
- `custom.ini`: Custom PHP configuration file

### Supervisord Configuration

Supervisord is configured with the following file:
- `supervisord.conf`: Supervisord configuration for managing Nginx and PHP-FPM processes

### Exposed Port

The container exposes port 8080, which is used by Nginx.

### User Permissions

The necessary files and folders required by the processes are made accessible to the `nobody` user.

### Usage

To run the `base` variant, use the following command:
```
docker build -t my_php_fpm_image .
docker run -p 8080:8080 my_php_fpm_image
```

## Builder Variant

### Description

The `builder` variant extends the `base` variant and additionally includes the `pcov` PHP extension. This variant is suitable for building and testing purposes.

### Installed PHP Extensions (Additional to Base)

- `pcov`: PCOV extension for code coverage analysis

### Usage

To run the `builder` variant, use the following command:
```
docker build -t my_php_fpm_builder_image -f Dockerfile --target=builder .
```

## Dev Variant

### Description

The `dev` variant extends the `base` variant and includes Xdebug 3.2 for debugging purposes. This variant is ideal for development and debugging purposes.

### Installed PHP Extensions (Additional to Base)

- `xdebug-^3.2`: Xdebug version 3.2 for PHP debugging

### Usage

To run the `dev` variant, use the following command:
```
docker build -t my_php_fpm_dev_image -f Dockerfile --target=dev .
```

Please note that you can customize the `Dockerfile` and configurations according to your specific needs.

For any additional information or questions, feel free to reach out!

**Happy coding!**
