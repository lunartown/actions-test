# java-starter

## Development

### Requirement
- Java >= 17.*
- docker >= 3.*

### Create New Project

1. Go to GitHub Actions tab in this repository
2. Run 'Create Template Repository' workflow with:
  - Repository name
  - Project name
  - Package name
  - Visibility (private/public)

3. New repository will be automatically created with your settings

### Setup
```
# Enable required dependencies
# 1. Uncomment needed libraries in build.gradle
#    - For MySQL: runtimeOnly 'com.mysql:mysql-connector-j'
#    - For Redis: implementation 'org.springframework.boot:spring-boot-starter-data-redis'
# 2. Uncomment corresponding services in docker-compose.local.yml
#    - For MySQL: Uncomment mysql service section
#    - For Redis: Uncomment redis service section
```
