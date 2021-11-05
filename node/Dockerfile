ARG NODE_BASE_IMAGE_TAG=12-slim

FROM node:${NODE_BASE_IMAGE_TAG} AS sylius_node
RUN apt update && apt install -y python make g++ gcc git
