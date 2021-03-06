## Figure_Yahara_ClimateVsLULC_Ribbons+Density.R
# The goal of this script is to plot the relative importance of 
# climate and LULC on the water balance under the 16 model scenarios.
#
# Input data is generated by the script: Yahara_2_ClimateVsLULC.R

rm(list=ls())

# path to local git repository
git.dir <- "C:/Users/Sam/WorkGits/WaterBalance_ClimateVsLULC/"

require(ggplot2)
require(dplyr)
require(gridExtra)
require(lubridate)
require(reshape2)

# path to save figure output
path.fig <- paste0(git.dir, "Plots/Figures+Tables/")

# use HistLULC_XXclim simulations?
hist.LULC <- F   # T or F

# which method to use? options are PCR, PLS
method <- "PLS"
if (method=="PCR"){
  if (hist.LULC){
    df <- read.csv(paste0(git.dir, "Data/Yahara-AgroIBIS/HistLULC_AllClim_ClimateVsLULC.csv"), stringsAsFactors=F)
  } else {
    df <- read.csv(paste0(git.dir, "Data/Yahara-AgroIBIS/ClimateVsLULC.csv"), stringsAsFactors=F)
  }
  colnames(df)[colnames(df)=="PCR"] <- "stat"
  
} else if (method=="PLS") {
  if (hist.LULC){
    df <- read.csv(paste0(git.dir, "Data/Yahara-AgroIBIS/HistLULC_AllClim_PLS_ClimateVsLULC.csv"), stringsAsFactors=F)
  } else {
    df <- read.csv(paste0(git.dir, "Data/Yahara-AgroIBIS/PLS_ClimateVsLULC.csv"), stringsAsFactors=F)
  }
  colnames(df)[colnames(df)=="PLS"] <- "stat"
}

# figure out what year to start plots
yr.avg.start.plot <- min(df$year[is.finite(df$avg.change.overall.mean)])

# subset for plotting
df <- subset(df, year >= yr.avg.start.plot)

## ribbons - absolute change
p.ribbon.aet.avg <-
  ggplot(subset(df, flux.name=="aet"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min, ymax=avg.change.climate.max), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min, ymax=avg.change.LULC.max), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [mm]") +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.ribbon.drainage.avg <-
  ggplot(subset(df, flux.name=="drainage"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min, ymax=avg.change.climate.max), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min, ymax=avg.change.LULC.max), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [mm]") +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.ribbon.srunoff.avg <-
  ggplot(subset(df, flux.name=="srunoff"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min, ymax=avg.change.climate.max), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min, ymax=avg.change.LULC.max), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [mm]", breaks=seq(0,90,30)) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

pdf(file=paste0(path.fig, "Figure_Yahara_ClimateVsLULC_Ribbons_NoText.pdf"), width=(181/25.4), height=(225/25.4))
grid.arrange(p.ribbon.aet.avg + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             p.ribbon.drainage.avg + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             p.ribbon.srunoff.avg + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             ncol=1)
dev.off()

## ribbons - percent change
p.ribbon.aet.avg.prc <-
  ggplot(subset(df, flux.name=="aet"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean.prc), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min.prc, ymax=avg.change.climate.max.prc), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min.prc, ymax=avg.change.LULC.max.prc), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [%]") +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.ribbon.drainage.avg.prc <-
  ggplot(subset(df, flux.name=="drainage"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean.prc), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min.prc, ymax=avg.change.climate.max.prc), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min.prc, ymax=avg.change.LULC.max.prc), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [%]") +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.ribbon.srunoff.avg.prc <-
  ggplot(subset(df, flux.name=="srunoff"), aes(x=year)) +
  geom_hline(yintercept=0, color="gray65") +
  geom_line(aes(y=avg.change.overall.mean.prc), color="black", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.climate.min.prc, ymax=avg.change.climate.max.prc), fill="#D01D1D", alpha=0.75) +
  geom_ribbon(aes(ymin=avg.change.LULC.min.prc, ymax=avg.change.LULC.max.prc), fill="#18A718", alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Year", expand=c(0,0), breaks=seq(2000,2060,20)) +
  scale_y_continuous(name="Change in Annual Depth [%]", breaks=seq(0,100,50)) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

pdf(file=paste0(path.fig, "Figure_Yahara_ClimateVsLULC_RibbonsPrc_NoText.pdf"), width=(181/25.4), height=(225/25.4))
grid.arrange(p.ribbon.aet.avg.prc + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             p.ribbon.drainage.avg.prc + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             p.ribbon.srunoff.avg.prc + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,5,0), "mm")),
             ncol=1)
dev.off()

## histograms, final two decades only
# statistics
df.hist.aet <- subset(df, year>=2051 & flux.name=="aet")
df.hist.drainage <- subset(df, year>=2051 & flux.name=="drainage")
df.hist.srunoff <- subset(df, year>=2051 & flux.name=="srunoff")

change.overall.aet.all <- c(mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.overall.mean), 
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="AR")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="CC")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="NW")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="AR")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="CC")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="NW")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="AR")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="CC")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="NW")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="AR")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="CC")$change.overall.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="NW")$change.overall.mean))

change.climate.aet.all <- c(mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.climate.mean), 
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="AR")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="CC")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AI" & LULC=="NW")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="AR")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="CC")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="AR" & LULC=="NW")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="AR")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="CC")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="CC" & LULC=="NW")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="AR")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="CC")$change.climate.mean),
                            mean(subset(df.hist.aet, climate=="NW" & LULC=="NW")$change.climate.mean))

change.LULC.aet.all <- c(mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.LULC.mean), 
                         mean(subset(df.hist.aet, climate=="AI" & LULC=="AR")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AI" & LULC=="CC")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AI" & LULC=="NW")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AR" & LULC=="AR")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AR" & LULC=="CC")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="AR" & LULC=="NW")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="CC" & LULC=="AR")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="CC" & LULC=="CC")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="CC" & LULC=="NW")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="NW" & LULC=="AR")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="NW" & LULC=="CC")$change.LULC.mean),
                         mean(subset(df.hist.aet, climate=="NW" & LULC=="NW")$change.LULC.mean))

change.overall.drainage.all <- c(mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.overall.mean), 
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="AR")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="CC")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="NW")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="AR")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="CC")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="NW")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="AR")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="CC")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="NW")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="AR")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="CC")$change.overall.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="NW")$change.overall.mean))

change.climate.drainage.all <- c(mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.climate.mean), 
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="AR")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="CC")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AI" & LULC=="NW")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="AR")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="CC")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="AR" & LULC=="NW")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="AR")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="CC")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="CC" & LULC=="NW")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="AR")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="CC")$change.climate.mean),
                                 mean(subset(df.hist.drainage, climate=="NW" & LULC=="NW")$change.climate.mean))

change.LULC.drainage.all <- c(mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.LULC.mean), 
                              mean(subset(df.hist.drainage, climate=="AI" & LULC=="AR")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AI" & LULC=="CC")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AI" & LULC=="NW")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AR" & LULC=="AR")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AR" & LULC=="CC")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="AR" & LULC=="NW")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="CC" & LULC=="AR")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="CC" & LULC=="CC")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="CC" & LULC=="NW")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="NW" & LULC=="AR")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="NW" & LULC=="CC")$change.LULC.mean),
                              mean(subset(df.hist.drainage, climate=="NW" & LULC=="NW")$change.LULC.mean))

change.overall.srunoff.all <- c(mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.overall.mean), 
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AR")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="CC")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="NW")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AR")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="CC")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="NW")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AR")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="CC")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="NW")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AR")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="CC")$change.overall.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="NW")$change.overall.mean))

change.climate.srunoff.all <- c(mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.climate.mean), 
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AR")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="CC")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AI" & LULC=="NW")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AR")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="CC")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="AR" & LULC=="NW")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AR")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="CC")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="CC" & LULC=="NW")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AR")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="CC")$change.climate.mean),
                                mean(subset(df.hist.srunoff, climate=="NW" & LULC=="NW")$change.climate.mean))

change.LULC.srunoff.all <- c(mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.LULC.mean), 
                             mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AR")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AI" & LULC=="CC")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AI" & LULC=="NW")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AR")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AR" & LULC=="CC")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="AR" & LULC=="NW")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AR")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="CC" & LULC=="CC")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="CC" & LULC=="NW")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AR")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="NW" & LULC=="CC")$change.LULC.mean),
                             mean(subset(df.hist.srunoff, climate=="NW" & LULC=="NW")$change.LULC.mean))

round(c(min(change.overall.aet.all), max(change.overall.aet.all)), 2)
round(c(min(change.climate.aet.all), max(change.climate.aet.all)), 2)
round(c(min(change.LULC.aet.all), max(change.LULC.aet.all)), 2)

round(c(min(change.overall.drainage.all), max(change.overall.drainage.all)), 2)
round(c(min(change.climate.drainage.all), max(change.climate.drainage.all)), 2)
round(c(min(change.LULC.drainage.all), max(change.LULC.drainage.all)), 2)

round(c(min(change.overall.srunoff.all), max(change.overall.srunoff.all)), 2)
round(c(min(change.climate.srunoff.all), max(change.climate.srunoff.all)), 2)
round(c(min(change.LULC.srunoff.all), max(change.LULC.srunoff.all)), 2)



mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.aet, climate=="AI" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AI" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.aet, climate=="AR" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="AR" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.aet, climate=="CC" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="CC" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.aet, climate=="NW" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.aet, climate=="NW" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.drainage, climate=="AI" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AI" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.drainage, climate=="AR" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="AR" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.drainage, climate=="CC" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="CC" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.drainage, climate=="NW" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.drainage, climate=="NW" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AI" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="AR" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="CC" & LULC=="NW")$change.LULC.mean)

mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AR")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="CC")$change.overall.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="NW")$change.overall.mean)

mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.climate.mean)

mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AI")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="AR")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="CC")$change.LULC.mean)
mean(subset(df.hist.srunoff, climate=="NW" & LULC=="NW")$change.LULC.mean)

#
p.climate.LULC.hist.aet <-
  ggplot(subset(df, year>=2051 & flux.name=="aet")) +
  geom_vline(xintercept=0, color="gray65") +
  geom_density(aes(x=change.climate.mean), alpha=0.75, fill="#D01D1D", color=NA) +
  geom_density(aes(x=change.LULC.mean), alpha=0.75, fill="#18A718", color=NA) +
  geom_density(aes(x=change.overall.mean), color="black", fill=NA, alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Change in Annual Depth [mm]", breaks=seq(-50,150,50)) +
  scale_y_continuous(name="Density", breaks=seq(0,0.03,0.01)) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.climate.LULC.hist.drainage <-
  ggplot(subset(df, year>=2051 & flux.name=="drainage")) +
  geom_vline(xintercept=0, color="gray65") +
  geom_density(aes(x=change.climate.mean), alpha=0.75, fill="#D01D1D", color=NA) +
  geom_density(aes(x=change.LULC.mean), alpha=0.75, fill="#18A718", color=NA) +
  geom_density(aes(x=change.overall.mean), color="black", fill=NA, alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Change in Annual Depth [mm]", breaks=seq(-250,250,250)) +
  scale_y_continuous(name="Density", breaks=seq(0,0.008,0.004)) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

p.climate.LULC.hist.srunoff <-
  ggplot(subset(df, year>=2051 & flux.name=="srunoff")) +
  geom_vline(xintercept=0, color="gray65") +
  geom_density(aes(x=change.climate.mean), alpha=0.75, fill="#D01D1D", color=NA) +
  geom_density(aes(x=change.LULC.mean), alpha=0.75, fill="#18A718", color=NA) +
  geom_density(aes(x=change.overall.mean), color="black", fill=NA, alpha=0.75) +
  facet_grid(LULC ~ climate) +
  ggtitle("Top Labels=Climate, Right Side=LULC") +
  scale_x_continuous(name="Change in Annual Depth [mm]") +
  scale_y_continuous(name="Density", breaks=seq(0,0.03,0.01)) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        panel.border=element_rect(color="black"))

pdf(file=paste0(path.fig, "Figure_Yahara_ClimateVsLULC_Density_NoText.pdf"), width=(181/25.4), height=(225/25.4))
grid.arrange(p.climate.LULC.hist.aet + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,7,0), "mm")),
             p.climate.LULC.hist.drainage + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,7,0), "mm")),
             p.climate.LULC.hist.srunoff + theme(text=element_blank(), plot.margin=unit(c(2.5,2.5,7,0), "mm")),
             ncol=1)
dev.off()
