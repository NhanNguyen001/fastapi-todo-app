#!/bin/bash

# Set environment variables
export DATABASE_URL="postgresql://hdb3:1_Abc_123@database-1.cfpkdzshm4yq.ap-southeast-1.rds.amazonaws.com/TodoApplicationDatabase"

# Run docker-compose
docker-compose down && docker-compose up --build