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
echo "I am scanning for the Docker Image."
result=$(docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx)

while true; do
    if [[ -n "$result" ]]; then
        echo "Docker Image Found."
        echo "$(docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference=realmsg/nginx)" >.repository
        cat .repository
        echo "" && echo "" && echo ""
        ImageFound=true
    else
        echo ""
        ImageFound=false
        echo "No Docker Image Found, Please Build First. Run ./build"
        echo "" && echo "" && echo ""
        exit
    fi
    if [[ "$ImageFound" == "true" ]]; then
        echo ""
        read -p "Do you want to proceed? (y/n) " push_yn

        case $push_yn in
        [yY])
            echo "Ok, proceeding to push the image."
            TagNPushLatest=true
            echo ""
            docker push $(sed '1q' .repository)
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
        echo ""
        echo "Is this consider the latest release?"
        read -p "Do you also want to push it as the latest to the Docker hub? (y/n)" PushAsLatest_yn
        echo "" && echo "" && echo ""
        case $PushAsLatest_yn in

        [yY])
            echo "Pushing to DockerHub as realmsg/nginx:latest"
            docker tag $(sed '1q' .repository) realmsg/nginx:latest
            docker push realmsg/nginx:latest
            TagNPushStable=true
            echo "" && echo "" && echo ""
            ;;
        [nN])
            TagNPushStable=true
            ;;
        *)
            echo ""
            echo Invalid Response
            echo "" && echo "" && echo ""
            ;;
        esac
    fi
    if [[ "$TagNPushStable" == "true" ]]; then
        echo ""
        echo "Is this consider the stable release?"
        read -p "Do you also want to push it as the stable to the Docker hub? (y/n)" PushAsStable_yn
        echo "" && echo "" && echo ""
        case $PushAsStable_yn in

        [yY])
            echo "Pushing to DockerHub as realmsg/nginx:stable"
            docker tag $(sed '1q' .repository) realmsg/nginx:stable
            docker push realmsg/nginx:stable
            echo "" && echo "" && echo ""
            break
            ;;
        [nN])
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
done
