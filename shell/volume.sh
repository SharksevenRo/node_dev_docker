docker run -v /Users/sharkseven/data --name db alpine
docker run --volumes-from volumes-docker -v /Users/sharkseven/data:/root/workspace --name volumes alpine