-- This contains functionality which will be needed for the extractor

	--Add Column to Table AppData
	--SQL:
	ALTER TABLE "main"."AppData" ADD COLUMN "isLatestRepoPulled" BOOL DEFAULT 0


	# This will tell the date that the lastest repo pull was done 
	--Add Column to Table AppData
	--SQL:
	ALTER TABLE "main"."AppData" ADD COLUMN "repoPullDate" DATETIME
