library(lidR)
library(future)
library(terra)
dirDat17 <- "E:/Healy_lidar/2017/NEON_lidar-point-cloud-line (3)/NEON_lidar-point-cloud-line/NEON.D19.HEAL.DP1.30003.001.2017-07.basic.20240716T141429Z.RELEASE-2024"
dirSave <- "E:/Healy_lidar/maps"

files17 <- list.files(dirDat17, pattern=".laz")

dtm_tin <- list()
chm <- list()

for( i in 1:length(files17)){
  l1 <- readLAS(paste0(dirDat17,"/",files17[i]),
              filter = "-drop_z_below 0")
  Ql <- quantile(l1@data$Z, probs=seq(0,1,by=0.01))

  las <- filter_poi(l1, Z >= Ql[2], Z <= Ql[100])

  dtm_tin[[i]] <- rasterize_terrain(las, res = 1, algorithm = tin())

  nlas <- las - dtm_tin[[i]]

  chm[[i]] <- rasterize_canopy(nlas, 0.5, pitfree(subcircle = 0.2))
  print(paste("finish", files17[i]))
}

dtm_all <- do.call("merge", dtm_tin)
chm_all <- do.call("merge", chm)
plot(dtm_all)
plot(chm_all)

chm_q <- ifel(chm_all > 30, NA, chm_all)
plot(chm_q)

plot(chm[[56]])
res(chm_q)

writeRaster(chm_q, paste0(dirSave, "/chm_17.tif"))
writeRaster(dtm_all, paste0(dirSave, "dtm_17.tif"))

# read in provisional data
dirDat23 <- "E:/Healy_lidar/2023_p/NEON_lidar-point-cloud-line (4)/NEON_lidar-point-cloud-line/NEON.D19.HEAL.DP1.30003.001.2023-08.basic.20240716T151709Z.PROVISIONAL"

files23 <- list.files(dirDat23, pattern=".laz")

dtm_tin23 <- list()
chm23 <- list()

for( i in 1:length(files23)){
  l1 <- readLAS(paste0(dirDat23,"/",files23[i]),
                filter = "-drop_z_below 0")
  
  dtm_tin23[[i]] <- rasterize_terrain(l1, res = 1, algorithm = tin())
  
  nlas <- l1 - dtm_tin23[[i]]
  
  chm23[[i]] <- rasterize_canopy(nlas, 0.5, pitfree(subcircle = 0.2))
  print(paste("finish", i, files23[i]))
}


dtm_all23 <- do.call("merge", dtm_tin23)
chm_all23 <- do.call("merge", chm23)
plot(dtm_all23)
plot(chm_all23)
chm_q23 <- ifel(chm_all23 > 30, NA, chm_all23)
plot(chm_q23)

writeRaster(chm_q23, paste0(dirSave, "/chm_23.tif"))
writeRaster(dtm_all23, paste0(dirSave, "dtm_23.tif"))

chm_q <- rast( paste0(dirSave, "/chm_17.tif"))
dtm_all <- rast( paste0(dirSave, "/mapsdtm_17.tif"))
res(dtm_all23)
dtm_23r <- resample(dtm_all23, dtm_all)
chm_23r <- resample(chm_q23, chm_q)
dtm_23p <- project(dtm_23r, dtm_all)
chm_23p <- project(chm_23r, chm_q)

dtmC <- dtm_23p - dtm_all 
chmC <- chm_23p - chm_q

plot(dtmC)
zoom()
plot(chmC)

fl <- rast("E:/drone/ak/flight_7_5_1nogcp/flight_7_5_24_1_transparent_mosaic_group1.tif")
plot(fl)
plotRGB(fl)
fl2 <- rast("E:/drone/ak/maps/flight_7_5_2_gr.tif")
plotRGB(fl2)
# downsample


f1 <- rast("E:/drone/ak/img24/flight_7_5_24_1_transparent_mosaic_group1.tif")
plotRGB(f1)
makeTiles(f1,c(35000,35000), "E:/drone/ak/maps24_geo/flight1_tile/f7_5_24_1.tif")

rast1 <- rast(ext(f1), resolution=c(0.05,0.05))
crs(rast1) <- crs(f1)
f1rs <- resample(f1, rast1, datatype="INT1U")
