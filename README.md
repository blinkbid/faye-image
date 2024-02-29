# faye-image
Docker image for faye

### Instructions for publishing the image
1. Go to your github Settings -> Developer Settings -> Personal access tokens (classic)
2. Select the following scopes: `write:packages` and `delete:packages`
3. Set the expected expiration date and generate the token, which will be used to login to docker ghcr.io.

4. Run on terminal
```
docker login --username <USERNAME> --password <TOKEN> ghcr.io
```

5. After a successful login, build the image to prepare it for publishing
```
docker build --tag ghcr.io/blinkbid/faye-image:latest
```

6. Publish the image
```
docker push ghcr.io/blinkbid/faye-image:latest
```
