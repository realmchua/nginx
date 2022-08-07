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

echo "I am checking for any existing docker image files."
result=$(cat .build)

while true; do
    if [[ -n "$result" ]]; then

        echo "Existing images found."
        echo "" && echo "" && echo ""
        read -p "Do you want to proceed? (y/n) " nginx_yn
        case $nginx_yn in
        [yY])
            echo ""
            echo Ok, we will proceed to build the docker image.
            ./cleanup.sh
            ProceedBuildImage=true
            echo ""
            echo "Please enter your email address for the Automated Certificate Management Environment (ACME)."
            echo ""
            read ACMEMAIL
            docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg $ACMEMAIL -t realmsg/nginx:$(buildDate) .
            echo realmsg/nginx:$(buildDate) >.build
            echo "" && echo "" && echo ""
            ;;
        [nN])
            ProceedBuildImage=false
            echo ""
            echo exiting...
            echo "" && echo "" && echo ""
            exit
            ;;
        *) echo Invalid Response ;;
        esac
    else
        echo ""
        echo "No existing docker image is found. Proceed to build."
        echo ""
        echo "Please enter your email address for the Automated Certificate Management Environment (ACME)."
        echo ""
        read ACMEMAIL
        docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg $ACMEMAIL -t realmsg/nginx:$(buildDate) .
        echo realmsg/nginx:$(buildDate) >.build
        ProceedBuildImage=true
        echo "" && echo "" && echo ""
    fi
    if [[ "$ProceedBuildImage" == "true" ]]; then
        read -p "Do you want to push this build to Docker Hub? (y/n)" PushToDockerHub_yn

        case $PushToDockerHub_yn in

        [yY])
            echo "Pushing to DockerHub as $(cat .build)"
            docker push $(cat .build)
            echo "" && echo "" && echo ""
            break
            ;;
        [nN])
            echo "This image will not be push to the DockerHub, to push run the ./push command later on"
            echo "" && echo "" && echo ""
            break
            ;;
        *)
            echo ""
            echo Invalid Response
            echo "" && echo "" && echo ""
            ;;
        esac
    fi
done
