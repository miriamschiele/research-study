# set up
library("tidyverse")
library("brms")
library("faintr")
library("aida")

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

# read in data
dat <- read.csv("results_followup.csv", sep=",", header=TRUE) 

#seperate columns
dat <- dat %>%          
  separate(
    # which column to split up
    col = group,
    # names of the new column to store results
    into = c("metaphor", "speaker"),
    # separate by which character / reg-exp
    sep = ", ",
    # automatically (smart-)convert the type of the new cols
    convert = T 
  )

dat <- dat %>% 
  select(-responseTime) %>% 
  pivot_wider(names_from = task, values_from = response)

# information about participants 
# age
min(dat$age, na.rm=T)
# 18
max(dat$age, na.rm=T)
# 1818
tail(sort(dat$age),5)
# 75   75   76   82 1818
mean.age <- dat[!dat$age == "1818",]
mean(mean.age$age, na.rm=T)
# 41.51

# gender
table(dat$gender)
# NA   female   male     other 
# 2    175      318      4 

# political affiliation
table(dat$affiliation)
# Democrat  neither   rather not say     Republican 
#229        157       6                  107 

# education
table(dat$education)
# NA   Did not graduate High-school     Graduated College        Graduated High-school         Higher degree 
# 4    7                                244                      150                           94 

# participants' comments on study
dat %>% pull(comments) %>% unique()

# data sorting by hand (see attached document "categorizing-of-responses.pdf")
# responses are categorized according to Thibodeau & Boroditsky (2011)
# 1=reform: proposed solution suggests investigating the underlying cause of the problem or suggests a particular social reform to treat or inoculate the community
# 2=enforce: proposed solution focuses on the police force or other methods of law enforcement or modifying the criminal justice system
# 3=neither: proposed solution lacked a suggestion
# 4=both: proposed solution includes same number of suggestion for both reform and enforce

# data sorting and cleaning
# suggestions in line of "neighborhood watches" are excluded according to Thibodeau & Boroditsky (2015)

dat <- dat %>% 
  mutate(response_category = c('enforce', 'neither', "reform", "both", "reform", "both", "both", "neither", "reform", "enforce", "enforce", "neither", "reform", "both", "neither", "neither", "neither", "reform", "neither", "reform", "enforce", "reform", "reform", "reform", "enforce", "neither", "neither", "reform", "enforce", "enforce", "both", "enforce", "reform", "enforce", "enforce", "enforce", "neither", "both", "enforce", "both", "neither", "reform", "neither", "reform", "reform", "reform", "reform", "reform", "both", "enforce", "reform", "enforce", "neither", "reform", "enforce", "enforce", "neither", "enforce", "reform", "enforce", "enforce", "enforce", "neither", "neither", "reform", "reform", "enforce", "enforce", "enforce", "enforce", "both", "neither", "reform", "enforce", "enforce", "enforce", "neither", "enforce", "enforce", "enforce", "reform", "reform", "neither", "neither", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "neither", "reform", "both", "enforce", "neither", "neither", "enforce", "neither", "reform", "enforce", "enforce", 
  "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "both", "reform", "enforce", "reform", "enforce", "reform", "reform", "enforce", "reform", "reform", "enforce", "reform", "reform", "neither", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "neither", "enforce", "reform", "reform", "reform", "reform", "reform", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "reform", "both", "reform", "enforce", "neither", "enforce", "enforce", "enforce", "enforce", "neither", "enforce", "reform", "neither", "neither", "reform", "enforce", "enforce", "reform", "enforce", "reform", "both", "enforce", "neither", "reform", "enforce", "both", "reform", "reform", "both", "reform", "neither", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "neither", "enforce", "enforce", "reform", "reform", "reform", "enforce", "enforce", "enforce", "reform", "enforce", "reform", "enforce", "reform", "reform", "reform", "reform", "reform", "neither", "reform", "enforce", "enforce", "reform", "neither", "reform", "neither", "enforce", "enforce", "neither", "enforce", "neither", "enforce", "enforce", "enforce", "enforce", "reform", "neither", "enforce", "reform", "enforce", "both", "enforce", "reform", "enforce", "enforce", "reform", "reform", "reform", "reform", "reform", "both", "enforce", "enforce", "enforce", "enforce", "both", "both", 
  "both", "enforce", "enforce", "reform", "enforce", "enforce", "reform", "reform", "enforce", 
  "enforce", "reform", "reform", "enforce", "both", "both", "reform", "enforce", "enforce", "enforce", "reform", "neither", "enforce", "reform", "both", "enforce", "enforce", "enforce", "neither", "enforce", "enforce", "reform", "enforce", "enforce", "neither", "neither", "reform", "reform", "enforce", "enforce", "enforce", "reform", "reform", "enforce", "reform", "enforce", "enforce", "reform", "enforce", "reform", "enforce", "neither", "enforce", "enforce", "neither",  "reform", "both", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "neither", "both", "reform", "enforce", "reform", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "reform", "enforce", "enforce", "reform", "enforce", "reform", "enforce", "reform", "enforce", "reform", "both", "reform", "reform", "neither", "enforce", "both", "enforce", "enforce", "enforce", "reform", "reform", "reform", "reform", "reform", "reform", "enforce", "both",  "enforce", "reform", "enforce", "enforce", "both", "enforce", "enforce", "reform", "neither", "reform", "reform", "neither", "reform", "reform", "reform", "both", "enforce", "both", "enforce", "reform", "reform", "enforce", "reform", "enforce", "reform", "reform", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "both", "reform", 
  "enforce", "enforce",   "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", 
  "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "reform", "both", "enforce", "enforce", "reform", "neither", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "enforce", "both", "both", "reform", "enforce", "enforce", "both", "enforce", "reform", "reform", "reform", "enforce", "reform", "both", "enforce", "enforce", "neither", "enforce", "both", "both", "both", "enforce", "neither", "reform", "enforce", "reform", "neither", "reform", "both", "reform", "reform", "reform", "enforce", "enforce", "enforce", "both", "reform", "neither",
  "enforce", "reform", "enforce", "reform", "reform", "enforce", "enforce", "neither", "reform", "reform", "neither", "reform", "both", "enforce", "reform", "reform", "enforce", "neither",
  "reform", "enforce", "reform", "reform", "both", "enforce"))

nrow(dat)
# 499

# data plotting
dat %>% 
  group_by(speaker) %>% 
  summarize(
    mean = mean(as.numeric(reliability)),
    SD = sd(as.numeric(reliability))
  )

dat %>% 
  ggplot(aes(x = speaker, y = as.numeric(reliability))) +
  geom_jitter(height = 0) + labs(x = "speaker", y = "reported reliability") 


ggplot(data=dat, aes(x = affiliation, y = as.numeric(reliability), color = speaker)) +
  geom_jitter(height = 0)

dat %>% 
  ggplot(aes(x = speaker, fill = response_category)) +
  geom_bar(position ="dodge") + theme_aida() +
  labs(x = "speaker", y = "number of participants", fill = "response category")

dat %>% 
  ggplot(aes(x = response_category, fill = response_category, )) +
  geom_bar() + theme_aida() + 
  labs(x = "response category", y = "number of participants", fill = "response category")

dat %>% 
  ggplot(aes(x = response_category, fill = response_category, )) +
  facet_wrap(speaker ~ metaphor) +
  geom_bar() + theme_aida() + 
  labs(x = "response category", y = "number of participants", fill = "response category")

# Hypotheses testing

dat_forStats <- dat |> select(metaphor, speaker, response_category) |> 
  mutate(expected_response = case_when(
    metaphor == "beast" ~ response_category == "enforce",
    metaphor == "virus" ~ response_category == "reform",
    TRUE ~ TRUE
  ))

# plotting
tab = table(dat_forStats$speaker,dat_forStats$expected_response)
mosaicplot(tab, xlab = "speaker", ylab = "expected reponse")

# main hypothesis
# the tendency to suggest suggestions in line with the metaphor (enforce for beast and reform for virus) is more prominent in the newscaster condition than in the hooligan condition
# tested by logistic regression model
# as by this method:
fit <- brms::brm(
  seed = 123,
  formula = expected_response ~ speaker * metaphor, 
  data    = dat_forStats,
  family  = bernoulli(link = "logit")
)

faintr::compare_groups(
  fit,
  higher = speaker == "reliable",
  lower  = speaker == "unreliable"
)

# We judge there to be evidence in favor of the hypothesis, if the posterior probability of this difference being bigger than zero is at least 0.95.