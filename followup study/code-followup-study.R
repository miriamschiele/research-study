# set up
library("tidyverse")
library("brms")
library("faintr")
library("aida")

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

# read in data
dat <- read.csv("results_followup_first50.csv", sep=",", header=TRUE) 

dat <- dat[order(dat$submission_id),]

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
# 19
max(dat$age, na.rm=T)
# 59
mean(dat$age, na.rm=T)
# 32.4

# gender
table(dat$gender)
# NA  female   male  other 
# 1     21     27      1 

# political affiliation
table(dat$affiliation)
#Democrat        neither rather not say     Republican 
#22             19              1              8 

# education
table(dat$education)
# Graduated College Graduated High-school Higher degree 
# 26                17                    7 

# participants' comments on study
dat %>% pull(comments) %>% unique()

write.csv(dat, file="dat.followup-first50.csv")

# data sorting by hand (see attached document "categorizing-of-responses.pdf")
# responses are categorized according to Thibodeau & Boroditsky (2011)
# 1=reform: proposed solution suggests investigating the underlying cause of the problem or suggests a particular social reform to treat or inoculate the community
# 2=enforce: proposed solution focuses on the police force or other methods of law enforcement or modifying the criminal justice system
# 3=neither: proposed solution lacked a suggestion
# 4=both: proposed solution includes same number of suggestion for both reform and enforce

# data sorting and cleaning
# suggestions in line of "neighborhood watches" are excluded according to Thibodeau & Boroditsky (2015)

dat <- dat %>% 
  mutate(response_category = c("enforce",	"both",	"neither",	"neither",	"neither",	"neither",	"enforce",	"reform",	"reform",	"reform",	"reform",	"neither",	"reform",	"reform",	"both",	"enforce",	"reform",	"enforce",	"reform",	"enforce",	"both",	"enforce",	"reform",	"neither",	"neither",	"enforce",	"reform",	"reform",	"reform",	"reform",	"enforce",	"both",	"reform",	"enforce",	"reform",	"reform",	"enforce",	"reform",	"enforce",	"neither",	"enforce",	"reform",	"reform",	"enforce",	"neither",	"reform",	"reform",	"reform",	"enforce",	"both"))

nrow(dat)
# 50

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

# main hypothesis
# the tendency to suggest suggestions in line with the metaphor (enforce for beast and reform for virus) is more prominent in the newscaster condition than in the hooligan condition
# tested by logistic regression model
# as by this method:
fit <- brms::brm(
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