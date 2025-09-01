include srcs/.env

COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker-compose -f $(COMPOSE_FILE)

# Volumes
DB_VOLUME = /home/$(USER)/data/mariadb
WP_VOLUME = /home/$(USER)/data/wordpress
ADMINER_VOLUME = /home/$(USER)/data/adminer
VOLUMES = $(DB_VOLUME) $(WP_VOLUME) $(ADMINER_VOLUME)

# Colors
GREEN = \033[0;32m
RED = \033[0;31m
ORANGE = \033[0;33m
BLUE = \033[38;5;33m
CYAN = \033[38;5;39m
PURPLE = \033[38;5;63m
RESET = \033[0m

# Project info
all: header hostsed_add build

header:
	@echo "$(ORANGE)🚀 Starting Inception...$(RESET)"

# ------------------------------------------------------------------------

create_volume:
	@echo "$(CYAN)📦 Creating local volumes...$(RESET)"
	@mkdir -p $(VOLUMES)

delete_volume:
	@echo "$(RED)🗑️  Deleting local volumes...$(RESET)"
	@sudo rm -rf $(VOLUMES)

check_hostsed:
	@dpkg -s hostsed >/dev/null 2>&1 || (echo "$(ORANGE)📥 hostsed not found, installing...$(RESET)" && sudo apt update && sudo apt install -y hostsed)

hostsed_add: check_hostsed
	@sudo hostsed add 127.0.0.1 $(DOMAIN_NAME) > /dev/null
	@echo "$(GREEN)🔗 $(DOMAIN_NAME) added to hosts.$(RESET)"

hostsed_rm: check_hostsed
	@sudo hostsed rm 127.0.0.1 $(DOMAIN_NAME) > /dev/null
	@echo "$(RED)🔌 $(DOMAIN_NAME) removed from hosts.$(RESET)"

# ------------------------------------------------------------------------

build: create_volume
	@echo "$(CYAN)🔧 Building containers...$(RESET)"
	@$(COMPOSE) up --build -d

up:
	@echo "$(CYAN)⬆️  Starting services...$(RESET)"
	@$(COMPOSE) up -d

down:
	@echo "$(RED)⬇️  Stopping services...$(RESET)"
	@$(COMPOSE) down

stop:
	@echo "$(RED)⏹️  Stopping containers...$(RESET)"
	@$(COMPOSE) stop
	@echo "$(RED)🛑 Containers stopped.$(RESET)"

start:
	@echo "$(GREEN)▶️  Starting containers...$(RESET)"
	@$(COMPOSE) start
	@echo "$(GREEN)🟢 Containers started.$(RESET)"

restart: stop start
	@echo "$(ORANGE)🔁 Containers restarted.$(RESET)"

# ------------------------------------------------------------------------

clean: down delete_volume
	@echo "$(RED)🧹 Cleaning Docker images...$(RESET)"
	@docker rmi -f nginx:inception mariadb:inception wordpress:inception static:inception redis:inception adminer:inception ftp:inception lazydocker:inception 2>/dev/null || true
	@echo "$(GREEN)✅ Clean complete.$(RESET)"

fclean: clean
	@echo "$(RED)💣 Full clean — removing Docker volumes, networks, images...$(RESET)"
	@docker container prune -f
	@docker volume prune -f
	@docker network prune -f
	@docker image prune -a -f
	@echo "$(YELLOW)🗑️  Removing ~/data directory...$(RESET)"
	@echo "$(GREEN)🧨 Docker system reset complete + data directory removed.$(RESET)"


re: clean build
	@echo "$(GREEN)🔄 Rebuild finished.$(RESET)"

# ------------------------------------------------------------------------

.PHONY: all hostsed_add hostsed_rm up down stop start restart re clean fclean create_volume delete_volume header