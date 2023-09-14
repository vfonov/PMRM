library(nlme)
library(contrast)
library(arrow)

#
# ADNI decline and covariance (case study 1)
#

# Mean ADAS-cog scores 0, 6, 12, 18, 24, and 36 months after baseline
mean_pbo <- c(19.6, 20.5, 20.9, 22.7, 23.8, 27.4)

# Active arm (20% slowing of time-progression)
mean_act <- approx(x = c(0, 6, 12, 18, 24, 36),
                   y = mean_pbo,
                   xout = 0.8 * c(0, 6, 12, 18, 24, 36))$y

# Covariance matrix
cov_adni <- structure(c(45.15, 39.99, 45.1, 54.95, 53.58, 60.82, 
                        39.99, 57.78, 54.38, 66.33, 64.1, 74.67, 
                        45.1, 54.38, 72.01, 79.97, 77.64, 93.11, 
                        54.95, 66.33, 79.97, 109.77, 99.29, 121.66, 
                        53.58, 64.1, 77.64, 99.29, 111.41, 127.83, 
                        60.82, 74.67, 93.11, 121.66, 127.83, 191.41), .Dim = c(6L, 6L))
# Square root of covariance
cov_sqrt <- t(chol(cov_adni))


#
# Simulate trial with 500 subjects per arm
#

source('0_simulate_data.R')
set.seed(123)
dat <- simulate_trial(n_arm = 500,
                      mean_pbo = mean_pbo,
                      mean_act = mean_act,
                      cov_sqrt = cov_sqrt)


########################

write_feather(dat,
    "simulated.arrow",
    compression = "lz4")