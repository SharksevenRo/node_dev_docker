docker build -t node:cmd -f ./development/share/cmd/Dockerfile .

docker build -t node:entrypoint -f ./development/share/entrypoint/Dockerfile .

docker build -t node:entrypoint-cmd -f ./development/share/Dockerfile .


# docker run -it --name cmd node:cmd
# docker run -it --name entrypoint node:entrypoint

# docker run -it --name entrypoint-cmd node:entrypoint-cmd

# docker run -idt --name development-node -v /Users/sharkseven/HLG/workspace:/root/workspace -p 8084:80 - v ~/.ssh:~/ssh node:development