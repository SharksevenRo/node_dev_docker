docker build -t node:cmd -f ./development/share/cmd/Dockerfile .

docker build -t node:entrypoint -f ./development/share/entrypoint/Dockerfile .

docker build -t node:entrypoint-cmd -f ./development/share/Dockerfile .


docker run -idt node:cmd /bin/echo
