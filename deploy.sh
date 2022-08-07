#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

echo "I am checking for the image file."
result=$(docker images -q realmsg/nginx)
echo "" && echo "" && echo ""

while true; do
    if [[ -n "$result" ]]; then
        echo "Image found."
        read -p "Do you want to proceed to deploy? (y/n)" deploy_yn

        case $deploy_yn in

        [yY])
            echo "Ok, we will proceed to deploy the docker image."
            echo "What shall we name the container?"
            read containerName
            ContinueDeploy=true
            ;;
        [nN])
            echo ""
            echo exiting...
            echo "" && echo "" && echo ""
            exit
            ;;
        *)
            echo ""
            echo Invalid Response
            echo "" && echo "" && echo ""
            ;;
        esac
    fi
    if [[ "$ContinueDeploy" == "true" ]]; then
        read -p "Do you want to start with Persistent storage? (y/n)" persistentStorage_yn

        case $persistentStorage_yn in

        [yY])
            echo "Please enter your persistent storage path in host/path:container/path e.g. (/home/docker/www:/www)."
            read persistentStoragePath
            PersistentStorage=true
            ;;
        [nN])
            echo ""
            echo "I am using the default setting (html location: /www). Data will be lost when the container is stopped."
            PersistentStorage=false
            echo "" && echo "" && echo ""
            ;;
        *)
            echo ""
            echo Invalid Response
            echo "" && echo "" && echo ""
            ;;
        esac
    fi
    if [[ "$PersistentStorage" == "true" ]]; then
        echo "The default container only allows ports 80 & 443 to be accessed externally."
        read -p "Do you want to customise the port? (y/n)" changeport_yn

        case $changeport_yn in

        [yY])
            echo "Please key the new port numbers, e.g. (-p 80:8080 -p 443:9443) - This binds to port 8080 of the container port 80."
            read NewContainerPort
            docker run -itd --name $containerName $NewContainerPort -v $persistentStoragePath realmsg/nginx:latest
            break
            ;;
        [nN])
            echo ""
            echo "I am using the default port."
            docker run -itd --name $containerName -v $persistentStoragePath realmsg/nginx:latest
            echo "" && echo "" && echo ""
            break
            ;;
        *)
            echo ""
            echo Invalid Response
            echo "" && echo "" && echo ""
            ;;
        esac
    else
        echo "The default container only allows ports 80 & 443 to be accessed externally."
        read -p "Do you want to customise the port? (y/n)" changeport_yn

        case $changeport_yn in

        [yY])
            echo "Please key the new port numbers, e.g. (-p 80:8080 -p 443:9443) - This binds to port 8080 of the container port 80."
            read NewContainerPort
            docker run -itd --name $containerName $NewContainerPort realmsg/nginx:latest
            break
            ;;
        [nN])
            echo ""
            echo "I am using the default port."
            docker run -itd --name $containerName realmsg/nginx:latest
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
