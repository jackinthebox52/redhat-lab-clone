# Red Hat Lab Environment

This Docker container simulates a Red Hat practice lab environment with fake `lab` commands that mimic the behavior of actual Red Hat training lab systems.

## What This Container Provides

- **Red Hat UBI 9** base system
- **Student user** with sudo privileges (password: `student`)
- **Fake lab commands** that simulate Red Hat lab start/finish behavior
- **Common development tools** (vim, nano, git, etc.)
- **Pre-configured shell** with useful aliases

## Prerequisites

- Docker installed on your system
- Docker Compose (optional, for the docker-compose method)
- Basic command line knowledge

## Setup Options

### Option 1: Docker CLI (Basic Method)

#### 1. Build the Container

First, save the Dockerfile to a directory and navigate to it:

```bash
# Create a directory for your project
mkdir redhat-lab-env
cd redhat-lab-env

# Save the Dockerfile in this directory
# Then build the container
docker build -t redhat-lab .
```

**What this does:** The `docker build` command reads the Dockerfile and creates a container image named `redhat-lab`.

#### 2. Run the Container

```bash
# Run the container interactively
docker run -it --name lab-session redhat-lab

# Alternative: Run with a custom name
docker run -it --name my-lab-practice redhat-lab
```

**What this does:** 
- `-it` makes the container interactive with a terminal
- `--name` gives your container a friendly name
- `redhat-lab` is the image we built

### Option 2: Docker Compose (Recommended)

#### 1. Create docker-compose.yml

Create a `docker-compose.yml` file in the same directory as your Dockerfile:

```yaml
version: '3.8'

services:
  redhat-lab:
    build: .
    container_name: redhat-lab-environment
    stdin_open: true
    tty: true
    volumes:
      - lab-data:/home/student/lab
      - scripts-data:/home/student/scripts
      - projects-data:/home/student/projects
    networks:
      - lab-network

volumes:
  lab-data:
  scripts-data:
  projects-data:

networks:
  lab-network:
    driver: bridge
```

#### 2. Start with Docker Compose

```bash
# Build and start the container
docker-compose up --build -d

# Connect to the running container
docker-compose exec redhat-lab /bin/bash

# Alternative: Run interactively (no background)
docker-compose run --rm redhat-lab
```

#### 3. Docker Compose Management

```bash
# Start the environment
docker-compose up -d

# Connect to the container
docker-compose exec redhat-lab /bin/bash

# Stop the environment
docker-compose down

# Stop and remove volumes (reset everything)
docker-compose down -v

# View logs
docker-compose logs redhat-lab

# Restart the service
docker-compose restart redhat-lab
```

## Using the Lab Commands

Once inside the container, you'll be logged in as the `student` user. Try the lab commands:

```bash
# Start any lab
lab start edit-bashconfig
lab start networking-basics
lab start any-lab-name

# Finish any lab
lab finish edit-bashconfig
lab finish networking-basics
lab finish any-lab-name

# Invalid usage shows help
lab
lab invalid-command
```

### Expected Output

**Starting a lab:**
```
Starting lab.

 · Checking lab systems ................................................... SUCCESS
 · Creating the temporary file ............................................ SUCCESS
 · Backing up the bashrc file ............................................. SUCCESS
```

**Finishing a lab:**
```
Finishing lab.

 · Checking lab systems ................................................... SUCCESS
 · Removing the temporary file ............................................ SUCCESS
 · Restoring the bashrc file .............................................. SUCCESS
```

## Basic Docker Operations

### Building
- `docker build -t redhat-lab .` - Build the image from Dockerfile
- `docker build -t redhat-lab:v2 .` - Build with a version tag

### Running
- `docker run -it redhat-lab` - Run once and remove after exit
- `docker run -it --name my-lab redhat-lab` - Run with a specific name
- `docker run -it --rm redhat-lab` - Automatically remove container after exit

### Container Management
- `docker ps` - List running containers
- `docker ps -a` - List all containers (including stopped)
- `docker start lab-session` - Restart a stopped container
- `docker attach lab-session` - Reconnect to a running container
- `docker rm lab-session` - Delete a stopped container

### Image Management
- `docker images` - List all images
- `docker rmi redhat-lab` - Delete the image
- `docker system prune` - Clean up unused containers/images

## Example Usage Sessions

### Docker CLI Method
```bash
# Build the image
$ docker build -t redhat-lab .

# Run the container
$ docker run -it --name practice-session redhat-lab

# Inside the container
(labs) [student@workstation ~]$ lab start networking-basics

Starting lab.

 · Checking lab systems ................................................... SUCCESS
 · Creating the temporary file ............................................ SUCCESS
 · Backing up the bashrc file ............................................. SUCCESS

(labs) [student@workstation ~]$ lab finish networking-basics

Finishing lab.

 · Checking lab systems ................................................... SUCCESS
 · Removing the temporary file ............................................ SUCCESS
 · Restoring the bashrc file .............................................. SUCCESS

(labs) [student@workstation ~]$ exit

# Back on host system
$ docker start practice-session
$ docker attach practice-session
```

### Docker Compose Method
```bash
# Start the environment
$ docker-compose up --build -d
Creating network "redhat-lab-env_lab-network" with the default driver
Creating volume "redhat-lab-env_lab-data" with default driver
Creating volume "redhat-lab-env_scripts-data" with default driver
Creating volume "redhat-lab-env_projects-data" with default driver
Building redhat-lab
Successfully built abc123def456
Creating redhat-lab-environment ... done

# Connect to the container
$ docker-compose exec redhat-lab /bin/bash

# Inside the container
(labs) [student@workstation ~]$ lab start security-basics

Starting lab.

 · Checking lab systems ................................................... SUCCESS
 · Creating the temporary file ............................................ SUCCESS
 · Backing up the bashrc file ............................................. SUCCESS

(labs) [student@workstation ~]$ exit

# Stop the environment
$ docker-compose down
Stopping redhat-lab-environment ... done
Removing redhat-lab-environment ... done
Removing network redhat-lab-env_lab-network
```

## Container Features

### User Setup
- **Username:** `student`
- **Password:** `student`  
- **Sudo access:** Yes (passwordless)
- **Home directory:** `/home/student`

### Pre-installed Tools
- Text editors: vim, nano
- Development: git, wget
- System utilities: tar, gzip, unzip, which, man
- Network tools: net-tools
- Process management: procps-ng

### Shell Configuration
- Custom prompt showing `[user@host directory]$`
- Useful aliases:
  - `ll` = `ls -la`
  - `la` = `ls -A` 
  - `l` = `ls -CF`

### Directory Structure
- `~/lab` - Lab exercises directory
- `~/scripts` - Shell scripts directory
- `~/projects` - Practice projects directory

## Docker Compose Benefits

Using Docker Compose provides several advantages:

- **Persistent volumes**: Your work in `~/lab`, `~/scripts`, and `~/projects` persists between container restarts
- **Easy management**: Simple commands to start, stop, and manage the environment
- **Networking**: Isolated network for the lab environment
- **Configuration**: Easy to modify and extend the setup
- **Reproducibility**: Consistent environment setup across different machines

## File Structure

Your project directory should look like this:

```
redhat-lab-env/
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Troubleshooting

### Container won't start
- Make sure Docker is running: `docker --version`
- Check if image built successfully: `docker images`
- For compose: `docker-compose ps` to check service status

### Can't reconnect to container

**Docker CLI:**
- List containers: `docker ps -a`
- Start stopped container: `docker start <container-name>`
- Attach to running container: `docker attach <container-name>`

**Docker Compose:**
- Check status: `docker-compose ps`
- Start services: `docker-compose up -d`
- Connect: `docker-compose exec redhat-lab /bin/bash`

### Lab commands not working
- Make sure you're using: `lab start <name>` or `lab finish <name>`
- Try: `source ~/.bashrc` to reload the shell configuration
- Check if the function was added: `type lab`

### Permission issues
- The student user has sudo access: `sudo <command>`
- Password is `student` if prompted

### Reset everything

**Docker CLI:**
```bash
# Remove container and image, start fresh
docker rm -f lab-session
docker rmi redhat-lab
docker build -t redhat-lab .
docker run -it --name lab-session redhat-lab
```

**Docker Compose:**
```bash
# Complete reset including volumes
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## Customization

### Modifying Lab Commands

To modify the lab outputs or add new functionality, edit the `printf` section in the Dockerfile:

```dockerfile
RUN printf 'lab() {\n if [ "$1" = "start" ]; then\n echo\n echo "Starting lab."\n # Add your custom output here\n fi\n}\n' >> ~/.bashrc
```

Then rebuild:
- **Docker CLI:** `docker build -t redhat-lab .`
- **Docker Compose:** `docker-compose build --no-cache`

### Adding New Services

You can extend the `docker-compose.yml` to add additional services like databases or web servers:

```yaml
services:
  redhat-lab:
    # existing configuration...
  
  database:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: student
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  lab-data:
  scripts-data:
  projects-data:
  db-data:
```

### Persistent Configuration

To make additional configuration persistent, add volume mounts in `docker-compose.yml`:

```yaml
volumes:
  - ./host-configs:/home/student/configs
  - lab-data:/home/student/lab
```

## Contributing

To contribute improvements:

1. Fork or clone the repository
2. Make changes to the Dockerfile or docker-compose.yml
3. Test your changes: `docker-compose up --build`
4. Document any new features in this README

## License

This project is for educational purposes and simulates Red Hat training environments.