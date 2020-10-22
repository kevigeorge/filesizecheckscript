 #!/bin/bash

#########################################################################
#####Shell Script to check if latest created backup file size is ok######
#####if not call a php script ######
#########################################################################
#########################################################################

#Begin Function for checking filesize
checkfilesize(){
#getting the values of parameter
varfiledirectory=$1
varfileminsize=$2
#Directory where the phpsourcecode is kept for sending email
prog_path="/root/filesizecheckscript"

# Directory where the php is installed
prog_config="/usr/bin/php"
if [ -d "$varfiledirectory" ]; then
        #go to the particular directory
	cd  $varfiledirectory || exit
        #fetch the latest filename
	filename=$(ls -t | head -n1)
	fullfilepath=$varfiledirectory$varfilename
	filesize=$(stat -c%s "$fullfilepath")
	echo "Size of $fullfilepath = $filesize bytes.">> ${LOG_FILE}

	if [ "$filesize" -le "$varfileminsize" ]; then
		for i in "$prog_path"
		do
                #Section call php program
		"${prog_config}" "${i}"/phpscript.php $filename $filesize
                retphp_val=$?
                case $retphp_val in
		0) echo "Email sent for: $filename backup filesize is: $filesize">> ${LOG_FILE};;
		1) echo "Email failed for:  $filename backup filesize is: $filesize">> ${LOG_FILE};;
		esac  
		done
    		return 0
	else
    		return 1
	fi
else
   return 2
fi

}
#End of Function



#array of directories where latest backup is created, files can be added with corresponding file size
#backup file
arr_filebackup_dir[0]="/root/db-backup/data1_backup"
arr_filebackup_dir[1]="/root/db-backup/data2_backup"
arr_filebackup_dir[2]="/root/db-backup/data3_backup"

#file size is in MB
#corresponding backup file size to be compared.
#Asssuming backup file size will not become smaller
arr_fileback_size[0]="12000000"
arr_fileback_size[1]="12000000"
arr_fileback_size[2]="4000000"

#logfile in the current directory
LOG_FILE="`pwd`/checkfilesize.log"


for ((j=0;j<=2;j++)); 
do 
   checkfilesize  ${arr_filebackup_dir[$j]} ${arr_fileback_size[$j]}
   ret_val=$?
   case $ret_val in 
	0) echo "[${USER}][`date`] File size NOT OK">> ${LOG_FILE};;
	1) echo "[${USER}][`date`] File size OK">> ${LOG_FILE};;
	2) echo "[${USER}][`date`] ${arr_filebackup_dir[$j]} Backup Directory not Found">> ${LOG_FILE};;
   esac
done



