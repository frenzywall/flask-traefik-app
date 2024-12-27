STACK_NAME = flask-traefik-stack
COMPOSE_FILE = docker-compose.yml

.PHONY: deploy monitor stop scale clean

deploy:
	@echo "Initializing Docker Swarm..."
	docker swarm init || echo "Swarm already initialized."
	@echo "Deploying the stack..."
	docker stack deploy -c $(COMPOSE_FILE) $(STACK_NAME)
	@echo "Deployment complete. You can monitor the services with 'make monitor'."

monitor:
	@echo "Listing services in the stack..."
	docker service ls
	@echo "Inspecting replicas for flask-app service..."
	docker service ps $(STACK_NAME)_flask-app
	@echo "Access the Traefik dashboard at http://localhost:8080"

stop:
	@echo "Stopping and removing the stack..."
	docker stack rm $(STACK_NAME)
	@echo "Stack removed. Use 'make clean' to clean up Docker Swarm."

scale:
	@read -p "Enter the number of replicas for flask-app: " REPLICAS; \
	if [ -z "$$REPLICAS" ]; then \
		echo "No replicas specified. Aborting."; \
		exit 1; \
	fi; \
	echo "Scaling flask-app to $$REPLICAS replicas..."; \
	docker service scale $(STACK_NAME)_flask-app=$$REPLICAS

roll_update:
	@echo "To roll an updates, use the command you copied after pushing the image to GHCR.;" \
	echo "Should looks something like this: "; \
	echo "docker service update --image ghcr.io/frenzywall/flask-traefik-app:v0.2 flask-traefik-stack_flask-app"
clean:
	@echo "Leaving Docker Swarm..."
	@docker swarm leave --force || echo "Not in a swarm."
	@echo "Cleanup complete."

help:
	@echo "Available targets:"
	@echo "  deploy      - Initializes Docker Swarm, deploys the stack using the provided docker-compose file."
	@echo "  monitor     - Lists services in the stack and inspects replicas for flask-app."
	@echo "  stop        - Stops and removes the stack from Docker Swarm."
	@echo "  scale       - Prompts for the number of replicas and scales the flask-app service accordingly."
	@echo "  roll_update - Provides the command to roll an update for the flask-app service using a new image."
	@echo "  clean       - Leaves the Docker Swarm and performs any necessary cleanup."
	@echo "  help        - Displays this help message."