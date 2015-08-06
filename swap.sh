#!/usr/bin/env bash

WBI_VERSION='master'

# Official We Build India Automated Installation Script
# =============================================
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# First we check if the user is 'root' before allowing installation to commence
if [ $UID -ne 0 ]; then
    echo "Installed failed! To install you must be logged in as 'root', please try again"
  exit 1
fi

# Check If this is the first swap on server
free | grep Swap
echo "If This is first swap. swap in the above line should be 0 and should look like"&>/dev/tty
echo "Swap:            0          0          0"
while true; do
read -e -p "Is it first Swap on this server? " yn

    if [[ $yn = y ]] ; then
	  SWAP='new'
	  break;
	fi
	
	if [[ $yn = n ]] ; then
	  SWAP='old'
	  break;
	fi
	
done

# Check How Much Swap Size Needed.
echo "SWAP SIZE MINIMUM 256 MB AND MAXIMUM 12288 MB NOT $size MB"

while true; do
read -e -p "How Much Swap Size Needed? (in MB)" size

    if [ $size -ne 0 -o $size -eq 0 2>/dev/null ]
	then
		if [ $size -le 255 ] || [ $size -ge 12289 ]
		then
			echo "SWAP SIZE MINIMUM 256 MB AND MAXIMUM 12288 MB NOT $size MB"
		else
			SWAP_SIZE=$size
			SIZE_IN='k'
			break;
		fi
		
	else
		echo "Supplied Invalid Input '$size'"
	fi
	
done

echo "Creating Swap..!";
cd /var

	if [[ $SWAP == *"old"* ]]
	then
		while true; do
		read -e -p "Enter Name of new swap file: " filename
		EXTANSION='.img'
		[ -f /var/$filename$EXTANSION ] && echo "File $filename$EXTANSION already exist" || FILENAME=$filename$EXTANSION break;
		done
	else
	FILENAME='swap.img'
	fi
	
touch $FILENAME
chmod 600 $FILENAME

echo "Sizing to $SWAP_SIZE MB. could take several minutes...";
dd if=/dev/zero of=/var/$FILENAME bs=$SWAP_SIZE$SIZE_IN count=1000

echo "Preparing the Disk Image.."
mkswap /var/$FILENAME -f

echo "Starting Swap"
swapon /var/$FILENAME

echo "Enabling your Swap File During Boot"
echo "/var/$FILENAME    none    swap    sw    0    0" >> /etc/fstab

clear

echo -e "Swappiness tells the Linux kernel/VM handler how likely it should use VM."&>/dev/tty
echo -e "It is a percent value, between 0 & 100."&>/dev/tty
echo -e "If you set this value to 1, the VM handler will be least likely to use"&>/dev/tty
echo -e "any available swap space and should use all available system memory first."&>/dev/tty
echo -e "If you set it to 100, the VM handler will be most likely to use available "&>/dev/tty
echo -e "swap space and will try to leave a greater portion of system memory free for use."&>/dev/tty
echo -e "If you don't know,hit enter it will be set to 40% by default."&>/dev/tty
echo -e "If you set invalid value, It will automatically set value to 40%."&>/dev/tty
while true; do
read -e -p "Set Swappiness Percentage: " uswapy
	if [ $uswapy ]
	then
			if [ $uswapy -le 0 ] || [ $uswapy -ge 101 ]
			then
				echo "Swappiness Set to 40% by default as you entered invalid number"
				sysctl -w vm.swappiness=40
				break;
			else
				sysctl -w vm.swappiness=uswapy;
			break;
			fi
	else
	sysctl -w vm.swappiness=40
	break;
	fi
done


echo -e "##############################################################" &>/dev/tty
echo -e "# Congratulations WBI SWAP has now been installed on your    #" &>/dev/tty
echo -e "# server. Please review the log file left in /root/ for      #" &>/dev/tty
echo -e "# any errors encountered during installation.                #" &>/dev/tty
echo -e "# Thank you for using We Build India                         #" &>/dev/tty
echo -e "#                                                            #" &>/dev/tty
echo -e "#     Developed By                                           #" &>/dev/tty
echo -e "#         Gowthamraj Vungarala                               #" &>/dev/tty
echo -e "#          info@gowthamraj.in                                #" &>/dev/tty
echo -e "##############################################################" &>/dev/tty
echo -e "" &>/dev/tty