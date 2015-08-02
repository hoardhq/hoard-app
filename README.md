# Hoard

Application server for Hoard



## Running Locally

Start off by making sure you have a PostgreSQL server running. The below command may help get started quickly if you don't have one locally:

```
docker run --name postgres -p "5432:5432" --rm -e POSTGRES_USER=hoard -e POSTGRES_PASSWORD=hoard postgres
```

Make sure to have a **.env** file similar to the following:

```
RAILS_ENV=development
PORT=8090
DATABASE_URL=postgresql://hoard:hoard@$DOCKER_HOST/hoard-development
```

Run the following command to start your hoard instance:

```
make run
```

You can attach to the running instance using `make attach` which will allow you use the rails console to create and manage your development database.
