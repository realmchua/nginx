#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

echo "I am checking for any existing docker image files."
result=$(cat .build)
echo "" && echo "" && echo ""

while true; do
    if [[ -n "$result" ]]; then
        echo "Image found."
        read -p "Do you want to proceed to deploy? (y/n)" deploy_yn

        case $deploy_yn in

        [yY])
            echo ""
            echo "Ok, we will proceed to deploy the docker image."
            echo "What shall we name the container?"
            read containerName
            ContinueDeploy=true
            echo "" && echo "" && echo ""
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
            echo ""
            echo "Please enter your persistent storage path in host/path:container/path e.g. (/home/docker/www:/www)."
            read persistentStoragePath
            PersistentStorage=true
            echo "" && echo "" && echo ""
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
            echo ""
            echo "Please key the new port numbers, e.g. (-p 80:8080 -p 443:9443) - This binds to port 8080 of the container port 80."
            read NewContainerPort
            docker run -itd --name $containerName $NewContainerPort -v $persistentStoragePath $(cat .build)
            echo "" && echo "" && echo ""
            break
            ;;
        [nN])
            echo ""
            echo "I am using the default port."
            docker run -itd --name $containerName -v $persistentStoragePath $(cat .build)
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
            echo ""
            echo "Please key the new port numbers, e.g. (-p 80:8080 -p 443:9443) - This binds to port 8080 of the container port 80."
            read NewContainerPort
            docker run -itd --name $containerName $NewContainerPort $(cat .build)
            echo "" && echo "" && echo ""
            break
            ;;
        [nN])
            echo ""
            echo "I am using the default port."
            docker run -itd --name $containerName $(cat .build)
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
