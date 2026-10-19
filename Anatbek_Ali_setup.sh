#!/bin/bash
# Run in Google Cloud Shell:  bash Anatbek_Ali_setup.sh
set -e
S=Anatbek; N=Ali; G=IT2-2309; ID=41505
P=~/devops/anatbek_ali
mkdir -p $P/{app,scripts,config,logs,backup}; cd $P; pwd; ls
printf "Name: $N\nSurname: $S\nGroup: $G\nStudent ID: $ID\nCourse: DevOps\n" > Anatbek_Ali_info.txt
printf "APP_NAME=anatbek-ali-devops\nAPP_PORT=8080\nENV=development\n" > config/app.conf
cat > logs/application.log <<L
INFO Application started
INFO User logged in
WARNING Configuration file missing
INFO Database connected
ERROR Database connection failed
INFO Application restarted
WARNING Memory usage is high
INFO Request received
ERROR Request failed
INFO Application stopped
L
cat Anatbek_Ali_info.txt; head -3 Anatbek_Ali_info.txt; tail -5 logs/application.log
touch temp.txt; cp temp.txt backup/temp_copy.txt; mv temp.txt renamed.txt; rm renamed.txt; ls -R
# Task 2
find . -name application.log; grep ERROR logs/application.log; grep WARNING logs/application.log
grep -c ERROR logs/application.log; tail -5 logs/application.log
# Task 3
echo "private data" > private.txt; echo "public data" > public.txt
chmod 600 private.txt; chmod 644 public.txt; ls -l private.txt public.txt
# Task 4
cat > scripts/Anatbek_Ali_system.sh <<'SH'
#!/bin/bash
echo "=============================="; echo "Student Information"; echo "=============================="
echo "Name: Ali"; echo "Surname: Anatbek"; echo "Group: IT2-2309"; echo "Student ID: 41505"
echo "=============================="; echo "System Information"; echo "=============================="
echo "Username: $(whoami)"; echo "Hostname: $(hostname)"; echo "Current Date: $(date)"
echo "Operating System: $(uname -s -r)"; echo "Disk Usage:"; df -h / ; echo "Memory Usage:"; free -h
if [ -f ~/devops/anatbek_ali/Anatbek_Ali_info.txt ]; then
  echo "Student information file exists."
else
  echo "Student information file does not exist."
fi
SH
chmod +x scripts/Anatbek_Ali_system.sh; ./scripts/Anatbek_Ali_system.sh
# Task 5
ps; ps -o pid,user,%cpu,%mem,cmd -p $$; ps aux | head -5; top -b -n 1 | head -12
# Git
git init -b main
git config --global user.name "Ali Anatbek"
git config --global user.email "aligalymuli@users.noreply.github.com"
git status
git add app scripts config 2>/dev/null; touch app/.gitkeep config/.gitkeep; git add app config; git commit -m "Initial project structure"
git add Anatbek_Ali_info.txt; git commit -m "Add student information"
git add scripts/Anatbek_Ali_system.sh; git commit -m "Add Linux system script"
printf "*.log\nbackup/\n.env\n" > .gitignore; echo "SECRET=123" > .env
git add .gitignore; git commit -m "Add .gitignore"
git status; git check-ignore -v logs/application.log backup/ .env
git add config/app.conf private.txt public.txt; git commit -m "Add project configuration and permission demo files"
git branch development; git switch development
cat > app/app.sh <<'SH'
#!/bin/sh
echo "================================"
echo "DevOps Student Application"
echo "================================"
echo "Name: ${STUDENT_NAME:-Ali}"
echo "Surname: ${STUDENT_SURNAME:-Anatbek}"
echo "Group: ${STUDENT_GROUP:-IT2-2309}"
echo "Student ID: ${STUDENT_ID:-41505}"
echo "Application is running successfully!"
SH
chmod +x app/app.sh; git add app/app.sh; git commit -m "Add student application script"
git switch main; git merge --no-ff development -m "Merge branch development"
git branch; git log --oneline --graph
# Docker
cat > Dockerfile <<'D'
FROM alpine:3.20
WORKDIR /app
COPY app/app.sh /app/app.sh
RUN chmod +x /app/app.sh
EXPOSE 8080
CMD ["/app/app.sh"]
D
cat > docker-compose.yml <<'D'
services:
  app:
    build: .
    image: anatbek-ali-devops
    container_name: anatbek-ali-container
    environment:
      STUDENT_NAME: Ali
      STUDENT_SURNAME: Anatbek
      STUDENT_GROUP: IT2-2309
      STUDENT_ID: "41505"
    ports:
      - "8080:8080"
D
cat > Jenkinsfile <<'D'
pipeline {
  agent any
  environment {
    STUDENT_NAME = 'Ali'; STUDENT_SURNAME = 'Anatbek'
    STUDENT_GROUP = 'IT2-2309'; STUDENT_ID = '41505'
    IMAGE = 'anatbek-ali-devops'; CONTAINER = 'anatbek-ali-container'
  }
  stages {
    stage('Checkout') { steps { checkout scm; sh 'git log -1 --oneline' } }
    stage('Build') { steps { sh 'echo "Student: $STUDENT_NAME $STUDENT_SURNAME, Group: $STUDENT_GROUP, Student ID: $STUDENT_ID"'; sh 'ls -la' } }
    stage('Test') { steps { sh 'test -f Dockerfile && test -f app/app.sh && test -f Anatbek_Ali_info.txt && echo "All checks passed"' } }
    stage('Docker Build') { steps { sh 'docker build -t $IMAGE .' } }
    stage('Docker Run') { steps { sh 'docker rm -f $CONTAINER || true'; sh 'docker run --name $CONTAINER -e STUDENT_NAME -e STUDENT_SURNAME -e STUDENT_GROUP -e STUDENT_ID $IMAGE' } }
  }
  post { success { echo 'Pipeline finished successfully' } failure { echo 'Pipeline failed' } }
}
D
git add Dockerfile docker-compose.yml; git commit -m "Add Docker configuration"
git add Jenkinsfile; git commit -m "Add Jenkinsfile pipeline"
git log --oneline
docker build -t anatbek-ali-devops . ; docker images
docker rm -f anatbek-ali-container 2>/dev/null || true
docker run --name anatbek-ali-container anatbek-ali-devops; docker ps; docker ps -a; docker rm anatbek-ali-container
docker run -e STUDENT_NAME=Ali -e STUDENT_SURNAME=Anatbek -e STUDENT_GROUP=IT2-2309 -e STUDENT_ID=41505 --name anatbek-ali-container anatbek-ali-devops
docker logs anatbek-ali-container; docker start -a anatbek-ali-container; docker stop anatbek-ali-container; docker rm anatbek-ali-container
docker compose up; docker compose ps -a; docker compose down
echo; echo "DONE. Now: git remote add origin https://github.com/aligalymuli-jpg/anatbek-ali-devops.git && git push -u origin main && git push origin development"
