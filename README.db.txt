
Getting the data into a format for 'R' script
*********************************************

Goto Alberta website for pdf data or search "alberta baby names":
	http://www.servicealberta.gov.ab.ca/Alberta_Top_Babies_Names.cfm


1. Download baby names pdf file for current year
   Place in babydb/alberta/intermediates/download.

   Note: 2001 Girls is saved as 2001_Girls_.


2. Open file with Adobe acrobat.
   Save in "Microsoft excel sheet" format in intermediates/excel.


3. Open this file with excel.  Check that frequency is in column A
   and name is column B. (eg, 2003 boys/girls was saved backwards).
   (eg, 2002 boys had extra columns). Don't assume the data is in the
   same format year after year :(

   Save in csv format in intermediates/csv.

4. Run csvfix script to remove unreadable ascii, standardize header and
   anything else that needs fixing (the script continues to grow).
   See the script csvfix.sh for details.

		> cd csvfix
		> test.run 

   Other Notes: 2003_boys - adobe acrobat fails to convert properly
   Capital I is changed into 1's and perhaps other errors i do not know.
