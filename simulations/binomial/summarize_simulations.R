library(scales)
library(tidyverse)


summarize_stats <- function(result) {
  ans <- c( mean(abs(result$est_optrdd_worstcase - result$true_effect) < result$len_optrdd_worstcase ),
          mean(abs(result$est_rdrobust - result$true_effect) < result$len_rdrobust),
          mean(abs(result$est_nir - result$true_effect) < result$len_nir),
          mean(result$len_optrdd_worstcase),
          mean(result$len_rdrobust),
          mean(result$len_nir),
          mean(abs(result$est_optrdd_worstcase - result$true_effect)),
          mean(abs(result$est_rdrobust- result$true_effect)),
          mean(abs(result$est_nir - result$true_effect)))
  ans[1:3] <- label_percent(accuracy = 0.1)(ans[1:3])
  ans[4:9] <- round(as.numeric(ans[4:9]), digits = 3)
  ans <- data.frame(matrix(ans, 9, 1))
  rownames(ans) = c("cov_optrdd_worstcase_ad", "cov_rdrobust", "cov_nir",
                    "len_optrdd_worstcase_avg", "len_rdrobust_avg", "len_nir_avg",
                    "mae_optrdd_worstcase_ad", "mae_rdrobust", "mae_nir")
  return(ans)
}

parameter_mat <- expand.grid(sample_size=c(1000, 2000, 10000), num_trial=c(5, 10, 25, 50, 100, 200), setup=c(1,2))

summarize_instance <- function(instance_number){
  setup <- parameter_mat[instance_number, "setup"]
  sample_size <- parameter_mat[instance_number, "sample_size"]
  num_trial <- parameter_mat[instance_number, "num_trial"]
  filename <- paste(toString(setup), toString(sample_size), toString(num_trial), sep = "_")
  filename <- paste(filename, ".Rds", sep = "")
  colname <- paste0("K=",num_trial, ",n=", sample_size, ",setup=", setup)
  results <- summarize_stats(readRDS(file.path("simulation_results", filename)))
  colnames(results) <- colname
  results
}

res <- list(params = parameter_mat, data_frames = lapply(1:36, summarize_instance))

saveRDS(res, "all_tables_new.Rds")

all_results <- bind_cols(lapply(1:36, summarize_instance))

