#!/bin/bash

function sync {

find "$1/" -printf "%h\n" |sort -u| while read i;
do
 for Syncfile in `ls $i`
  do
#файлы рабочей директории с добавление пути до Backup директории
     backupfile="$2$(echo "$i" | awk -F "$1" '{print $2}')"
#существует такой путь
     check_backup=$([ -e "$backupfile/$Syncfile" ]; echo $?)
     check_work_dir=$([ -d "$i/$Syncfile" ]; echo $? )
  
    if [ $check_backup -ne 0 ]
    then
     if [ $check_work_dir -eq 0 ]
     then 
#Create new dir
       echo `date --rfc-3339=sec |awk -F "+" '{print $1}'`" : Create dir in  $backupfile/$Syncfile" >>/root/sync.log
       mkdir $backupfile/$Syncfile
     else
#Copy new file
        echo `date --rfc-3339=sec |awk -F "+" '{print $1}'`" : Copy new file from  "$i/$Syncfile" to "$backupfile/$Syncfile"" >>/root/sync.log
        cp "$i/$Syncfile" "$backupfile/$Syncfile"
     fi
    else
    if [ $check_work_dir -ne 0 ]
     then
#Update files  
     cp "$i/$Syncfile" "$backupfile/$Syncfile"
    fi
   fi
  done
done


find "$2/" -printf "%h\n" |sort -ur| while read i;
do
 for Syncfile in `ls $i | grep -v /`
  do
#файлы Backup директории с добавление пути до Backup рабочей директории
     workfile="$1$(echo "$i" | awk -F "$2" '{print $2}')"
#существует такой путь
     check_work=$([ -e "$workfile/$Syncfile" ]; echo $?)
     check_backup_dir=$([ -d "$i/$Syncfile" ]; echo $? )
   if [ $check_work -ne 0 ]
    then
       if [ $check_backup_dir -eq 0 ]
     then
#remove old dir
      echo `date --rfc-3339=sec |awk -F "+" '{print $1}'`" : Delete dir $i/$Syncfile" >>/root/sync.log
      rm -frd $i/$Syncfile
     else
#remove old file
        echo `date --rfc-3339=sec |awk -F "+" '{print $1}'`" : Delete file $i/$Syncfile" >> /root/sync.log
        rm -rdf $i/$Syncfile  
     fi
   fi  
  done
done
}

path1=`echo $1 | awk '{path=match($0, /\/$/)} {if($path~"/") print substr($0, 1, length($0)); else {print  substr($0, 1, length($0)-1)}}'`
path2=`echo $2 | awk '{path=match($0, /\/$/)} {if($path~"/") print substr($0, 1, length($0)); else {print  substr($0, 1, length($0)-1)}}'`
sync $path1 $path2

