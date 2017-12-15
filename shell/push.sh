docker login --username=937257166@qq.com registry.cn-hangzhou.aliyuncs.com -paixrslwh1993

docker tag $(docker commit  -m "deploy"  $1) registry.cn-hangzhou.aliyuncs.com/sharkseven/deploy:$2

docker push registry.cn-hangzhou.aliyuncs.com/sharkseven/deploy:$2