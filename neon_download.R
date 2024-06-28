library(terra)
library(neonUtilities)
library(rhdf5)
library(ggplot2)

dirD <- "K:/Environmental_Studies/hkropp/projects/AK_neon"


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site=c("HEAL"),
              startdate="2018-06", enddate="2018-06",
              savepath=paste0(dirD,"/06_2018"), 
              check.size=F)

flux <- stackEddy(filepath=paste0(dirD,"/06_2018/filesToStack00200"),
                  level="dp04")

fluxDF <- flux$HEAL
fluxVar <- flux$variables


zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site=c("HEAL"),
              startdate="2018-07", enddate="2018-07",
              savepath=paste0(dirD,"/07_2018"), 
              check.size=F)

fluxJ <- stackEddy(filepath=paste0(dirD,"/07_2018/filesToStack00200"),
                  level="dp04")

fluxDFJ <- fluxJ$HEAL
fluxVarJ <- fluxJ$variables
fluxLog <- fluxJ