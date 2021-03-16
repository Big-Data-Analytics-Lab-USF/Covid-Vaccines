library("data.table")
library("dplyr")
options(scipen = 999999)



data <- fread("/Users/dre/Downloads/vaccine_related_networkAnalysis/data/vaccine_related_tweets.csv")#, 
              #select = c("user.screen_name", "text", "retweeted_status.created_at"))



text <- data.frame(ifelse(test = is.na(data$retweeted_status.extended_tweet.full_text),
                          yes = ifelse(is.na(data$extended_tweet.full_text),
                                       yes = data$text,
                                       no = data$extended_tweet.full_text),
                          no = data$retweeted_status.extended_tweet.full_text))

data$complete_text <- text

data <- data %>% select("user.screen_name", "complete_text", "retweeted_status.created_at")
data <- data %>% dplyr::rename(text = complete_text)

data <- data[which(is.na(data$retweeted_status.created_at) == TRUE)]
data <- data %>% select(user.screen_name, text)

userClass <- fread("/Users/dre/Downloads/vaccine_related_networkAnalysis/data/Vaccine.july.network.queries (1).csv", 
                   select = c("pageranks", "Id", "modularity_class"))
userClass <- userClass %>% rename("user.screen_name" = "Id") 



mergedData <- inner_join(data, userClass, by = "user.screen_name", copy = FALSE)
mergedData <- mergedData[which(is.na(mergedData$pageranks) == FALSE)]


mergedData$modularity_class <- as.factor(mergedData$modularity_class)


modularity_class <- split(mergedData, mergedData$modularity_class)


arrange_by_rank <- function(x){
  x[with(x, order(-pageranks))]
}

by_class <- lapply(modularity_class, arrange_by_rank)




group_class <- function(x){
  dat <- x %>% group_by(pageranks, user.screen_name) %>% count(pageranks) %>% arrange(-pageranks)
  return(dat)
}



sort_pagerank <- lapply(by_class, group_class)



get_top_ranks <- function(x){
  head(unique(x$user.screen_name), 10)
}

top_page_ranks <- lapply(sort_pagerank, get_top_ranks)
userAccounts <- unlist(top_page_ranks)





tweets <-  mergedData[match(userAccounts,  mergedData$user.screen_name)]
set.seed(100)
sample_tweets <- tweets[sample(nrow(tweets), 200)]




#### New request for modularity class 1316


class1316 <- userClass[which(userClass$modularity_class == 1316)]

mergedData_new <- inner_join(data, class1316, by = "user.screen_name", copy = FALSE)
mergedData_new <- mergedData_new[which(is.na(mergedData_new$pageranks) == FALSE)]
mergedData_new$modularity_class <- as.factor(mergedData_new$modularity_class)
modularity_class_new <- split(mergedData_new, mergedData_new$modularity_class)
by_class_new <- lapply(modularity_class_new, arrange_by_rank)
sort_pagerank_new <- lapply(by_class_new, group_class)

get_top_ranks2 <- function(x){
  head(unique(x$user.screen_name), 200)
}
top_page_ranks_new <- lapply(sort_pagerank_new, get_top_ranks2)
userAccounts_new <- unlist(top_page_ranks_new)
tweets_new <-  mergedData_new[match(userAccounts_new,  mergedData_new$user.screen_name)]
write_excel_csv(tweets_new, "data/mod_class_1316_top200_tweets.csv")

