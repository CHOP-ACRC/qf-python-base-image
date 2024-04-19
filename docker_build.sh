version="1.0.0"

# build qf-r-base
cd ./qf-python-base/$version
docker buildx build --platform linux/amd64,linux/arm64 --push -t pcornetqf/qf-python-base:$version -t pcornetqf/qf-python-base:latest .