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

echo "" && echo "" && echo ""
echo "I am checking for any existing docker image files."
result=$(docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx)

while true; do
    if [[ -n "$result" ]]; then
        echo "Existing images found."
        echo "" && echo "" && echo ""
        read -p "Do you want to proceed? (y/n) " build_yn
        case $build_yn in
        [yY])
            echo ""
            echo Ok, we will proceed to build the docker image.
            ./cleanup.sh
            ProceedBuildImage=true
            echo "Please enter your email address for the Automated Certificate Management Environment (ACME)."
            echo ""
            read ACMEMAIL
            docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg $ACMEMAIL -t realmsg/nginx:$(buildDate) .
            docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx >.repository
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
        echo "" && echo "" && echo ""
        echo "Please enter your email address for the Automated Certificate Management Environment (ACME)."
        echo ""
        read ACMEMAIL
        docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg $ACMEMAIL -t realmsg/nginx:$(buildDate) .
        docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx >.repository
        ProceedBuildImage=true
        echo "" && echo "" && echo ""
    fi
    if [[ "$ProceedBuildImage" == "true" ]]; then
        echo ""
        read -p "Do you want to push this build to Docker Hub? (y/n)" PushToDockerHub_yn
        echo "" && echo "" && echo ""
        case $PushToDockerHub_yn in
        [yY])
            echo "Pushing to DockerHub as $(sed '1q' .repository)" 
            docker push $(sed '1q' .repository)
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
