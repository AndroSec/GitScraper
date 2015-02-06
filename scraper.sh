#!/bin/bash          

	# Author: Daniel E. Krutz
	# Description: Scrape newest repos from existing GIT Reop


	# Script location. Must be placed near top of script
	MainScriptLoc=`pwd`

	# Location of directory to output repo files to
	projectFiles=repos

	### Database Location	
	db=$MainScriptLoc/db/AndrosecDatabase.sqlite

	echo "Removing existing output files"
	rm -rf $projectFiles
	mkdir -p $projectFiles

	### Logging
	mkdir -p logs/
	date1=$(date +"%s") ## Start date of the script
	logLocation=logs/scraper.log
	rm -f $logLocation ## Clear the log file if it exists
	touch $logLocation
	echo "Start Scraper: " `date` >> $logLocation
	
	### Since this will attempt to download the newest versions of all repos, all should be initially set to be 0
	echo "Set isRepoPulled = 0"
	sqlite3 $db  "update appdata set isRepoPulled = 0;"

	OutputList=`sqlite3 $db "select appID, name, source_code from appData where source_code like '%.git'"`;
	for ROW in $OutputList; do
 
	    appID=`echo $ROW | awk '{split($0,a,"|"); print a[1]}'`
	    appname=`echo $ROW | awk '{split($0,a,"|"); print a[2]}'`
	    source_code=`echo $ROW | awk '{split($0,a,"|"); print a[3]}'`

		echo "***Clone Repo $appID $appname : " `date` >> $logLocation

		if [ -n "$appname" ]; then
	
			cd $projectFiles
			echo "******Starting Clone $appID $appname : " `date` >> ../$logLocation
			git clone $source_code $appname ## Clone into a folder named the same as the appName

			echo "******Clone Complete $appID $appname : " `date` >> ../$logLocation
			cd $MainScriptLoc

			# update the DB with the pull information
			### Set that it was updated
			sqlite3 $db  "update appdata set isRepoPulled = 1 where appID = $appID;"

			## Update the date field
			sqlite3 $db  "update appdata set repopulldate = '`date`' where appID = $appID;"

		else
			echo $appID " " $appname
			echo "******$appID $appname Not Found: " `date` >> $logLocation
		fi

	done

	diff=$(($date2-$date1))
	echo "Total Running Time $(($diff / 60)) minutes and $(($diff % 60)) seconds."  >> $logLocation
	echo "End:" `date` >> $logLocation


#### Todo
# Logging
#	Fix running time
# Find other applications from the F-Droid repo

