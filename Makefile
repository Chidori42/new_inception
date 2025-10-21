.PHONY: all build up down logs clean fclean re restart status

all: build up

# Create directories and build images
build:
	mkdir -p /home/ael-fagr/data/wordpress
	mkdir -p /home/ael-fagr/data/mariadb
	cd ./srcs && docker-compose build

# Start services
up:
	cd ./srcs && docker-compose up -d

# Stop services
down:
	cd ./srcs && docker-compose down

# View logs
logs:
	cd ./srcs && docker-compose logs -f

# Clean unused resources
clean: down
	docker volume prune -f
	docker network prune -f
	docker image prune -af
	docker builder prune -af

# Stop and remove everything 
fclean: clean
	cd ./srcs && docker-compose down
	rm -rf /home/ael-fagr/data/wordpress/*
	rm -rf /home/ael-fagr/data/mariadb/*

# Restart services
restart: down up

# Rebuild everything
re: fclean all

# Show service status
status:
	cd ./srcs && docker-compose ps