suppressPackageStartupMessages(library(optparse))

option_list <- list(
  make_option(c("-s", "--samples"), type="character", default="samples.tsv", help="Samples file in TSV format [default \"%default\"]", dest="samples_file"),
  make_option(c("-o", "--output_dir"), type="character", default="deseq2", help="Output directory [default \"%default\"]", dest="output_dir"),
  make_option(c("--all"), type="character", default="all.tsv", help="'all' file in TSV format [default \"%default\"]", dest="all_file"),
  make_option(c("--sig"), type="character", default="sig.tsv", help="'sig' file in TSV format [default \"%default\"]", dest="sig_file")
)
opt <- parse_args(OptionParser(option_list=option_list))

suppressPackageStartupMessages(library(tidyverse))
options(readr.show_progress=FALSE)

custom_palette <- function(palette_size = 8) {
  colour_blind_palette <- c(
    "vermillion" = rgb(0.8, 0.4, 0),
    "blue_green" = rgb(0, 0.6, 0.5),
    "blue" = rgb(0,0.45,0.7),
    "yellow" = rgb(0.95, 0.9, 0.25),
    "sky_blue" = rgb(0.35, 0.7, 0.9),
    "purple" = rgb(0.8, 0.6, 0.7),
    "black" = rgb(0, 0, 0),
    "orange" = rgb(0.9, 0.6, 0),
    "grey60" = "#999999",
    "grey20" = "#333333"
  )
  if (palette_size <= 10) {
    palette <- colour_blind_palette[seq_len(palette_size)]
    palette <- unname(palette)
  } else {
    palette <- scales::hue_pal()(palette_size)
  }

  return(palette)
}

# Get samples
num_columns <- count_fields(opt$samples_file, tokenizer_tsv(), n_max=1)
if (num_columns == 2) {
  samples <- read_tsv(
    opt$samples_file,
    col_names=c("sample", "condition"),
    col_types=cols(
      sample=col_character(),
      condition=col_factor()
    )
  )
  stop_for_problems(samples)
} else if (num_columns == 3) {
  samples <- read_tsv(
    opt$samples_file,
    col_names=c("sample", "condition", "group"),
    col_types=cols(
      sample=col_character(),
      condition=col_factor(),
      group=col_factor()
    )
  )
  stop_for_problems(samples)
} else {
  stop("Samples file must have two or three columns")
}

# Get all file
all <- read_tsv(opt$all_file)
all <- select(all, Gene, ends_with(" normalised count"))
all <- rename_with(all, ~ str_replace_all(.x, " normalised count", ""))

# Get sig file
sig <- read_tsv(opt$sig_file)
sig <- select(sig, Gene:Description)

# Plot counts
colour_palette <- custom_palette(nlevels(samples$condition))
names(colour_palette) <- levels(samples$condition)
pdf(str_c(opt$output_dir, "/", "counts-all.pdf"))
for (i in seq.int(nrow(sig))) {
  countData <- filter(all, Gene == sig$Gene[i])
  countData <- select(countData, !Gene)
  counts <- pivot_longer(countData, everything(), names_to="sample", values_to="count")
  counts <- inner_join(counts, samples, by="sample")
  counts$sample <- fct_relevel(counts$sample, samples$sample)
  title <- sprintf("%s / %s\n%s:%d-%d\np = %.3g", sig$Gene[i], sig$Name[i], sig$Chr[i], sig$Start[i], sig$End[i], sig$adjp[i])
  p <- ggplot(data = counts, aes_(x = as.name("sample"), y = as.name("count"))) +
    geom_point(aes_(fill = as.name("condition")), size = 3, shape = 21, colour = "black") +
    scale_fill_manual(values = colour_palette) +
    labs(title = title, x = NULL, y = "Normalised Counts") +
    theme_minimal(base_size = 12) +
    theme(strip.background = element_rect(fill = "grey90", colour = "grey90"), axis.text.x = element_text(angle = 90))
  print(p)
}
dev.off()
