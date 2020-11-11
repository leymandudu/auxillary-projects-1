#/bin/bash
#Am I the root user?
if [ $(id -u) -eq 0 ]; then
#read csv file
    for i in $(cat ${1}); do
	echo $i
        if id "$i" &>/dev/null
        then 
            echo "user exists"
        else
#create user accounts
        useradd -m -d /home/$i -s /bin/bash -g developers $i
        echo "creating user account"
	echo "                     "
#create a ssh folder in users home folders
        su - -c "mkdir ~/.ssh" $i 
	echo "creating .ssh directory"
	echo "                     "
#set permissions
        su - -c "chmod 700 ~/.ssh" $i 
	echo "setting permissions for .ssh directory"      
	echo "                     "
#create the authorized_keys file:
        su - -c "touch ~/.ssh/authorized_keys" $i
#set the right permissions
        su - -c "chmod 600 ~/.ssh/authorized_keys" $i 
#public key for users
#copy public key file from chauntel
	cp -R "/home/chauntel/.ssh/id_rsa.pub" "/home/$i/.ssh/authorized_keys"
	echo "copying public key to user account"
	echo "                                  "
#chown user to authorized key file
         sudo chown $i /home/$i/.ssh/authorized_keys
	 echo " Complete!"
        fi 
    done
else
    echo 'Only root may add a user to the system' 
fi
