library(writexl)
#SAB
sab <- data_indicators("st_anns_bank")
csv <- read.csv("../MarConsNetAnalysis/sandbox/RD/mf_indicators.csv")


#GULLY
gullyi <- csv$Indicator[which(csv$source == "https://waves-vagues.dfo-mpo.gc.ca/library-bibliotheque/342194.pdf")]
gully <- data.frame(indicators=gullyi, area=rep("gully", length(gullyi)))

# MUSQUASH

musquashi <- c("Total biomass/abundance and spatial distribution of key
species in each trophic level","Number of species per trophic level within each habitat
type","Number of species at risk within the MPA (by each
habitat type if required)", "Total area and location of each habitat type within the
               estuary, and the proportion and frequency that is disturbed
               or lost","Hydrodynamic and sediment regime within the estuary
(e.g., sediment infilling)","Temperature and salinity within the estuary",
               "Nutrient concentrations within the estuary",
               "Commercial and recreational fishing catch per unit effort
(CPUE)",
               "By-catch number per impacted species",
               "Number of non-indigenous species in the MPA (within each
habitat type if required) relative to non-indigenous species in
region",
               "Degree of human induced habitat perturbation or loss",
               "Contaminant concentrations within the estuary")

musquash <- data.frame(indicators=musquashi, area="musquash")

df <- rbind(sab,gully,musquash)
write_xlsx(df, "indicators.xlsx")

