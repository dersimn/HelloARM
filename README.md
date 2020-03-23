    docker buildx create --name mybuilder2 --use
    docker buildx inspect --bootstrap
    
    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 -t dersimn/helloarm:native --push .