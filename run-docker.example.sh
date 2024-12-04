#!/bin/bash

# Set environment variables
export DATABASE_URL=""

# Run docker-compose
docker-compose down && docker-compose up --build