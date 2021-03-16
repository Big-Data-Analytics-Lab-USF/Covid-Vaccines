library("readr")
library("data.table")
library("dplyr")

#--------------- local machine --------------

# files <- list.files(path = "XXXXXX", pattern = "^2020-07", full.names=T)
# dat <- do.call(rbind, lapply(files, fread, integer64 = "character"))
#---------------------------------------------



#-------------- Cloud/Terminal --------------
args <- commandArgs(trailingOnly = FALSE)
fileNames_all <- args[6] # terminal args
fileLocation <- fileNames_all
dat <- fread(fileLocation, integer64 = "character") #read in csv file
#--------------------------------------------

#--------------- merge non-truncated text columns 
# Create df without truncated text
text <- data.frame(ifelse(test = is.na(dat$retweeted_status.extended_tweet.full_text),
               yes = ifelse(is.na(dat$extended_tweet.full_text),
                            yes = dat$text,
                            no = dat$extended_tweet.full_text),
               no = dat$retweeted_status.extended_tweet.full_text))
#--------------------------------------------



#--------------- Find keywords --------------
matched <- data.frame(dat[grep("vaccine|antivaxxers|antivaccine|coronavirusvaccine|vaccines|CoronavirusVaccine", 
                       text)])
#--------------------------------------------

write_excel_csv(matched, path ="XXXXXX/vaccine_related_keywords.csv", append = T, col_names = F)


#--------------- report output to terminal
ifelse(nrow(matched) > 1, 
       yes = print(paste0("Finished with: ", fileNames_all," ", Sys.time())),
       no = print(paste0("Did not matched or something failed at: ", fileNames_all, " ", Sys.time()))
)
#--------------------------------------------


remove(matched)
