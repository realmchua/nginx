An NGIͥNXͯ web server builds on 𝓐𝓵𝓹𝓲𝓷𝓮 𝓛𝓲𝓷𝓾𝔁 with PHP8.1, FastCGI, Bash and OpenRC init-service.

Build and maintained by: Realm Chua < realm at mylinuxbox dot cloud>

https://github.com/realmchua/

https://hub.docker.com/repository/docker/realmsg/

https://mylinuxbox.cloud

𝗪𝗵𝗮𝘁 𝗶𝘀 𝗡𝗚𝗜𝗡𝗫❓

NGINX (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage.

𝗛𝗼𝘄 𝘁𝗼 𝗯𝘂𝗶𝗹𝗱 𝗳𝗿𝗼𝗺 𝘁𝗵𝗲 𝗗𝗼𝗰𝗸𝗲𝗿𝗳𝗶𝗹𝗲❓

wget https://github.com/realmchua/nginx.git

cd nginx

./build.sh (To build the image from the Dockerfile)

𝗛𝗼𝘄 𝘁𝗼 𝘂𝘀𝗲 𝗺𝘆 𝗶𝗺𝗮𝗴𝗲❓

./deploy (To deploy the image file) or

docker -itd -p 80:80 -p 443:443 -v /home/docker/www:/www --name mywebserver realmsg/nginx:stable

./push (To push the image to Docker Hub's Repository)
  
D̳i̳s̳c̳l̳a̳i̳m̳e̳r̳: 

Please visit https://pkgs.alpinelinux.org/ to view the license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under additional licenses (such as bash, etc., from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
