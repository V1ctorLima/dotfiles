# Makefile for dotfiles Docker testing

.PHONY: help build test test-auto clean shell logs stop remove-containers

# Default target
help: ## Show this help message
	@echo "Dotfiles Docker Testing Commands:"
	@echo "================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	@echo "🏗️  Building Docker image..."
	docker-compose build dotfiles-test

test: build ## Run interactive test shell
	@echo "🧪 Starting interactive test environment..."
	docker-compose run --rm dotfiles-test /bin/bash -c "./interactive-welcome.sh && exec /bin/zsh"

test-auto: build ## Run automated tests
	@echo "🤖 Running automated dotfiles tests..."
	docker-compose run --rm dotfiles-test-auto

test-deploy: build ## Deploy dotfiles and start interactive shell
	@echo "🚀 Deploying dotfiles and starting interactive shell..."
	docker-compose run --rm dotfiles-test /bin/bash -c "./interactive-welcome.sh && stow --verbose --adopt --target=\"\$$HOME\" . && echo '✅ Dotfiles deployed! Starting ZSH...' && exec /bin/zsh"

shell: build ## Start an interactive shell in the container
	@echo "🐚 Starting interactive shell..."
	docker-compose run --rm dotfiles-test /bin/bash

zsh: build ## Start an interactive zsh shell in the container
	@echo "🐚 Starting interactive zsh shell..."
	docker-compose run --rm dotfiles-test /bin/zsh

logs: ## Show logs from running containers
	docker-compose logs -f

stop: ## Stop all running containers
	@echo "🛑 Stopping containers..."
	docker-compose down

clean: stop ## Clean up containers and images
	@echo "🧹 Cleaning up..."
	docker-compose down --rmi all --volumes --remove-orphans
	docker system prune -f

remove-containers: ## Remove all containers (keeps images)
	@echo "🗑️  Removing containers..."
	docker-compose down --volumes --remove-orphans

# Development helpers
dev-build: ## Build without cache for development
	@echo "🔄 Building without cache..."
	docker-compose build --no-cache dotfiles-test

dev-test: dev-build ## Build without cache and run tests
	@echo "🔄 Fresh build and test..."
	docker-compose run --rm dotfiles-test-auto

# Stow-specific helpers
stow-deploy: build ## Test stow deployment in container
	@echo "📦 Testing stow deployment..."
	docker-compose run --rm dotfiles-test /bin/bash -c "mkdir -p /home/testuser/.cache/zsh /home/testuser/.local/bin /home/testuser/Projects && cd /home/testuser/dotfiles && stow --verbose --adopt --target=/home/testuser ."

stow-remove: build ## Test stow removal in container
	@echo "🗑️  Testing stow removal..."
	docker-compose run --rm dotfiles-test /bin/bash -c "cd /home/testuser/dotfiles && stow --verbose --target=/home/testuser -D ."

# Debugging helpers
debug: build ## Start container with debugging tools
	@echo "🔍 Starting debug session..."
	docker-compose run --rm dotfiles-test /bin/bash -c "echo 'Debug mode - container ready' && /bin/bash"

inspect: ## Inspect the built image
	@echo "🔍 Inspecting Docker image..."
	docker-compose run --rm dotfiles-test /bin/bash -c "echo '=== System Info ===' && uname -a && echo '=== Installed Packages ===' && dpkg -l | grep -E '(stow|zsh|vim|git)' && echo '=== User Info ===' && whoami && pwd && ls -la"
