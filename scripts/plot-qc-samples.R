suppressPackageStartupMessages(library(tidyverse))

samples <-
  read_tsv(
    "qc-samples.tsv",
    col_names=c("sample", "RIN", "coverage80"),
    na=c("X"),
    col_types=cols_only(
      sample=col_character(),
      RIN=col_number(),
      coverage80=col_number()
    )
  ) %>%
  drop_na() %>%
  extract(
    col=sample,
    into="group",
    regex="^([A-Za-z0-9_]+)_",
    remove=FALSE
  ) %>%
  mutate(group=factor(group))
stop_for_problems(samples)

p <- ggplot(data=samples) +
  geom_point(mapping=aes(x=RIN, y=coverage80, colour=group, shape=group)) +
  scale_shape_manual(values=1:nlevels(samples$group)) +
  theme_minimal() +
  theme(plot.title=element_text(hjust=0.5)) +
  labs(y="Proportion of reads at 80% of gene-body coverage", title="Sample QC")
ggsave("qc-samples.pdf", p)
