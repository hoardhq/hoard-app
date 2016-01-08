# Hoard

Application server for Hoard



## Running Locally


### Using single docker container

Start off by making sure you have a PostgreSQL server running. The below command may help get started quickly if you don't have one locally:

```
docker run --name postgres -p "5432:5432" --rm -e POSTGRES_USER=hoard -e POSTGRES_PASSWORD=hoard postgres
```

Make sure to have a **.env** file similar to the following:

```
RAILS_ENV=development
PUMA_BIND=unix:/var/run/project-sockets/hoardhq-hoard-app
DATABASE_URL=postgresql://hoard:hoard@$DOCKER_HOST/hoard-development
```

Run the following command to start your hoard instance:

```
make run
```

You can attach to the running instance using `make attach` which will allow you use the rails console to create and manage your development database.


### Default User Login

The default user can be accessed via **user@example.com** with password **password**. New users can be added directly via the Rails console via the `User` model.


### User docker-compose

```
docker-compose build
docker-compose up
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
```

Quickly jump into a rails console using:

```
docker-compose run web rails c
```
