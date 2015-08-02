build:
	docker build -t hoardhq/hoard-app .

run:
	docker run --env-file .env -h "hoard-app-development" -a STDOUT -p "80:8090" -i --rm --name hoard-app hoardhq/hoard-app

attach:
	docker exec -i -t hoard-app bash

bash:
	docker run --env-file .env -h "hoard-app-development" -i --rm --name hoard-app-bash hoardhq/hoard-app bash
