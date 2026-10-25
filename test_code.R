# remotes::install_github("softdataconsult/RII", force = TRUE)
library(RII)

# Built-in data
# Bundled example: 150 Nigerian construction professionals rating
# 10 perceived causes of building collapse on a 5-point scale
data(building_collapse_nigeria)

items <- building_collapse_nigeria[, 5:14]   # just the Likert columns
tbl <- rii_table(items)
tbl
#>                           Item   N  Mean    SD   RII Rank        Band
#> 1              PoorSupervision 150 4.607 0.665 0.921    1        High
#> 2         SubstandardMaterials 150 4.55x 0.xxx 0.9xx    2        High
#> ...


summary(tbl)   # top item, RII range, counts per importance band
windows(width = 10, height = 7)   # Windows
plot(tbl)      # ranked horizontal bar chart

# Importing likert scaled data
#d <- read.csv("https://softdataconsult.com/wp-content/uploads/2026/10/road_infra_survey_raw.csv")
d <- read.csv("Social_media_new.csv")
d2 <- recode_likert(d)              # converts the 5 text Likert columns to numeric
tbl <- rii_table(d2, items = "auto")  # n

library(haven)
read_rii_spss("social_media_survey_data.sav", layout = "raw", items = "auto")                    # labelled numeric (usual case)

# Multiple constructs/sections in one questionnaire.
#d <- read.csv("https://softdataconsult.com/wp-content/uploads/2026/10/road_infra_survey_raw.csv")
d <- read.csv("road_infra_survey_raw.csv")
road_quality <- rii_table(d, items = 11:17)    # Section 1
maintenance  <- rii_table(d, items = 18:23)   # Section 2
supervision  <- rii_table(d, items = 24:28)

road_quality
maintenance
supervision

# write to excel files
write_rii_excel(road_quality, "road_quality_rii_results.xlsx")
write_rii_excel(maintenance, "maintenance_rii_results.xlsx")
write_rii_excel(supervision, "supervision_rii_results.xlsx")

# Social activity data (text responses)
# Multiple constructs/sections in one questionnaire.
#f <- read.csv("https://softdataconsult.com/wp-content/uploads/2026/10/soc_activity_data.csv")
f <- read.csv("soc_activity_data.csv")
d2 <- recode_likert(f)

sectionB <- d2[, 8:17] # answer the 1st objective
sectionC <- d2[, 18:27] # answer the 2nd objective
sectionD <- d2[, 28:37] # answer the 3rd objective
soc_act_type <- rii_table(sectionB, items = "auto")
soc_act_perf <- rii_table(sectionC, items = "auto")
class_attd <- rii_table(sectionD, items = "auto")

soc_act_type
soc_act_perf
class_attd

# write to excel files
write_rii_excel(soc_act_type, "soc_act_type_rii_results.xlsx")
write_rii_excel(soc_act_perf, "soc_act_perf_rii_results.xlsx")
write_rii_excel(class_attd, "class_attd_rii_results.xlsx")


# Using Built-in data

# Bundled example: 150 Nigerian construction professionals rating
# 10 perceived causes of building collapse on a 5-point scale
data(building_collapse_nigeria)

items <- building_collapse_nigeria[, 5:14]   # just the Likert columns
tbl <- rii_table(items)
tbl
#>                           Item   N  Mean    SD   RII Rank        Band
#> 1              PoorSupervision 150 4.607 0.665 0.921    1        High
#> 2         SubstandardMaterials 150 4.55x 0.xxx 0.9xx    2        High
#> ...