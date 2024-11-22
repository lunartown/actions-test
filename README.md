# java-starter

## Development

### Requirement

- Java >= 17.*
- docker >= 3.*

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
