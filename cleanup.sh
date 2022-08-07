#! /bin/bash

clear

echo '
╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╭━━╮╱╱╱╱╭╮╱╱╭╮
┃╭━╮┃╱╱╱╱╱┃┃╱╱╱╭╮╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱┃╭╮┃╱╱╱╱┃┃╱╱┃┃
┃╰━╯┣━━┳━━┫┃╭╮╭┫┣━━╮╱┃┃┃┣━━┳━━┫┃╭┳━━┳━╮┃╰╯╰┳╮╭┳┫┃╭━╯┣━━┳━╮
┃╭╮╭┫┃━┫╭╮┃┃┃╰╯┣┫━━┫╱┃┃┃┃╭╮┃╭━┫╰╯┫┃━┫╭╯┃╭━╮┃┃┃┣┫┃┃╭╮┃┃━┫╭╯
┃┃┃╰┫┃━┫╭╮┃╰┫┃┃┃┣━━┃╭╯╰╯┃╰╯┃╰━┫╭╮┫┃━┫┃╱┃╰━╯┃╰╯┃┃╰┫╰╯┃┃━┫┃
╰╯╰━┻━━┻╯╰┻━┻┻┻╯╰━━╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╰━━━┻━━┻┻━┻━━┻━━┻╯'

result=$(which docker)
if [ -z $result ]; then

    echo '
    Error:
    Invalid docker command. Exiting. Thank You.'
    exit 1
else
    DOCKER=$result
fi

result=$(which awk)
if [ -z $result ]; then
    echo '
    Error:
    Invalid awk command. Exiting. Thank You.'
    exit 1
else
    AWK=$result
fi

result=$(which grep)
if [ -z $result ]; then
    echo '
    Error:
    Invalid grep command. Exiting. Thank You.'
    exit 1
else
    GREP=$result
fi

echo -e "\nStarting the Docker clean-up script, please wait.\n\n"
echo -e "\nI was checking for Docker images with empty tags.\n"
noneImages=$($DOCKER images | $GREP -w "<none>" | $AWK '{print $3}')
if [ "${noneImages}" != "" ]; then
    for nImages in ${noneImages}; do
        echo ${nImages}
        ${DOCKER} rmi -f ${nImages} >>cleanUpLog
        if [ $# -eq 0 ]; then
            echo -n "\nThe following images with ImageId: ${nImages} were deleted successfully.\n" >>/tmp/cleanUpLog
        else
            echo -n "\nError while deleting Docker images with ImageId: ${nImages}.\n" >>/tmp/cleanUpLog
        fi
    done
else
    echo "\nDocker images were found with empty tags but not deleted.\n"
fi
oldContainers=$($DOCKER ps -a | $GREP "Dead\|Exited" | $AWK '{print $1}')
if [ "$oldContainers" != "" ]; then
    echo ""
    for oContainers in $oldContainers; do
        echo $j
        $DOCKER rm ${oContainers} >>/tmp/cleanUpLog
        if [ $# -eq 0 ]; then
            echo -n "\nThe following images in ghost container with ContainerID: ${oContainers} was deleted successfully.\n" >>/tmp/cleanUpLog
        else
            echo -n "\nError while deleting Docker images in ghost container with ContainerID: ${oContainers}." >>/tmp/cleanUpLog
        fi

    done
else
    echo -e "\nThere are no Exited, or Dead containers found.\n" >>/tmp/cleanUpLog
fi
echo -e "Proceed to delete old images which are more than two months old."
oldImages=$($DOCKER images | $AWK '{print $3,$4,$5}' | $GREP '[9]\{1\}\ weeks\|years\|months' | $AWK '{print $1}')
#echo ${oldImages} >> cleanUpLog
if [ "$oldImages" != "" ]; then
    for i in ${oldImages}; do
        ${DOCKER} rmi -f ${i} >>/tmp/cleanUpLog
        if [ $# -eq 0 ]; then
            echo -n "\nDocker image with ImageId: ${i} were deleted successfully.\n" >>/tmp/cleanUpLog
        else
            echo -n "\nError while deleting Docker images with Docker image with ImageId: ${i}.\n" >>/tmp/cleanUpLog
        fi
    done
else
    echo -e "\nNo Docker images are to be deleted.\n"
fi

dangalingImages=$($DOCKER images -qf dangling=true)
if [ "$dangalingImages" != "" ]; then
    for dImages in ${dangalingImages}; do
        ${DOCKER} rmi -f ${dImages} >>/tmp/cleanUpLog
        if [ $# -eq 0 ]; then
            echo -n "\nDocker image with ImageId: ${dImages} were deleted successfully.\n" >>/tmp/cleanUpLog
        else
            echo -n "\nError while deleting Docker images with Docker image with ImageId: ${dImages}.\n" >>/tmp/cleanUpLog
        fi
    done
else
    echo -e "\nNo dangling Docker images are to be deleted.\n"
fi

echo -e "\nI am cleaning up unused Docker volumes.\n"
unUsedVolumes=$($DOCKER volume ls -qf dangling=true)
if [ "$unUsedVolumes" != "" ]; then
    for uVolumes in ${unUsedVolumes}; do
        ${DOCKER} volume rm -f ${uVolumes} >>/tmp/cleanUpLog
        if [ $# -eq 0 ]; then
            echo -n "\nDocker image with ImageId: ${uVolumes} were deleted successfully.\n" >>/tmp/cleanUpLog
        else
            echo -n "\nError while deleting Docker images with Docker image with ImageId: ${uVolumes}.\n" >>/tmp/cleanUpLog
        fi
    done
else
    echo -e "\nNo dangling Docker Volumes are to be deleted.\n"
fi

echo -n "\n\nCleaning Process Completed.\n\n"
clear
