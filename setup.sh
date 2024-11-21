#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "사용법: $0 [새_프로젝트명] [새_패키지명]"
    echo "예시: $0 new-project-api new-project"
    exit 1
fi

OLD_PROJECT=Template
NEW_PROJECT=$1
NEW_PACKAGE=$2

# 소문자 변환
OLD_PROJECT_LOWER=$(echo $OLD_PROJECT | tr '[:upper:]' '[:lower:]')
NEW_PROJECT_LOWER=$(echo $NEW_PROJECT | tr '[:upper:]' '[:lower:]')
OLD_PACKAGE=${OLD_PROJECT_LOWER//-/.}
OLD_PACKAGE_PATH=${OLD_PACKAGE//./\/}
NEW_PACKAGE_PATH=${NEW_PACKAGE//./\/}

echo "프로젝트명 변경: $OLD_PROJECT -> $NEW_PROJECT"

# Gradle 설정 변경
[ -f "settings.gradle" ] && sed -i "s/rootProject.name.*=.*'$OLD_PROJECT_LOWER'/rootProject.name = '$NEW_PROJECT_LOWER'/" settings.gradle
[ -f "build.gradle" ] && sed -i "s/group.*=.*'.*'/group = 'com.$NEW_PACKAGE'/" build.gradle
[ -f "build.gradle" ] && sed -i "s/artifactId.*=.*'$OLD_PROJECT_LOWER'/artifactId = '$NEW_PROJECT_LOWER'/" build.gradle

# Properties/YML 파일 변경
find ./src -type f \( -name "*.properties" -o -name "*.yml" \) -exec sed -i \
    -e "s/spring.application.name=$OLD_PROJECT/spring.application.name=$NEW_PROJECT/" \
    -e "s/kr\/.$OLD_PACKAGE/kr\/teamo2.$NEW_PACKAGE/" {} +

# Java 파일 내용 변경
find ./src -type f -name "*.java" -exec sed -i \
    -e "s/class ${OLD_PROJECT}Application/class ${NEW_PROJECT}Application/" \
    -e "s/run(${OLD_PROJECT}Application.class/run(${NEW_PROJECT}Application.class/" \
    -e "s/package kr.teamo2.$OLD_PROJECT_LOWER/package kr.teamo2.$NEW_PROJECT_LOWER/" \
    -e "s/import kr.teamo2.$OLD_PROJECT_LOWER/import kr.teamo2.$NEW_PROJECT_LOWER/" \
    -e "s/$OLD_PROJECT/$NEW_PROJECT/g" {} +

# 디렉토리 구조 변경
for dir in "main" "test"; do
    OLD_DIR="src/$dir/java/kr/teamo2/$OLD_PACKAGE_PATH"
    NEW_DIR="src/$dir/java/kr/teamo2/$NEW_PACKAGE_PATH"
    if [ -d "$OLD_DIR" ]; then
        mkdir -p "$NEW_DIR"
        cp -r $OLD_DIR/* "$NEW_DIR/"
        rm -rf "$OLD_DIR"
    fi
done

# 파일명 변경
find ./src -type f -name "*$OLD_PROJECT*" | while read FILE; do
    NEW_FILE=$(echo $FILE | sed "s/$OLD_PROJECT/$NEW_PROJECT/g")
    if [ "$FILE" != "$NEW_FILE" ]; then
        mkdir -p "$(dirname "$NEW_FILE")"
        mv "$FILE" "$NEW_FILE"
        OLD_DIR=$(dirname "$FILE")
        [ -z "$(ls -A $OLD_DIR)" ] && rm -r "$OLD_DIR"
    fi
done

# Docker Compose 파일 변경
for file in docker-compose.yml docker-compose.local.yml; do
    [ -f "$file" ] && sed -i \
        -e "s/${OLD_PROJECT_LOWER}/${NEW_PROJECT_LOWER}/g" \
        -e "s/${OLD_PROJECT_LOWER}_mongo_db/${NEW_PROJECT_LOWER}_mongo_db/g" \
        -e "s/${OLD_PROJECT_LOWER}_mysql_db/${NEW_PROJECT_LOWER}_mysql_db/g" "$file"
done

echo "프로젝트 이름 변경이 완료되었습니다!"
echo "1. IDE에서 프로젝트를 다시 불러오세요"
echo "2. 프로젝트를 새로 빌드해보세요"
echo "3. 자동 변경되지 않은 부분이 있을 수 있으니 확인해주세요"
