## script to just run through all the email files.
## BEFORE you can import you may want to delete existing files:
## ./biostar.sh delete
## and if you did that, then you MUST init the DB
## ./biostar.sh init

## work from here:
## cd /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/

## Next I need to sort by DATE
## This won't work since it assumes that the date the file arrived at
## my FS is the right one :P
## details = file.info(list.files(pattern="*.txt"))
## gives nice data.frame (which can be sorted)

baseDir <- '/mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/'
files <-  dir(baseDir)

.getDateObj <- function(str){
    shrtStr <- sub(".txt","",str)
    dateInfo <- unlist(strsplit(shrtStr, split="-"))
    year <- dateInfo[1]
    month <- dateInfo[2]
    ## convert month name to number
    months <- 1:12
    names(months) <- month.name
    monthNum <- months[names(months) %in% month]
    ## make a date String
    dateStr <- paste0(year,"-",monthNum,"-01") ## day doesn't matter here
    ## then use like:
    as.POSIXct(dateStr, "America/Seattle")
}

## extract the dates from our strings
lst <- lapply(files, .getDateObj)
names(lst) <- files
res <- unlist(lst)
## Then finally we can sort them...
res <- sort(res)
## and now the names will be in the right order
sortedFiles <- names(res)

## ## then we want to make a huge cat (IN ORDER)
## ## EG:  cat january.txt february.txt march.txt > all.txt
## cmd <- paste0('cat ', paste0(sortedFiles, collapse=" "), ' > all.txt')
## system(cmd)



###################################################################
## The following code is just if we want to iterate and load each one
## in turn from R (turns out we probably don't)???  - Right now this is the only thing that works...

## base dir
## baseDir <- '/mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/'

## I want to do this over and over...
## python manage.py import_mbox -f 2014-January.txt

## files <- dir(baseDir)

## just 2013
filePaths <- paste0(baseDir, sortedFiles[133:144])

## all the stuff
filePaths <- paste0(baseDir, sortedFiles)



commands <- paste0('python manage.py import_mbox -f ', filePaths)

## Shave off that 'all.txt' command
## commands <- commands[1:(length(commands)-1)]

length(commands)

.system <- function(command){
    message(command)
    system(command)
}


## lapply(commands[1:10], .system)



lapply(commands, .system)




## I think the problem with the 'big cat' is that I basically lose
## everything after the 1st non-working month.  So I have to work out
## why some months don't import...


## then just run em all..
## lapply(commands[1:50], .system)

## lapply(commands[51:100], .system)

## IN this set I had TROUBLE with these files:
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2007-October.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2008-May.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2010-February.txt


## lapply(commands[101:146], .system)
## IN this set I had TROUBLE with these files:
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2010-March.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2010-November.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2011-April.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2011-August.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2011-March.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2012-August.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2012-June.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2012-March.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2013-January.txt
## /mnt/cpb_anno/mcarlson/BioconductorEmailRepos/unpacked/2013-October.txt
## 