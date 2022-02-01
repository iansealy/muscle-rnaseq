suppressPackageStartupMessages(library(tidyverse))

rmats <-
  read_tsv(
    "rmats.tsv",
    col_names=TRUE,
    col_types=cols_only(
      Comparison=col_character(),
      Event=col_factor(),
      Sig=col_number(),
      Type=col_factor()
    )
  )
stop_for_problems(rmats)
p <- ggplot(data=rmats, aes(x=Comparison, y=Sig, colour=Type, group=Event)) +
facet_wrap(~ Event) +
  geom_point() +
  xlab("Comparison") +
  ylab("Number of significant events") +
  theme_minimal(base_size = 12) +
  theme(strip.background = element_rect(fill = "grey90", colour = "grey90"), axis.text.x = element_text(angle = 90))
ggsave("rmats.pdf", p)
