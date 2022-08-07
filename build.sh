#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

buildDate() {
    date +%Y.%m.%d.%H.%M
}

echo "I am checking for any image files."
result=$(docker images -q realmsg/nginx)

if [[ -n "$result" ]]; then
    echo "Existing images found."
    echo "" && echo "" && echo ""
    while true; do

        read -p "Do you want to proceed? (y/n) " nginx_yn

        case $nginx_yn in
        [yY])
            echo Ok, we will proceed to build the docker image.
            echo "Please enter your email address for the Automated Certificate Management Environment (ACME)."
            read ACMEMAIL
            ./cleanup.sh
            docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg $ACMEMAIL -t realmsg/nginx:$(buildDate) .
            docker push realmsg/nginx:$(buildDate)
            break
            ;;
        [nN])
            echo ""
            echo exiting...
            echo "" && echo "" && echo ""
            exit
            ;;
        *) echo Invalid Response ;;
        esac
    done
else
    echo "No existing image is found. Proceed to build."
    docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t realmsg/nginx:$(buildDate) .
    docker push realmsg/nginx:$(buildDate)
fi
