#!/usr/bin/env bash

WBI_VERSION='master'

SWAP_SIZE=512

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

# Check If this First Swap On Server
free -o
echo "If This is first swap. swap in the above line should be 0 and should look like"&>/dev/tty
echo "Swap:      		 0          0     	   0"
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

