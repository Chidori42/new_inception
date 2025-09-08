.PHONY: all build up down logs clean fclean re restart status

# Default target
all: build up

# Create directories and build images
build:
	mkdir -p /home/ael-fagr/data/wordpress
	mkdir -p /home/ael-fagr/data/mariadb
	cd ./srcs && docker-compose build

# Start services
up:
	cd ./srcs && docker-compose up -d

# Start services with build
start: build up

# Stop services
down:
	cd ./srcs && docker-compose down

# Stop and remove everything (volumes, networks, images)
fclean:
	cd ./srcs && docker-compose down -v --rmi all --remove-orphans
	docker system prune -af --volumes
	rm -rf /home/ael-fagr/data/wordpress/*
	rm -rf /home/ael-fagr/data/mariadb/*

# View logs
logs:
	cd ./srcs && docker-compose logs -f

# Clean unused resources
clean: down
	docker volume prune -f
	docker network prune -f
	docker image prune -af
	docker builder prune -af

# Restart services
restart: down up

# Rebuild everything
re: fclean all

# Show service status
status:
	cd ./srcs && docker-compose ps