#!/bin/bash

echo "Initial setup for Docker image building"
echo "======================================="

echo "Please enter your GitHub username:"
read -r GHCR_USER

echo "Please enter the custom image name (e.g., flask-traefik-app):"
read -r CUSTOM_IMAGE_NAME

echo "Please enter your GitHub Personal Access Token with write permissions. ctrl+shift+v to paste (GHCR_PAT):"
read -r -s GHCR_PAT
echo

mkdir -p .credentials

echo "GHCR_USER=$GHCR_USER" > .credentials/build.env
echo "CUSTOM_IMAGE_NAME=$CUSTOM_IMAGE_NAME" >> .credentials/build.env
echo "IMAGE_NAME=ghcr.io/$GHCR_USER/$CUSTOM_IMAGE_NAME" >> .credentials/build.env


echo "Logging in to GitHub Container Registry..."
echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USER" --password-stdin


echo "Generating Makefile..."
{
    
    echo "include .credentials/build.env"

    sed "s/{{GHCR_USER}}/$GHCR_USER/g; s/{{CUSTOM_IMAGE_NAME}}/$CUSTOM_IMAGE_NAME/g" Makefile.template
} > Makefile

if [ ! -f version.txt ]; then
    echo "v0" > version.txt
fi

echo "Configuration complete! You can now use 'make build' to build your image."
