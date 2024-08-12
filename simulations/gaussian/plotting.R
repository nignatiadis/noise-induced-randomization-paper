library(tidyverse)
library(cowplot)
files <- list.files(path = "simulation_results",
  pattern = "\\.Rds$",
  full.names = TRUE)

# Load all .Rds files into a list
loaded_files <- lapply(files, function(file) {
  readRDS(file)
})


df <- bind_rows(loaded_files)

df <- mutate(df,
  covers = abs(true_tau - est) <= halfci, 
  abs_error = abs(true_tau - est)
)




summarize_df <- group_by(df, method, sd, distrib, n) %>%
  summarize(coverage = mean(covers),
            halfci = mean(halfci),
            mae = mean(abs_error),
            nreps = n())

rdrobust_rows <- summarize_df %>%
  filter(method == "rdrobust") %>%
  select(-method, -sd) %>%
  mutate(sd = 0.1)  # manually positioning 'rdrobust' points

# Filter rows for NIR
nir_rows <- summarize_df %>%
  filter(method == "NIR")

# Combine rdrobust and NIR rows
plot_data <- bind_rows(rdrobust_rows, nir_rows)

# Creating the plot
p1 <- ggplot(plot_data, aes(x = sd, y = coverage, color = distrib, shape = distrib)) +
  geom_point(data = rdrobust_rows, aes(x = 0.1), size = 3) +
  geom_point(data = nir_rows, aes(color = distrib, shape = distrib), size = 3) +  # Add points for NIR
  geom_line(data = nir_rows, aes(linetype = distrib), linewidth = 1) +  # Use only NIR rows for lines
  geom_vline(xintercept = 0.15, color = "grey") +
  labs(x = NULL, y = "Coverage") +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_blank(),        # Remove legend title
        legend.position = c(0.2, 0.2),       # Position to bottom left
        legend.justification = c(0, 0)) +
  scale_x_continuous(
    breaks = c(0.1, 0.3, 0.5, 0.7, 0.9),
    labels = c("rdrobust", "NIR(0.3)", "NIR(0.5)", "NIR(0.7)", "NIR(0.9)")
  ) +
  scale_color_manual(
    values = c("normal" = "purple", "t" = "orange", "laplace"="darkgreen"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  ) +
  scale_linetype_manual(
    values = c("normal" = "solid", "t" = "dashed", "laplace" = "dotted"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  )  +
  scale_shape_manual(
    values = c("normal" = 16, "t" = 17, "laplace" = 18),
    breaks = c("normal", "t", "laplace"),
    labels = c("Gaussian", "t (6 df)", "Laplace")
  ) +
  geom_hline(yintercept = 0.95, color="grey", linetype="dashed")
p1

p2 <- ggplot(plot_data, aes(x = sd, y = halfci, color = distrib, shape = distrib)) +
  geom_point(data = rdrobust_rows, aes(x = 0.1), size = 3) +
  geom_point(data = nir_rows, aes(color = distrib, shape = distrib), size = 3) +  # Add points for NIR
  geom_line(data = nir_rows, aes(linetype = distrib), linewidth = 1) +  # Use only NIR rows for lines
  geom_vline(xintercept = 0.15, color = "grey") +
  labs(x = NULL, y = "Length") +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_blank(),        # Remove legend title
        legend.position = c(0.2, 0.2),       # Position to bottom left
        legend.justification = c(0, 0)) +
  scale_x_continuous(
    breaks = c(0.1, 0.3, 0.5, 0.7, 0.9),
    labels = c("rdrobust", "NIR(0.3)", "NIR(0.5)", "NIR(0.7)", "NIR(0.9)")
  ) +
  scale_color_manual(
    values = c("normal" = "purple", "t" = "orange", "laplace"="darkgreen"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  ) +
  scale_linetype_manual(
    values = c("normal" = "solid", "t" = "dashed", "laplace"="dotted"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  )  +
  scale_shape_manual(
    values = c("normal" = 16, "t" = 17, "laplace" = 18),
    breaks = c("normal", "t", "laplace"),
    labels = c("Gaussian", "t (6 df)", "Laplace")
  ) 
p2

p3 <- ggplot(plot_data, aes(x = sd, y = mae, color = distrib, shape = distrib)) +
  geom_point(data = rdrobust_rows, aes(x = 0.1), size = 3) +
  geom_point(data = nir_rows, aes(color = distrib, shape=distrib), size = 3) +  # Add points for NIR
  geom_line(data = nir_rows, aes(linetype = distrib), linewidth = 1) +  # Use only NIR rows for lines
  geom_vline(xintercept = 0.15, color = "grey") +
  labs(x = NULL, y = "MAE") +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_blank(),        # Remove legend title
        legend.position = c(0.15, 0.4),       # Position to bottom left
        legend.justification = c(0, 0)) +
  ylim(c(0, 0.15)) + 
  scale_x_continuous(
    breaks = c(0.1, 0.3, 0.5, 0.7, 0.9),
    labels = c("rdrobust", "NIR(0.3)", "NIR(0.5)", "NIR(0.7)", "NIR(0.9)")
  ) +
  scale_color_manual(
    values = c("normal" = "purple", "t" = "orange", "laplace"="darkgreen"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  ) +
  scale_linetype_manual(
    values = c("normal" = "solid", "t" = "dashed", "laplace"="dotted"),
    breaks = c("normal", "t", "laplace"),  # Order
    labels = c("Gaussian", "t (6 df)", "Laplace")
  )  +
  scale_shape_manual(
    values = c("normal" = 16, "t" = 17, "laplace" = 18),
    breaks = c("normal", "t", "laplace"),
    labels = c("Gaussian", "t (6 df)", "Laplace")
  )
p3

# Saving the plots

ggsave2("misspecification_coverage.pdf", p1, width=11, height=9, units="cm")
ggsave2("misspecification_length.pdf", p2, width=11, height=9, units="cm")
ggsave2("misspecification_mae.pdf", p3, width=11, height=9, units="cm")
