# This script will analyze Gender biases in a person's choice to take COVID19 
# vaccine. The dataset was merged with data collected from Twitter, 
# Gender Detection Algo, and annotated Covid vaccine tweets. 
# 
# More specifically, this script will generate 3 barchart creatives that 
# compare gender to annotation. This script will also create a pivot table 
# on the Gender variable. 
#
# Dre Dyson

library("ggplot2")
library("data.table")
library("dplyr")
options(scipen = 999999)


df <- data.table::fread("data/C19_Vax_Tweets_coding_withGender.csv", integer64 = "character") # Not provided in this github due to Twitter's terms and conditions
df <- df %>% mutate_all(na_if,"") # replace blank cells with NAs
df <- df %>% mutate_each(funs(tolower)) # columns of char type has both lower and uppercase in factors
df <- df %>% mutate(modularity_class = as.factor(modularity_class), # convert df columsn to factors
                    main_topic = as.factor(main_topic),
                    vax_benefits = as.factor(vax_benefits),
                    vax_risks = as.factor(vax_risks),
                    why_or_who_benefits_or_who_acting = as.factor(why_or_who_benefits_or_who_acting),
                    top_multi_list_top_c_if_multiple_present = as.factor(top_multi_list_top_c_if_multiple_present),
                    top_multi_list_top_c_if_multiple_present_2 = as.factor(top_multi_list_top_c_if_multiple_present_2),
                    gender = as.factor(gender),
                    other_freecode = as.factor(other_freecode),
                    notes_2 = as.factor(notes_2),
                    notes_3 = as.factor(notes_3),
                    other_freecode_2 = as.factor(other_freecode_2),
                    user_screen_name = as.factor(user_screen_name),
                    confidence_in_safety_efficacy_systems_2 = as.factor(confidence_in_safety_efficacy_systems_2),
                    why_or_who_benefits_or_who_acting = as.factor(why_or_who_benefits_or_who_acting),
                    no_hesitancy = as.factor(no_hesitancy))

df.clean <- df 
df.clean <- df.clean %>% filter(!is.na(gender))
df.clean[,14:20] <- data.frame(lapply(df.clean[,14:20], as.numeric))
df.clean$c_type <- as.factor(colnames(df.clean)[14:20][max.col(!is.na(df.clean[,14:20]))])

df.clean$c_type <- gsub("calculation_enough_information_to_act_immediately", "calculation", df.clean$c_type)
df.clean$c_type <- gsub("collective_civic_moral_duty_to_protect_others", "collective", df.clean$c_type)
df.clean$c_type <- gsub("complacency_disease_risk_vaccine_necessary_good_health_challenged", "complacency", df.clean$c_type)
df.clean$c_type <- gsub("confidence_in_safety_efficacy_systems", "confidence", df.clean$c_type)
df.clean$c_type <- gsub("constraints_structural_barriers_phychological_barriers_e_g_want", "constraints", df.clean$c_type)


df.clean <- df.clean %>% mutate(c_type = ifelse( test = is.na(match(df.clean$c_type, df.clean$top_multi_list_top_c_if_multiple_present)),
                                                 yes = c_type,
                                                 no = top_multi_list_top_c_if_multiple_present))


ggplot(df.clean, aes(x= c_type,  group=gender)) + 
  geom_bar(aes(y = ..prop.., fill = factor(gender)), stat="count") +
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  theme_classic(
    #base_size = 11,
    base_family = "",
    base_line_size = 11/22,
    base_rect_size = 11/22 ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(y = "Percent", fill="Gender", x = "Type C's")



gender_coded <- df.clean %>% select(no_hesitancy,
                                    confidence_in_safety_efficacy_systems,
                                    complacency_disease_risk_vaccine_necessary_good_health_challenged,
                                    constraints_structural_barriers_phychological_barriers_e_g_want,
                                    convenience,
                                    calculation_enough_information_to_act_immediately,
                                    collective_civic_moral_duty_to_protect_others,
                                    gender)

gender_coded$annonated <- as.factor(colnames(gender_coded)[1:7][max.col(!is.na(gender_coded[,1:7]))])
gender_coded$annonated <- gsub("calculation_enough_information_to_act_immediately", "calculation", gender_coded$annonated)
gender_coded$annonated <- gsub("collective_civic_moral_duty_to_protect_others", "collective", gender_coded$annonated)
gender_coded$annonated <- gsub("complacency_disease_risk_vaccine_necessary_good_health_challenged", "complacency", gender_coded$annonated)
gender_coded$annonated <- gsub("confidence_in_safety_efficacy_systems", "confidence", gender_coded$annonated)
gender_coded$annonated <- gsub("constraints_structural_barriers_phychological_barriers_e_g_want", "constraints", gender_coded$annonated)

ggplot(gender_coded, aes(gender, group = annonated, fill = gender)) + 
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat="count") + 
  scale_y_continuous(labels=scales::percent) +
  labs(y = "Relative Frequencies", x = "Gender") +
  scale_fill_discrete(name = "Gender", labels = c("female", "male")) +
  facet_wrap(~annonated) +
  ggtitle("Type-C Percentages by Gender")
  
  
 ggplot(gender_coded, aes(gender)) + 
  geom_bar(aes(y = (..count..)/sum(..count..),fill = gender)) + 
  scale_y_continuous(labels=scales::percent) +
  ylab("relative frequencies") +
  labs(y = "Percentage across dataset", x = "Gender") +
  ggtitle("Gender Breakdown")
  
gender_coded_pivot <- gender_coded %>% group_by(gender) %>% tally()
gender_coded_pivot <- gender_coded_pivot %>% dplyr::rename(freq = "n")
gender_coded_pivot <- gender_coded_pivot %>% mutate(percentage = freq/sum(freq)*100)
gender_coded_pivot

