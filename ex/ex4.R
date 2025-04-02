library(reshape2)


### clean up width

width = read.csv("data/ex4/width.csv")

# fix places where text was entered in numeric fields
width$width_m_1[9] = 39.4
width$width_m_1[10] = 20.8
width$width_m_2[9] = 25.4
width$width_m_2[10] = 24.6

# alternative:
# width$width_m_1 = sub("channel [12]: (\\d+)", "\\1", width$width_m_1)
# width$width_m_2 = sub("channel [12]: (\\d+)", "\\1", width$width_m_2)

# replace blanks and text with NA
width$width_m_2[width$width_m_2 == " *mean width"] = NA
width$width_m_2[width$width_m_2 == ""] = NA

# make into numbers
width$width_m_1 = as(width$width_m_1, "numeric")
width$width_m_2 = as(width$width_m_2, "numeric")


# get into tall format, remove unneeded variable column
width_tall = melt(width, id.var = "location_id", value.name = "width_m")
width_tall$variable = NULL



### clean up depth

depth = read.csv("data/ex4/depth.csv")

# find out which columns are not numbers
which(sapply(depth, is.character))

# fix the problems
depth$depth_m_05[depth$depth_m_05 == "gravelbar"] = NA
depth$depth_m_05 = as(depth$depth_m_05, "numeric")

depth$depth_m_19[depth$depth_m_19 == "gravelbar"] = NA
depth$depth_m_19[depth$depth_m_19 == ""] = NA
depth$depth_m_19 = as(depth$depth_m_19, "numeric")

# make it tall
depth_tall = melt(depth, id.vars = "location_id", value.name = "depth_m")

# extract the measurement number and drop the "variable" column
depth_tall$measurement_number = substr(depth_tall$variable, 9, 10)
depth_tall$variable = NULL



### clean up velocity

velocity = read.csv("data/ex4/velocity.csv")

# everything is numeric, so no edits needed here
which(sapply(velocity, is.character))

# make it tall
velocity_tall = melt(velocity, id.vars = "location_id", value.name = "vel_m_per_s")

# extract the measurement number and drop the "variable" column
velocity_tall$measurement_number = substr(velocity_tall$variable, 11, 12)
velocity_tall$variable = NULL


# combine velocity and depth
velo_depth = merge(depth_tall, velocity_tall, by = c("location_id", "measurement_number"))

plot(vel_m_per_s ~ depth_m, data = velo_depth, pch = 16, xlab = "Depth (m)",
	 ylab = "Velocity (m/s)")



### TASK 2
# aggregate datasets separately, it's easier
velocity_mean = aggregate(vel_m_per_s ~ location_id, data = velocity_tall, FUN = mean, na.rm = TRUE)
depth_mean = aggregate(depth_m ~ location_id, data = depth_tall, FUN = mean, na.rm = TRUE)
width_sum = aggregate(width_m ~ location_id, data = width_tall, FUN = sum, na.rm = TRUE)

# merge twice to get a single dataset
velo_depth = merge(velocity_mean, depth_mean, by = "location_id")
discharge_data = merge(velo_depth, width_sum, by = "location_id")

write.csv(discharge_data, "results/discharge_clean.csv")


### TASK 3
discharge_data$discharge = discharge_data$vel_m_per_s * discharge_data$depth_m * discharge_data$width_m

# three plots on one
# give a bit of extra margin space for the label, because of the superscript
par(mar = c(5, 5, 1, 1), mfrow = c(1, 3))
plot(discharge ~ vel_m_per_s, data = discharge_data, pch = 16, xlab = "Velocity (m/s)", 
	 ylab = expression(Discharge~(m^3/s)))
plot(discharge ~ depth_m, data = discharge_data, pch = 16, xlab = "Depth (m)", 
	 ylab = expression(Discharge~(m^3/s)))
plot(discharge ~ width_m, data = discharge_data, pch = 16, xlab = "Width (m)", 
	 ylab = expression(Discharge~(m^3/s)))
 