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
