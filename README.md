# java-starter

## Development

### Requirement

- Java >= 17.*
- docker >= 3.*

### Project Rename

```
chmod +x setup.sh

# First arg: New project name
# Second arg: New package name
# Example: Change project to 'MyProject' and package to 'myservice'
./setup.sh MyProject myservice
```

### Setup

```
git clone https://github.com/teamo2dev/java-starter.git && cd java-starter
cp src/main/resources/application-example.yml src/main/resources/application-local.yml
vim src/main/resources/application-local.yml # edit application-local.yml file
cp docker/example.env docker/local.env
vim docker/local.env # edit local.env file
```

### Local Run

```
docker-compose -f docker-compose.local.yml --env-file docker/local.env up -d (--build)
```

### Production Run

```
cp src/main/resources/application-example.yml src/main/resources/application-prod.yml
vim src/main/resources/application-prod.yml # edit application-prod.yml file with in the prod environment
docker-compose up -d (--build)
```
