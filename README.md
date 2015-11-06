# dockerized-storm

Scripts to launch [Storm](http://storm.apache.org/) servers via [docker-compose](https://docs.docker.com/compose/) or [docker](https://docs.docker.com/)

The folders contain Dockerfiles to install and launch
- nimbus 
- supervisor
- ui

Additionally, the main `docker-compose.yml` launches [ZooKeeper](https://zookeeper.apache.org/) and [Kafka](http://kafka.apache.org/); and the `storm` folder contains a base container from which `nimbus`, `supervisor` and `ui` extend.

## Basic use

0. Install [docker-compose](https://docs.docker.com/compose/) (which requires [docker](https://docs.docker.com/installation/) itself).
1. `docker-compose up kzk &`
2. (wait for above command to report that ZooKeeper and Kafka are up and running)
3. `docker-compose up nimbus &`
4. (wait for nimbus to be up and running)
5. `docker-compose up ui supervisor &`

You can check that everything is working by pointing a browser at `localhost:8081` (storm-ui). Ports can be easily altered by modifying `docker-compose.yml` (eg.: changing the `ui` port to `8081:8082` would expose it on `localhost:8082` instead.

## Dependencies

`docker-compose` simplifies launching several linked containers. In our case,  `nimbus` requires `kzk` (actually, only ZooKeeper); and `supervisor`, `ui` require both `nimbus` and `kzk` (again, only ZooKeeper).

Unfortunately, there is no built-in way to make `docker-compose` wait for a service to be up and ready before launching another service. Hence, wait-steps 2 and 3 in the "Basic use" section.

## Scaling up

For truly large deployments, redundant zookeeper servers would be required. This is currently not supported. You can, however, scale up the actual storm worker nodes by launching several supervisor instances. For example:

`docker-compose scale supervisor=3 && docker-compose up supervisor`

Results in 3 supervisor nodes, with 4 worker nodes each, for a grand total of 12 nodes.
