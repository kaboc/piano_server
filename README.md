# gRPC server for [Remote Piano](https://github.com/kaboc/flutter_remote_piano)

## Usage

```dart
$ dart lib/server.dart -p {port number}
```

Port 50051 is used as the default if `-p` option is omitted.

## For grpc-web

The web version of Remote Piano uses `grpc-web` instead of `grpc-dart`.
grpc-web does not directly connect to a server but to a proxy before a server.

### How to set up a proxy

1. Copy `envoy.Dockerfile` and `envoy.yaml` in `proxy_example` to your preferred directory.
2. The value of `address` on the last line of envoy.yaml may need to be changed depending on your environment.
See the README of grpc-web's [helloworld](https://github.com/grpc/grpc-web/tree/master/net/grpc/gateway/examples/helloworld) example for more information.
3. Build a Docker image by running the following command in the same folder as envoy.Dockerfile.  
```
$ docker build -t piano/envoy -f ./envoy.Dockerfile .
```
4. Create a container and start it with the command below.
If necessary, change 50051 to another port you want the proxy to listen on. 
```
$ docker run -d -p 50051:8080 --name piano_server piano/envoy
```
5. Move back to this project's root folder and start a server with the `9090` port passed by the `-p` flag.
Change the number accordingly if you have specified a different one on the last line of your envoy.yaml.  
```
$ dart lib/server.dart -p 9090
```
