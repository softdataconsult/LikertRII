## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----setup--------------------------------------------------------------------
library(RII)
data(building_collapse_nigeria)
head(building_collapse_nigeria[, 1:6])

## -----------------------------------------------------------------------------
items <- building_collapse_nigeria[, 5:14]
tbl <- rii_table(items)
tbl

## -----------------------------------------------------------------------------
summary(tbl)

## -----------------------------------------------------------------------------
set.seed(1)
raw_survey <- data.frame(
  `S/N` = 1:40, GENDER = sample(1:2, 40, TRUE),
  MARITAL = sample(1:3, 40, TRUE),
  OJ1 = sample(1:5, 40, TRUE), OJ2 = sample(1:5, 40, TRUE),
  PJ6 = sample(1:5, 40, TRUE), JS1i = sample(1:5, 40, TRUE),
  check.names = FALSE
)

# review the guess first
detect_likert_items(raw_survey)

# or just let rii_table() use it directly
rii_table(raw_survey, items = "auto")

## ----eval = FALSE-------------------------------------------------------------
#  d <- read.csv("road_infra_survey_raw.csv")   # read the whole file once
#  
#  road_quality <- rii_table(d, items = 4:10)   # Section 1
#  maintenance  <- rii_table(d, items = 11:13)  # Section 2

## -----------------------------------------------------------------------------
text_survey <- data.frame(
  Gender = sample(c("Male", "Female"), 30, TRUE),
  Q1 = sample(c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree"), 30, TRUE),
  Q2 = sample(c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree"), 30, TRUE)
)

# review which columns it would recode, and using which scale
detect_text_likert_items(text_survey)

# recode, then rank — items = "auto" picks up exactly the recoded columns
text_survey2 <- recode_likert(text_survey)
rii_table(text_survey2, items = "auto")

## -----------------------------------------------------------------------------
freq <- data.frame(
  Factor = c("Poor supervision", "Use of substandard materials"),
  SD = c(2, 1), D = c(5, 4), N = c(10, 12), A = c(38, 40), SA = c(95, 93)
)
rii_table_freq(freq, item_col = "Factor")

## -----------------------------------------------------------------------------
raw_path <- system.file("extdata", "rii_raw_example.xlsx", package = "RII")
read_rii_excel(raw_path, layout = "raw",
                items = c("SubstandardMaterials", "PoorSupervision",
                          "InadequateSoilInvestigation", "PoorWorkmanship"))

## ----eval = FALSE-------------------------------------------------------------
#  out <- tempfile(fileext = ".xlsx")
#  write_rii_excel(tbl, out)

## ----fig.alt = "Horizontal bar chart of RII values, sorted from highest to lowest"----
plot(tbl, main = "Causes of Building Collapse in Nigeria")

## ----fig.alt = "Horizontal bar chart of the top five RII values"--------------
plot(tbl, top_n = 5, col = "steelblue",
     main = "Top 5 Causes of Building Collapse")

## -----------------------------------------------------------------------------
rii_raw(items$PoorSupervision)
rii_freq(c(2, 5, 10, 38, 95))

## -----------------------------------------------------------------------------
data(csa_adoption_barriers_nigeria)
csa_items <- csa_adoption_barriers_nigeria[, 6:15]
csa_tbl <- rii_table(csa_items, scale_max = 4)
csa_tbl

## ----fig.alt = "Horizontal bar chart of RII values for barriers to climate-smart agriculture adoption"----
plot(csa_tbl, main = "Barriers to Climate-Smart Agriculture Adoption",
     col = "#6B8E23")

