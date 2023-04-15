# set up
library("tidyverse")
library("brms")
library("faintr")
library("aida")

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

#read in data of replication study
dat <- read.csv("results-replication-study.csv", sep=",", header=TRUE) %>%
  separate(
  col = group,
  into = c("metaphor", "vignetteLength"),
  sep = ", ",
  convert = T
)

dat <- dat %>% 
  select(-responseTime) %>% 
  pivot_wider(names_from = task, values_from = response)

# exclude data of pilot study
dat <- dat[61:260,]

# information about participants
# age
min(dat$age, na.rm=T)
# 18
max(dat$age, na.rm=T)
# 1850
# exclude this data point since it most likely is a typo
# use second highest value instead
tail(sort(dat$age),5)
# 75  76  79  85  1850
# calculate mean without the outlier
age.range = dat$age[!dat$age == 1850]
mean(age.range, na.rm=T)
# 38.86294

# gender
table(dat$gender)
# female   male  other 
# 92       102   3 

# political affiliation
table(dat$affiliation)
# Democrat        neither     rather not say     Republican 
# 108             56          3                  33 

# education
table(dat$education)
# Did not graduate High-school     Graduated College        Graduated High-school    Higher degree 
# 2                                96                       65                       33

# data sorting by hand (see attached document "categorizing-of-responses.pdf")
# responses are categorized according to Thibodeau & Boroditsky (2011)
# 1=reform: proposed solution suggests investigating the underlying cause of the problem or suggests a particular social reform to treat or inoculate the community
# 2=enforce: proposed solution focuses on the police force or other methods of law enforcement or modifying the criminal justice system
# 3=neither: proposed solution lacked a suggestion
# 4=both: proposed solution includes same number of suggestion for both reform and enforce

# data sorting and cleaning
# solutions of the category "neither" are excluded according to Thibodeau & Boroditsky (2011)
# suggestions in line of "neighborhood watches" are excluded according to Thibodeau & Boroditsky (2015)

dat <- dat %>% 
  mutate(
    #
    response_category = c("reform", "both", "both", "reform", "both", "reform", "enforce", "enforce", "reform", "reform", "enforce", "enforce", "reform", "reform", "reform", "enforce", "enforce", "reform", "enforce", "reform", "neither", "reform", "enforce", "neither", "enforce", "reform", "enforce", "enforce", "reform", "enforce", "enforce", "both", "reform", "reform", "reform", "enforce", "both", "reform", "both", "reform", "both", "reform", "reform", "reform", "reform", "both", "both", "reform", "reform", 
                          "reform", "reform", "reform", "both", "both", "reform", "enforce", "enforce", "reform", "neither", "neither", "reform", "reform", "both", "both", "enforce", "enforce", "reform", "enforce", "both", "reform", "enforce", "enforce", "reform", "reform", "enforce", "reform", "reform", "reform", "reform", "neither", "enforce", "both", "reform", "enforce", "enforce", "enforce", "enforce", "neither", "enforce", "reform", "enforce", "reform", "reform", "enforce", "enforce", "enforce", "reform", 
                          "enforce", "enforce", "enforce", "reform", "reform", "enforce", "both", "reform", "enforce", "reform", "both", "neither", "reform", "reform", "reform", "both", "enforce", "enforce", "reform", "reform", "enforce", "both", "reform", "reform", "enforce", "reform", "reform", "neither", "reform", "enforce", "reform", "neither", "enforce", "reform", "enforce", "enforce", "enforce", "both", "enforce", "both", "enforce", "enforce", "neither", "neither", "neither", "enforce", "enforce", "both", 
                          "both", "enforce", "reform", "enforce", "enforce", "both", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "both", "enforce", "neither", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "reform", "enforce", "both", "reform", "enforce", "enforce", "both", "enforce", "enforce", "enforce", "enforce", "reform", "both", "enforce", "enforce", "enforce", "enforce", "reform", "enforce", "enforce", "enforce", "enforce", "reform", "reform", "reform", "reform", 
                          "enforce", "enforce", "enforce", "both", "reform", "enforce", "enforce", "enforce"),
    response_category = factor(response_category, ordered = T, levels = c("reform", "both", "enforce", "neither"))
  )

nrow(dat)
# 200

# excluding participants whose proposed solutions did not include any suggestions
dat <- dat[!dat$response_category == "neither",]
nrow(dat)
# 187
  
# excluding participants who chose "rather not say" for political affiliation to avoid issues associated with unequal sample sizes
dat <- dat[!dat$affiliation == "rather not say",]
nrow(dat)
# 184

# participants' comments on pilot study
dat %>% pull(comments) %>% unique()

# data plotting
dat %>% 
  ggplot(aes(x = vignetteLength, y = as.numeric(reliability))) +
  geom_jitter(height = 0) + labs(x = "vignette Length", y = "reported reliability")

ggplot(data=dat, aes(x = affiliation, y = as.numeric(reliability), color = vignetteLength)) +
  geom_jitter(height = 0)

dat %>% 
  ggplot(aes(x = response_category, fill = response_category, )) +
  geom_bar() + theme_aida() + 
  labs(x = "response category", y = "number of participants", fill = "response category")

dat %>% 
  ggplot(aes(x = metaphor, fill = response_category)) +
  geom_bar(position ="dodge") + theme_aida() +
  labs(x = "metaphor", y = "number of participants", fill = "response category")

dat %>% 
  ggplot(aes(x = response_category, fill = response_category, )) +
  facet_wrap(vignetteLength ~ metaphor) +
  geom_bar() + theme_aida()

# Hypotheses testing

# Hypothesis 1
# main effect of metaphor, 
# specifically higher rates towards "enforce" for "beast" metaphor
# tested by comparing the posterior estimates for the aggregate value in the "beast" condition with those from the "virus" condition
# as by this method:
fit <- brm(
  formula = response_category ~ metaphor * vignetteLength * affiliation, 
  seed = 123,
  data = dat,
  family=cumulative("logit")
)

faintr::compare_groups(
  fit,
  higher = metaphor == "beast",
  lower  = metaphor == "virus"
)

# We judge there to be evidence in favor of the hypothesis, if the posterior probability of this difference being bigger than zero is at least 0.95.

# We intend to also investigate the following two hypotheses

# Hypothesis 2
# Rates of “enforce” increase for participants that identify their political affiliation as “Republican”. 
# comparison with the grand mean
faintr::compare_groups(
  fit,
  higher = affiliation == "Republican"
)
# comparison with Democrats specifically
faintr::compare_groups(
  fit, 
  higher = affiliation == "Republican",
  lower  = affiliation == "Democrat"
)

brms::hypothesis(fit, 'affiliationRepublican > 0')
brms::hypothesis(fit, 'metaphorvirus - affiliationRepublican > 0')

# We judge there to be evidence in favor of the hypothesis, if the posterior probability of this difference being bigger than zero is at least 0.95.

# Hypothesis 3
# The effect of metaphors on reasoning, as proposed in hypothesis 1, does not vary with the length of the metaphorically framed description.
dat %>% 
  group_by(vignetteLength) %>% 
  summarize(
    mean = mean(as.numeric(reliability)),
    SD = sd(as.numeric(reliability))
  )

fit2 <- brm(
  formula = as.numeric(reliability) ~ vignetteLength, 
  seed = 123,
  data = dat
)

faintr::compare_groups(
  fit2, 
  higher = vignetteLength == "long vignette",
  lower  = vignetteLength == "short vignette"
)

# We judge there to be evidence against the hypothesis, that is, evidence in favor of a correlation between vignette length and the effect of metaphors, if the posterior probability of this difference being bigger than zero is at least 0.95
faintr::compare_groups(
  fit, 
  higher = vignetteLength == "long vignette",
  lower  = vignetteLength == "short vignette"
)
