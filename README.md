# Covid19 Vaccine Study

We utilized Twitter's Stream API function to collect our dataset. First, we collected Covid19 related Twitter data using https://github.com/computermacgyver/twitter-python Github repo. The keywords we used to feed Twitter's Stream API can be found here: `covid19_keywords.txt`. Next, we performed a GREP function on tweets filtered this dataset using `vaccine_keywords.txt` as keywords. Then we used this filtered dataset to perform our analysis.

For reproducibility, we suggest using Hydator found here: https://github.com/DocNow/hydrator. We provided the Twitter Tweet Ids from our filter data to feed into Hydrator here: `/data/twitter_id_str.txt`. **Note** Twitter actively removes and/or suspends users/tweets from its platform, and this may cause omissions from your dataset.



# Structure of this Repo

This repo contains four subfolders:
- `Data`
- `Scripts`
- `Analysis`
- `Results`

**Data**

The `Data` folder contains a list of Twitter User IDs and Twitter ID strings.

**Scripts**

The `Scripts` folder only contains analysis scripts. These scripts require the data to be in a specific format, which is not provided in the `Data` folder. The `Scripts` folder does not contains the necessary collection and processing scripts that enable the analysis scripts. In order to replicate findings, please navigate outside of this repo and move into the Covid repo, which will provide the collection and processing steps.

**Analysis**

The `Analysis` folder contains the scripts we used to create our analysis.


**Results**

The `Results` folder contains our findings in this study.
