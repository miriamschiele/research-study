---
title: "Data Analysis for Replication of the Role of Methaphor in Reasoning"
---

# set up
library("tidyverse")
library("brms")
library("faintr")
library("aida")

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

#read in data of pilot study
dat <- read_csv("results.csv") %>% 
  separate(
    # which column to split up
    col = group,
    # names of the new column to store results
    into = c("metaphor", "vignetteLength"),
    # separate by which character / reg-exp
    sep = ", ",
    # automatically (smart-)convert the type of the new cols
    convert = T 
  ) 

dat <- dat %>% 
  select(-responseTime) %>% 
  pivot_wider(names_from = task, values_from = response)

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
    response_category = c("both","enforce","enforce","enforce","both","both","reform","enforce","enforce","both","reform","enforce","enforce","reform","enforce","enforce","enforce","reform","enforce","enforce","enforce","enforce","enforce","enforce","reform","enforce","enforce","enforce","enforce","enforce","reform","both","enforce","reform","reform","reform","reform","reform","reform","enforce","reform","reform","enforce","enforce","enforce","enforce","enforce","reform","reform","reform","neither","reform","enforce","reform","both","reform","both","enforce","both","reform"),
    response_category = factor(response_category, ordered = T, levels = c("reform", "both", "enforce", "neither"))
  ) %>% 
  filter(response_category != "neither")

# participants' comments on pilot study
dat %>% pull(comments) %>% unique()

# data plotting
dat %>% 
  ggplot(aes(x = vignetteLength, y = as.numeric(reliability))) +
  geom_jitter(height = 0)

dat %>% 
  ggplot(aes(x = affiliation, y = as.numeric(reliability), color = vignetteLength)) +
  geom_jitter(height = 0)

dat %>% 
  ggplot(x = response_category, y= group, aes(x = response_category)) +
  geom_bar()

dat %>% 
  # filter(affiliation == "Democrat") %>% 
  ggplot(aes(x = response_category, fill = response_category)) +
  facet_wrap(metaphor ~ vignetteLength) +
  geom_bar() + theme_aida()

# Hypotheses testing

# Hypothesis 1
# main effect of metaphor, 
# specifically higher rates towards "enforce" for "beast" metaphor
# tested by comparing the posterior estimates for the aggregate value in the "beast" condition with those from the "virus" condition
# as by this method:
fit <- brm(
  formula = response_category ~ metaphor * vignetteLength * affiliation, 
  data = dat,
  family=cumulative("logit")
)

compare_groups(
  fit,
  higher = metaphor == "beast",
  lower  = metaphor == "virus"
)

# We judge there to be evidence in favor of the hypothesis, if the posterior probability of this difference being bigger than zero is at least 0.95.

# We intend to also investigate the following two hypotheses

# Hypothesis 2
# Rates of “enforce” increase for participants that identify their political affiliation as “Republican”. 
# comparison with the grand mean
compare_groups(
  fit,
  higher = affiliation == "Republican"
)
# comparison with Democrats specifically
compare_groups(
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
  data = dat
)

compare_groups(
  fit2, 
  higher = vignetteLength == "long vignette",
  lower  = vignetteLength == "short vignette"
)

# We judge there to be evidence in favor of the hypothesis, if the posterior probability of this difference not being bigger than zero is at least 0.95.

