An NGIÍ¥NXÍ¯ web server builds on ððµð¹ð²ð·ð® ðð²ð·ð¾ð with PHP8.1, FastCGI, Bash and OpenRC init-service.

Build and maintained by: Realm Chua < realm at mylinuxbox dot cloud>

https://github.com/realmchua/

https://hub.docker.com/repository/docker/realmsg/

https://mylinuxbox.cloud

ðªðµð®ð ð¶ð ð¡ððð¡ð«â

NGINX (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage.

ðð¼ð ðð¼ ð¯ðð¶ð¹ð± ð³ð¿ð¼ðº ððµð² ðð¼ð°ð¸ð²ð¿ð³ð¶ð¹ð²â

wget https://github.com/realmchua/nginx.git

cd nginx

./build.sh (To build the image from the Dockerfile)

ðð¼ð ðð¼ ððð² ðºð ð¶ðºð®ð´ð²â

./deploy (To deploy the image file) or

docker -itd -p 80:80 -p 443:443 -v /home/docker/www:/www --name mywebserver realmsg/nginx:stable

./push (To push the image to Docker Hub's Repository)
  
DÌ³iÌ³sÌ³cÌ³lÌ³aÌ³iÌ³mÌ³eÌ³rÌ³: 

Please visit https://pkgs.alpinelinux.org/ to view the license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under additional licenses (such as bash, etc., from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
