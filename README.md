# gRPC server for [Remote Piano](https://github.com/kaboc/flutter_remote_piano)

## Usage

```
$ dart bin/server.dart -p {port number}
```

Port 50051 is used as the default if `-p` option is omitted.

## For gRPC-Web

The web version of Remote Piano uses `gRPC-Web` instead of `grpc-dart`.
gRPC-Web does not directly connect to a server but to a proxy before a server.

### How to set up a proxy ([Envoy](https://www.envoyproxy.io/))

The following settings set up a Docker container with a proxy in it that listens on the port 50051 of the host machine and proxies to the port 9090, which the server should listen on.

1. Copy `envoy.Dockerfile` and `envoy.yaml` in `proxy_example` to your preferred directory.
2. The value of `address` on the last line of envoy.yaml may need to be changed depending on your environment.
See the README of gRPC-Web's [helloworld](https://github.com/grpc/grpc-web/tree/master/net/grpc/gateway/examples/helloworld) for more information.
3. Build a Docker image by running the following command in the folder where envoy.Dockerfile is located.  
```
$ docker build -t piano/envoy -f ./envoy.Dockerfile .
```
4. Create a container and start it with the command below.
If necessary, change 50051 to another port you want the proxy to listen on.  
```
$ docker run -d -p 50051:8080 --name piano_proxy piano/envoy
```
5. Move back to the root folder of this example and start a server with the port number `9090` passed by the `-p` flag.
Change the number accordingly if you have specified a different one on the last line of your envoy.yaml.  
```
$ dart bin/server.dart -p 9090
```

### Other options for a proxy

You can use some other tools instead as shown in [README](https://www.envoyproxy.io/) of gRPC-Web:

* [NGINX](https://www.nginx.com/)
    * [Here](https://github.com/grpc/grpc-web/blob/master/net/grpc/gateway/examples/echo/nginx.conf) is a sample configuration.
    * See [this post](https://www.nginx.com/blog/nginx-1-13-10-grpc/) for more details.
* [gRPC Web Go Proxy](https://github.com/improbable-eng/grpc-web/tree/master/go/grpcwebproxy)

### Links

* [Remote Piano](https://github.com/kaboc/flutter_remote_piano)
* [Piano Server written in Go](https://github.com/kaboc/piano_server_go)
