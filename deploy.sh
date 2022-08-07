#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

echo "" && echo "" && echo ""
echo "I am checking for any existing docker image files."
result=$(docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx)

if [[ -n "$result" ]]; then

    echo "Docker Image found."
    echo ""
    docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx >.repository
    cat .repository
    echo "" && echo "" && echo ""
    while true; do

        read -p "Do you want to proceed to deploy? (y/n) " deploy_yn

        case $deploy_yn in
        [yY])
            echo Ok, we will proceed to deploy the docker image.
            echo ""
            echo "Deploying $(sed '1q' .repository)"
            echo ""
            echo "What shall we name the container?"
            echo ""
            read containerName
            docker run -itd --name $containerName $(sed '1q' .repository)
            echo "" && echo "" && echo ""
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
fi
