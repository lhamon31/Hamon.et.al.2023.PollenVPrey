#load packages
library(dplyr)
library(tidyr)
library(lme4) #for constructing mixed models
library(lmerTest) #for displaying p-values
library(car) #for Anova function
library(emmeans) #for posthoc tests

#####################################################################################

#1. Pollen and prey supplementation

#load data with seed count by fruit (run with data from either 2019 or 2020 trial)
#2019 trial
dat <- read.csv("Hamon_2023_DionaeaPollenVPrey_2019PollenvPreyTrial.csv", na.strings="NA")
#2020 trial
dat <- read.csv("Hamon_2023_DionaeaPollenVPrey_2020PollenvPreyTrial.csv", na.strings="NA")

#compare non-dormancy and flowering of 2019 plants
#subset unique plant rows to examine plant-level data
uniquedat<-distinct(dat, dat$plantID, .keep_all = TRUE)

#Is there a difference in survivorship/non-dormancy between fed and unfed 2019 plants?
#create survivorship table
dattable <- table(uniquedat$preyTRT, uniquedat$alive2020)
#chi-square test
chisq.test(dattable, correct = FALSE)

#is there a difference in flowering between fed and unfed plants?
#include only plants that produced leaves/were not dormant
uniquedatAlive <- uniquedat %>%
  filter(alive2020 =='Y')
#create table of proportion of fed vs. unfed plants that flowered
dattableAlive <- table(uniquedatAlive$preyTRT, uniquedatAlive$flowering2020)
#chi-square test
chisq.test(dattableAlive, correct = FALSE)

#comparing fitness estimates
#Exclude fruits that were missing/clipped for seed/seedweight, flower, and fruit calculations
datfruit <- dat %>%
  drop_na(noBlkSeeds)

#again, subset unique plant rows to examine plant-level data
uniquedat<-distinct(datfruit, datfruit$plantID, .keep_all = TRUE)

#Is there a difference in a multiplicative fitness estimate (fruit set x average seed set) between treatments?
#create column for multiplicative fruit x average seed set per fruit
uniquedat$multFruitSeed <- uniquedat$totalFlrs*(uniquedat$numberSuccessfulFruit/uniquedat$totalFlrs)*uniquedat$MnNoBlkSeeds
#run ANOVA
model1 <- lm(multFruitSeed ~ pollenTRT*preyTRT, data=uniquedat)
summary(model1)
anova(model1)
TukeyHSD(aov(model1))

#Supplemental: Appendix 2 - does the number of experimental fruits influence the fitness estimates?
suppmodel1 <- lm (multFruitSeed ~ pollenTRT*preyTRT+noExptFruitsTotal , data=uniquedat)
summary(suppmodel1)
anova(suppmodel1)
anova(model1, suppmodel1)

#Supplemental: Appendix 4 - is there a difference in a multiplicative fitness estimate between treatments?
#in this instance, we treat prey as a continuous variable using prey mass
suppmodel2 <- lm(multFruitSeed ~ pollenTRT*totalCricketMass, data=uniquedat)
summary(suppmodel2)
anova(suppmodel2)

#was there a significant effect of feeding treatment on plant-level traits?
#flowers
dat2 <- dat[!is.na(dat$totalFlrs), ] #this removes NA rows
uniquedat<-distinct(dat2, dat2$plantID, .keep_all = TRUE)
t.test(totalFlrs ~ preyTRT, data = uniquedat) 

#fruits
dat2 <- dat[!is.na(dat$numberSuccessfulFruits), ] #this removes NA rows
uniquedat<-distinct(dat2, dat2$plantID, .keep_all = TRUE)
t.test(numberSuccessfulFruits ~ preyTRT, data = uniquedat) 

#is there a difference in number of seeds per fruit between treatments? 
#run linear mixed-effects model
model2<- lmer(noBlkSeeds  ~ pollenTRT*preyTRT + (1 | plantID), data=datfruit) 
summary(model2)
Anova(model2, type = 2, test.statistic =  "F") 

#is there a difference in seed weight between treatments? 
#run linear mixed-effects model
model3<- lmer(mnWtBlkSeeds~ pollenTRT*preyTRT + (1 | plantID), data=datfruit) 
summary(model3)
Anova(model3, type = 2, test.statistic =  "F")

#comparing scape height and trap number
#again, subset unique plant rows to examine plant-level data
uniquedat<-distinct(dat, dat$plantID, .keep_all = TRUE)

#scape height
t.test(stalkHtPollination ~ preyTRT, data = uniquedat)

#number of traps
t.test(totalTraps ~ preyTRT, data = uniquedat) 

#####################################################################################
#2. Plant reproductive biology and pollen-ovule ratio

#load self-compatibility data
dat<-read.csv("Hamon_2023_DionaeaPollenVPrey_SelfCompatibility.csv", na.strings="NA")

#is there a difference in seeds per fruit between treatments?
seedmod<- lmer(noBlkSeeds  ~ TRT + (1|quad), data=dat)
summary(model4) 
Anova(model4, type = 2, test.statistic =  "F") #(Anova from package car), appropriate for NS interactions
#post hoc test
emmeans(model4, list(pairwise ~ TRT), adjust = "tukey")

#is there a difference in mean seed weight between treatments?
model5<- lmer(mnWtBlkSeedsFruit  ~ TRT + (1|quad), data=dat)
summary(model5) 
Anova(model5, type = 2, test.statistic =  "F") 
#post hoc test
emmeans(model5, list(pairwise ~ TRT), adjust = "tukey")
#exclude control/unpollinated treatment and re-run. 
dat2 <-dat %>%
  filter(TRT =='A' | TRT =="G"| TRT =="OC")
model6 <- lmer(mnWtBlkSeedsFruit  ~ TRT + (1|quad), data=dat2)
summary(model6) 
Anova(model6, type = 2, test.statistic =  "F") 
#post hoc test
emmeans(model6, list(pairwise ~ TRT), adjust = "tukey")

#pollen-ovule ratio
#load pollen count and ovule count data
pollendat<-read.csv("Hamon_2023_DionaeaPollenVPrey_PollenCount.csv", na.strings="NA")
ovuledat<-read.csv("Hamon_2023_DionaeaPollenVPrey_OvuleCount.csv", na.strings="NA")

#Average number anthers per flower
mean(pollendat$noMatureAnthers, na.rm=TRUE)

#compare number of anthers/flower between sites
model7 <- aov(noMatureAnthers ~ site, data = pollendat)
summary(model7)
TukeyHSD(model7)

#Average number ovules per ovary
mean(ovuledat$noOvules) 

#compare number of ovules/ovary between sites
model8 <- aov(noOvules ~ site, data = ovuledat)
summary(model8 )
TukeyHSD(model8 )

#Average pollen grains per flower
mean(pollendat$estNoGrainsSample, na.rm=TRUE)

#compare number of pollen grains/flower between sites
model9 <- aov(estNoGrainsSample ~ site, data = pollendat)
summary(model9)
TukeyHSD(model9)

#####################################################################################
#3. Pollinator Effectiveness

#load pollinator effectiveness data
dat<-read.csv("Hamon_2023_DionaeaPollenVPrey_PollinatorEffectiveness.csv")

#remove rows irrelevant to analysis. See "reason" column for rationale. 
dat <- dat %>%
  filter(analysisInclusion == "Y")
#also remove rows where family is not known
dat<- dat[dat$Family!="unknown", ]

#run linear mixed effects model for number of tetrads
pollenmod<- lmer(tetradsMinusMnControl ~ Family + (1|insectID), data=dat)
summary(pollenmod)
Anova(pollenmod, type = 2, test.statistic =  "F") 
library(emmeans)
emmeans(pollenmod, list(pairwise ~ Family), adjust = "tukey")
