<p align="center">
    <a href="https://sylius.com" target="_blank">
        <img src="https://demo.sylius.com/assets/shop/img/logo.png" />
    </a>
</p>

<h1 align="center">Sylius Docker Template</h1>

<p align="center">This repository presents initial introduction to Docker in Sylius.</p>

## Docker configuration

Usage:

Build containers with specific environment:

* development `docker-compose up -d --build`
* production `docker-compose -f docker-compose.prod.yaml up -d --build`

Enter specific container in Windows:

* `winpty docker-compose exec service_name bash`

Check build logs of specific container:

* `docker logs container_name`

Log into mysql server from host context:

* `winpty docker-compose exec mysql mysql -h localhost -P 3306 --protocol=tcp -u root -p`

Good to know:

> Current Docker configuration uses only 1 environment file: `.env`, because for now it's impossible to pass variables from multiple configuration files when `build: context` is set in service definition
