# Gatling Enterprise Api

## Test locally openapi

On project root directory:

```shell
docker run -p 9090:8080 -e SWAGGER_JSON=/tmp/openapi.yaml -v "$(pwd)/openapi/src/main/openapi":/tmp swaggerapi/swagger-ui
```
You can access to your local swagger ui at [http://localhost:9090](http://localhost:9090)
