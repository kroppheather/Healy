library(terra)
library(neonUtilities)
library(rhdf5)
library(ggplot2)

dirD <- "K:/Environmental_Studies/hkropp/projects/AK_neon"
dirD <- "/Users/hkropp/Documents/offline/Healy"

zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site=c("HEAL"),
              startdate="2018-05", enddate="2018-09",
              savepath=paste0(dirD,"/flux"), 
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


zipsByProduct(dpID="DP1.00041.001", package="basic", 
              site=c("HEAL"),timeIndex=30,
              startdate="2017-05", enddate="2024-05",
              savepath="/Users/hkropp/Documents/offline/Healy", 
              check.size=T)
loadByProduct(dpID="DP1.00041.001", package="basic", 
              site=c("HEAL"),timeIndex=30,
              startdate="2017-05", enddate="2024-05")
