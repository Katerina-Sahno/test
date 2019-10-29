#!/bin/bash

dir=/root/backup/
namefile=*.gz

countline=$(find $dir -type f -name $namefile -mtime +$1 | wc -l)
if (($countline>=$2));then
        deleteFile=$(find $dir -type f -name $namefile -mtime +$1 -exec stat -c "%y %n" {} \; | sort -n | head -1 | cut -d' ' -f4)
        echo "rm $deleteFile"
        rm $deleteFile
fi

exit 0
