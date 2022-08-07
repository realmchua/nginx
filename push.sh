#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

echo "I am scanning for the Docker Image."
result=$(cat .build)

while true; do
    if [[ -n "$result" ]]; then
        echo "Docker Image Found."
        echo "$(cat .build)"
        echo "" && echo "" && echo ""
        read -p "Do you want to proceed? (y/n) " nginx_yn

        case $nginx_yn in
        [yY])
            echo "Ok, proceeding to push the image."
            TagNPushLatest=true
            echo "" && echo "" && echo ""
            ;;
        [nN])
            echo ""
            TagNPushLatest=false
            echo exiting...
            echo "" && echo "" && echo ""
            exit
            ;;
        *) echo Invalid Response ;;
        esac
    fi
    if [[ "$TagNPushLatest" == "true" ]]; then
        read -p "Do you also want to push a copy as latest? (y/n)" PushAsLatest_yn

        case $PushAsLatest_yn in

        [yY])
            echo "Pushing to DockerHub as $(cat .build) and realmsg/nginx:latest"
            docker push $(cat .build)
            docker tag $(cat .build) realmsg/nginx:latest
            docker push realmsg/nginx:latest
            echo "" && echo "" && echo ""
            break
            ;;
        [nN])
            echo "Ok, we will only push a copy of the image as $(cat .build)"
            docker push $(cat .build)
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
