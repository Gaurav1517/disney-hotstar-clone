# Disney Hotstar UI Clone

Hotstar-Disney+ UI clone using ReactJS
---

![snap](src/images/snap.png)


Most Simple Project you can do when ypu start studying ReactJS.It is only made using ReactJS.

## Installation

need to install git and npm in system

```
git clone https://github.com/Gaurav1517/disney-hotstar-clone.git

cd disney-hotstar-clone

npm i

npm start

```


#  Dockerize Disney Hotstar Clone application

This is a simple Disney Hotstar clone built using React. The application is containerized using Docker and can be easily run using Docker Compose.

## Prerequisites

- Docker: Make sure Docker is installed on your system. You can follow the installation guide here: [Docker Installation](https://docs.docker.com/get-docker/).
- Docker Compose: Docker Compose is required to build and manage multi-container applications. Install it from here: [Docker Compose Installation](https://docs.docker.com/compose/install/).

## Setup and Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/your-repository-url/disney-hotstar-clone.git
    cd disney-hotstar-clone
    ```

2. Build and start the application using Docker Compose:
    ```bash
    docker-compose up --build -d
    ```

    - `--build`: Rebuilds the images if any changes were made.
    - `-d`: Runs the containers in detached mode (background).

3. After the containers are up, open your browser and go to `http://localhost:3000` to view the application.

## How it Works

- **Dockerfile**: The Dockerfile builds a Node.js container that installs dependencies, builds the React application, and runs it on port 3000.
- **docker-compose.yml**: The Docker Compose file defines the services, including the Disney Hotstar React application. It also sets the environment variable `NODE_OPTIONS` to avoid OpenSSL errors when building the app.

## Docker Compose Configuration

The `docker-compose.yml` file defines a single service named `disney-hotstar`, which:

- Uses the current directory (`.`) as the build context.
- Maps port 3000 of the container to port 3000 on the host.
- Sets the environment variable `NODE_OPTIONS=--openssl-legacy-provider` to fix OpenSSL-related issues when running the app.

```yaml
version: '3.8'
services:
  disney-hotstar:
    build:
      context: .
    ports:
      - "3000:3000"
    environment:
      - NODE_OPTIONS=--openssl-legacy-provider
```

## Dockerfile Configuration

The `Dockerfile` is responsible for creating the Docker image for the React app. It:

- Uses `node:18-alpine` as the base image.
- Sets the working directory to `/app` and copies `package.json` and `package-lock.json`.
- Installs the dependencies using `npm install`.
- Copies the entire project and sets the environment variable for OpenSSL.
- Builds the application using `npm run build`.
- Exposes port 3000 and starts the application using `npm start`.

```Dockerfile
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Set Node.js environment variable to fix OpenSSL error
ENV NODE_OPTIONS="--openssl-legacy-provider"

# Build the application for production
RUN npm run build

# Expose the desired port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
```

## Troubleshooting

- If you encounter an error related to OpenSSL during the build process, the environment variable `NODE_OPTIONS=--openssl-legacy-provider` is already set in the Dockerfile to fix this.
- Make sure that Docker and Docker Compose are installed correctly on your system.

## Stopping and Cleaning Up

To stop the running containers and remove them, use the following command:

```bash
docker-compose down
```

This will stop and remove the containers, network, and volumes created by Docker Compose.

