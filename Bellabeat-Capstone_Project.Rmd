---
title: "Google Data Analytics Capstone Project"
author: "Gigio Gomes"
date: "2022-08-13"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Case Study 2 - How can a wellness technology company play it smart?

```{r echo=FALSE}
knitr::include_graphics("bellabeat-logo.jpg")
```

### Introduction and background

#### Scenario

Bellabeat is a high-tech manufacturer of health-focused products for women. This is a successful small company, but they have the potential to become a larger player in the global smart device market.

As a data analyst working on the marketing analyst team, I have been asked to focus on one of Bellabeat's products and analyze smart device data to gain insight into how consumers are using their smart devices. The insights I discover will help guide marketing strategy for the company. I will present my analysis to the Bellabeat executive team along with recommendations for Bellabeat’s marketing strategy.

The questions that will guide the analysis are:

1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

In order to answer the key business questions, it will be followed the steps of the data analysis process: **ask**, **prepare**, **process**, **analyze**, **share** and **act**. And a report with the following deliverable will be produced:

1. A clear summary of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. Supporting visualizations and key findings
5. The top high-level content recommendations based on the analysis


#### About the company

Urška Sršen and Sando Mur founded Bellabeat, a high-tech company that manufactures health-focused smart products. Sršen used her background as an artist to develop beautifully designed technology that informs and inspires women around the world. Collecting data on activity, sleep, stress, and reproductive health has allowed Bellabeat to empower women with knowledge about their own health and habits. Since it was founded in 2013, Bellabeat has grown rapidly and quickly positioned itself as a tech-driven wellness company for women.

By 2016, Bellabeat had opened offices around the world and launched multiple products. Bellabeat products became available through a growing number of online retailers in addition to their own e-commerce channel on [their website](https://bellabeat.com/). The company has invested in traditional advertising media, such as radio, out-of-home billboards, print, and television, but focuses on digital marketing extensively. Bellabeat invests year-round in Google Search, maintaining active Facebook and Instagram pages, and consistently engages consumers on Twitter. Additionally, Bellabeat runs video ads on Youtube and display ads on the Google Display Network to support campaigns around key marketing dates.

Sršen knows that an analysis of Bellabeat’s available consumer data would reveal more opportunities for growth. She has asked the marketing analytics team to focus on a Bellabeat product and analyze smart device usage data in order to gain insight into how people are already using their smart devices. Then, using this information, she would like high-level recommendations for how these trends can inform Bellabeat marketing strategy.

### Data Analisys Process

#### 1. Ask

As described in the introduction section, the challenge is to discover some trends in smart devices usage, and then apply theses trends to the company's customers. It's expected that this research helps Bellabeat marketing strategy.

One of our stakeholders, Urška Sršen, cofounder and Chief Creative Officer of Bellabeat, believes that analyzing smart devices fitness data could help unlock new growth opportunities for the company.

Other key stakeholder to be considered is Sando Mur, mathematician and Bellabeat's cofounder; key member of the Bellabeat executive team.

As a secondary stakeholder, the Bellabeat marketing analytics team, is a team of data analysts responsible for collecting, analyzing, and reporting data that helps guide Bellabeat's marketing strategy.

#### 2. Prepare

The data set used is the [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) (CC0:Public Domain, dataset made available through [Mobius](https://www.kaggle.com/arashnic)), as sugested by Sršen.This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.

```{r warning=FALSE}
# importing libraries
library(tidyverse)
library(lubridate)
library(scales)
library(ggthemes)
library(ggpubr)
```

Importing and having an overview of the data

```{r}
# dailyActivity
dailyActivity <- read.csv("dailyActivity_merged.csv")
glimpse(dailyActivity)

# sleepDay
sleepDay <- read.csv("sleepDay_merged.csv")
glimpse(sleepDay)

# weightLogInfo
weightLogInfo <- read.csv("weightLogInfo_merged.csv")
glimpse(weightLogInfo)
```

The data set is in long format, i.e., each row is one time point per Id, so each Id has data in multiple rows.

All variables of a data set can be showed with the function colnames(), from the dplyr package such as below:

```{r}
# dailyActivity
colnames(dailyActivity)

# sleepDay
colnames(sleepDay)

# weightLogInfo
colnames(weightLogInfo)
```

Some meta data from the data sets are showed in the table below

```{r}
data.frame(data_set = c("dailyActivity", "sleepDay", "weightLogInfo"), 
                       no_of_rows = c(nrow(dailyActivity), nrow(sleepDay), nrow(weightLogInfo)), 
                       no_of_distinct_rows = c(n_distinct(dailyActivity), n_distinct(sleepDay), 
                                               n_distinct(weightLogInfo)),
                       no_of_columns = c(ncol(dailyActivity), ncol(sleepDay), ncol(weightLogInfo)), 
                       no_of_distinct_Ids = c(n_distinct(dailyActivity$Id), n_distinct(sleepDay$Id),
                                              n_distinct(weightLogInfo$Id)))
```

As we can see, there are three duplicate observations in the sleepDay data set, once we have 413 number of rows and 410 number of distinct rows. 

The chunk code below shows all duplicate in the sleepDay data set:

```{r}
duplicate_rows <- sleepDay %>% 
  filter(duplicated(sleepDay))
duplicate_rows
```

Another conclusion that we can have is that although it was said that 30 participants attended the research, there were found 33 distinct IDs in the dailyActivity data set, therefore, more than we previously thought, but not all of them attending the complete research because we have 24 for distinct IDs in the sleepDay data set and only 8 in the weighLogInfo data set.

In order to check the credibility and integrity of the data, the method **ROCCC** will be applied:

1. **Reliability**: These data do not seem to be reliable, as the sample is too small (30 users only). Once the entire population of smart devices users should be much bigger, the margin of error is very big for an acceptable confidence level.

2. **Originality**: The data set is not original as it is a third-party data, i.e., data provided from outside sources who did not collect it directly.

3. **Comprehensiveness**: No information about the sample in the research is given, such as age or gender of the participants, so we cannot state that the data is comprehensive enough.

4. **Current**: These data were collected in the first half of 2016, so it is been six years. Although some things may have changed, especially related to new technologies implemented in smart devices, we can consider the data is not too old and may still reflect the present.

5. **Cited**: No information  about the credibility of the data is given besides it was created by Amazon Mechanical Murk, so we cannot state that the data is cited.

Because of the data's integrity and credibility, it may be not possible to provide reliable and compreensive analisys to Bellabeat's executive team, and just a direction to new researchs to be taken in the future. All the caveats will be clearly exposed in the following sections.


#### 3. Process

Now it is time to do some data cleaning!

To get started, I will remove the duplicate rows in the sleepDay data set:

```{r}
sleepDay2 <- unique(sleepDay)

# checking if all rows in sleepDay2 are unique
nrow(sleepDay2) == n_distinct(sleepDay2)
```

To avoid skewed results, I will assume that is unreasonable a person to take 0 steps and walk 0 meters during the day, so I will filter out these cases.

```{r}
dailyActivity2 <- dailyActivity %>% filter(TotalSteps != 0, TotalDistance != 0)
nrow(dailyActivity2)
```

And now we have 862 observations in the dailyActivity2 data set.

In the three data sets, the date columns are formatted as "character", So a new column will be created in each one as "date" and other with the weekdays as well


```{r}
# setting location
Sys.setlocale("LC_TIME", "C")

# dailyActivity
dailyActivity3 <- dailyActivity2 %>% 
  mutate(Date = mdy(ActivityDate), DayOfWeek = weekdays(Date)) %>% 
  select(-c(2)) %>% 
  relocate(Date, .after = 1) %>% 
  relocate(DayOfWeek, .after = 2)
glimpse(dailyActivity3)

# sleepDay
sleepday3 <- sleepDay2 %>%
  separate(SleepDay, c("Date", "Time"), sep = " ") %>% 
  mutate(Date = mdy(Date), DayOfWeek = weekdays(Date)) %>% 
  select(-c(3)) %>% 
  relocate(DayOfWeek, .after = 2)
glimpse(sleepday3)

# weightLogInfo
weightLogInfo2 <- weightLogInfo %>% 
  separate(Date, c("Date", "Time"), sep = " ") %>% 
  mutate(Date = mdy(Date), DayOfWeek = weekdays(Date)) %>% 
  select(-c(3)) %>% 
  relocate(DayOfWeek, .after = 2)
glimpse(weightLogInfo2)
```
Merging the dailyActivity an sleepday data sets

```{r}
dailyActivitySleepDay_merged <- merge(dailyActivity3, sleepday3, by = c("Id", "Date")) %>%
  select(Id, Date, TotalSteps, TotalMinutesAsleep, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes)

dailyActivitySleepDay_merged2 <- dailyActivitySleepDay_merged %>% 
  group_by(Id) %>% 
  summarise(meanTotalSteps = mean(TotalSteps), meanVeryActiveMinutes = mean(VeryActiveMinutes), meanFairlyActiveMinutes = mean(FairlyActiveMinutes), meanLightlyActiveMinutes = mean(LightlyActiveMinutes), meanSedentaryMinutes = mean(SedentaryMinutes), meanTotalMinutesAsleep = mean(TotalMinutesAsleep))
```


#### 4. Analyse

I will now get some statistical summary of the each data set

```{r}

# dailyActivity2
dailyActivity2 %>% 
  select(TotalSteps, TotalDistance, 
         VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, 
         VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, 
         Calories) %>% 
  summary()

# sleepDay2
sleepDay2 %>% 
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed) %>% 
  summary()

# weightLogInfo
weightLogInfo %>% 
  select(WeightKg, BMI) %>% 
  summary()
```

As shown, in the dailyActivity2 data set only a few observations have a very activity routine in comparison with the entire, once the median and mean of VeryActiveDistance and VeryActiveMinutes is too big in percent as well the coefficient of variation.

```{r}
data.frame(cv_VeryActiveDistance = percent(sd(dailyActivity2$VeryActiveDistance) / mean(dailyActivity2$VeryActiveDistance)), cv_VeryActiveMinutes = percent(sd(dailyActivity2$VeryActiveMinutes) / mean(dailyActivity2$VeryActiveMinutes)))
```

On the other hand the coefficient of variation of the light activity routine is smaller, that means the sample trends to have this kind of routine everyday.

```{r}
data.frame(cv_LightActiveDistance = percent(sd(dailyActivity2$LightActiveDistance) / mean(dailyActivity2$LightActiveDistance)), cv_LightlyActiveMinutes = percent(sd(dailyActivity2$LightlyActiveMinutes) / mean(dailyActivity2$LightlyActiveMinutes)))
```

In the sleepDay2 data set it is possible to see all participants sleeps at least once a day, and three times at most. 

In addition, in the weightLogInfo data set, the BMI stands on around 25, considered normal for adults both male and female. Unfortunately only two records of fat are available, so it is not possible to make any analysis of this metric.

```{r}
weightLogInfo %>% 
  count(is.na(Fat))
```

It is possible to see that during the research period, there were no significant changes in the weight of the participants, where the average variation was less than 0.1% as well the BMI variation.

```{r}
variationOfWeightKg <- weightLogInfo %>%
  group_by(Id) %>% 
  mutate(firstWeightKg =  WeightKg[Date == min(Date)], 
         lastWeightKg = WeightKg[Date == max(Date)], 
         weightVariation = (lastWeightKg - firstWeightKg) / firstWeightKg,
         firstBMI = BMI[Date == min(Date)],
         lastBMI = BMI[Date == max(Date)],
         bmiVariation = (lastBMI - firstBMI) / firstBMI) %>% 
  select(Id, firstWeightKg, lastWeightKg, weightVariation, firstBMI, lastBMI, bmiVariation)

variationOfWeightKg2 <- unique(variationOfWeightKg)

variationOfWeightKg2

data.frame(metric = c("weightVariation", "bmiVariation"),
           meanValue = percent(c(mean(variationOfWeightKg2$weightVariation), 
                                 mean(variationOfWeightKg2$bmiVariation))))
```

#### 5. Share

The goal now is to support our analysis through visualizations that will help to find insights that can help the stakeholders make better decisions.

To get started, I will check the relationship between total steps and calories burned:

```{r}
ggplot(data = dailyActivity3, mapping = aes(x = TotalSteps, y = Calories)) +
  geom_point() +
  theme_pander(base_size = 12) +
  geom_smooth(method = "lm") +
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 30000, label.y = 1500) +
  labs(title = "Total Steps vs Calories", x = "Total Steps")
```
In the chart above we see a positive correlation between the total steps and calories burned, supported for a correlation coefficient of 0.56.

Assessing the more activity days:

```{r}
mostActiveDays <- dailyActivity3 %>% 
  group_by(DayOfWeek) %>% 
  summarise(VeryActiveMinutes = sum(VeryActiveMinutes))

# Ordering the days
mostActiveDays$DayOfWeek <- factor(mostActiveDays$DayOfWeek, levels = c("Monday", "Tuesday", "Wednesday", 
                                                                        "Thursday","Friday", "Saturday", 
                                                                        "Sunday"))                               

ggplot(data = mostActiveDays, mapping = aes(x = DayOfWeek, y = VeryActiveMinutes)) +
  geom_col() +
  theme_pander(base_size = 12) +
  labs(title = "Sum of Very Active Minutes in the Weekdays", x = "Day of Week", y = "Sum of Very Active Minutes")
```
The chart above shows us that the most activity days are in the middle of the week, from Tuesday to Thursday and at the weekend the sample trends to reduce its activity.

Assessing the relationship between the sleep minutes and the total time in bed:

```{r}
ggplot(sleepday3, mapping = aes(x = TotalMinutesAsleep, y = TotalTimeInBed)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 200, label.y = 750) +
  theme_pander(base_size = 12) +
  labs(title = "Total Minutes Asleep vs. Total Time in Bed", x = "Total Minutes Asleep", y = "Total Time in Bed")
```
Again a clearly positive correlation between minutes asleep and time in bed.

Assessing the relationship between very active minutes and minutes asleep

```{r}

plotVeryActiveMinutes <- ggplot(dailyActivitySleepDay_merged2, mapping = aes(x = meanVeryActiveMinutes, 
                                                                             y = meanTotalMinutesAsleep)) +
  geom_point() +
  geom_smooth() +
  theme_pander(base_size = 8) +
  labs(title = "Very Active Minutes vs. Total Minutes Asleep", x = "Mean Very Active Minutes", y = "Mean Total Minutes Asleep") + 
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 90)

plotFairlyActiveMinutes <- ggplot(dailyActivitySleepDay_merged2, mapping = aes(x = meanFairlyActiveMinutes, 
                                                                               y = meanTotalMinutesAsleep)) +
  geom_point() +
  geom_smooth() +
  theme_pander(base_size = 8) +
  labs(title = "Fairly Active Minutes vs. Total Minutes Asleep", x = "Mean Fairly Active Minutes", y = "Mean Total Minutes Asleep") + 
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 50)

plotLightlyActiveMinutes <- ggplot(dailyActivitySleepDay_merged2, mapping = aes(x = meanLightlyActiveMinutes, 
                                                                                y = meanTotalMinutesAsleep)) +
  geom_point() +
  geom_smooth() +
  theme_pander(base_size = 8) +
  labs(title = "Lightly Active Minutes vs. Total Minutes Asleep", x = "Mean Lightly Active Minutes", y = "Mean Total Minutes Asleep") + 
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 300)

plotSedendatryMinutes <- ggplot(dailyActivitySleepDay_merged2, mapping = aes(x = meanSedentaryMinutes, 
                                                                                y = meanTotalMinutesAsleep)) +
  geom_point() +
  geom_smooth() +
  theme_pander(base_size = 8) +
  labs(title = "Sedentary Minutes vs. Total Minutes Asleep", x = "Mean Sedentary Minutes", y = "Mean Total Minutes Asleep") +
  stat_cor(aes(label = ..r.label..), r.accuracy = 0.01, label.x = 1000)

arrangedPlot <- ggarrange(plotVeryActiveMinutes, plotFairlyActiveMinutes, plotLightlyActiveMinutes, plotSedendatryMinutes)

annotate_figure(arrangedPlot, top = text_grob("Relationship Between Active Minutes and Total Minutes Asleep", 
                                              face = "bold", size = 16))
```
In the charts above, we see as the activity minutes influence the quality of sleep. Clearly the more sedentary, less minutes sleeping.

#### 6. Act

As stated before, the data must be more comprehensive in order to provide a complete analysis and then a better data-driven decision making.

Bellabeat products focus on women, so only this audience should be considered, but we do not have information about the gender of the participants. Another important feature that must be included is the age of the audience, as it can directly affect the routine and metabolism.

Anyway, we can still do some recommendations to Bellabeat executive team:

1. **Goal** - The users must set a goal when using Bellabeat smart devices, like losing weight or sleep better. Based on it, it would be easier to set metrics to achieve their goals.
2. **Notifications** - The users could receive notifications to track their goals, for example how many steps are left to burn "x" calories.

And finally, as a top high-level insight, it is pretty clear that keeping an active routine is the best choice anyone can make, whether it is to sleep better or stay in shape. There are only benefits. So Bellabeat must keep their users always motivated, showing theirs achievements and giving feedback.