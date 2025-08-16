# R/13_report_tables.R
# Goal: export tidy tables and key numbers for the paper + session info.
# Inputs (produced earlier):
#   data/processed/sent_stop_summary.rds
#   data/processed/sent_chapter_summary.rds
#   data/processed/diag_stop_overview.rds
#   data/processed/diag_chap_overview.rds
#   data/processed/diag_lexicon_agreement.rds
#   data/processed/diag_negation_stats.rds
#   data/processed/diag_unscored_top.rds
#   data/processed/diag_extreme_sentences.rds
# Outputs:
#   outputs/tables/*.csv
#   outputs/meta/session_info.txt
#   outputs/meta/report_numbers.csv

# load
need <- c(
  "sent_stop_summary.rds", "sent_chapter_summary.rds",
  "diag_stop_overview.rds", "diag_chap_overview.rds",
  "diag_lexicon_agreement.rds", "diag_negation_stats.rds",
  "diag_unscored_top.rds", "diag_extreme_sentences.rds"
)
paths <- file.path(here::here("data/processed"), need)
stopifnot(all(file.exists(paths)))

sent_stop  <- readr::read_rds(paths[1])
sent_chap  <- readr::read_rds(paths[2])
diag_stop  <- readr::read_rds(paths[3])
diag_chap  <- readr::read_rds(paths[4])
diag_lex   <- readr::read_rds(paths[5])
diag_neg   <- readr::read_rds(paths[6])
diag_unsc  <- readr::read_rds(paths[7])
diag_xtrem <- readr::read_rds(paths[8])

# output dirs
dir_tables <- here::here("outputs/tables")
dir_meta   <- here::here("outputs/meta")
dir.create(dir_tables, showWarnings = FALSE, recursive = TRUE)
dir.create(dir_meta,   showWarnings = FALSE, recursive = TRUE)

# export CSVs
readr::write_csv(diag_stop,  file.path(dir_tables, "stop_overview.csv"))
readr::write_csv(diag_chap,  file.path(dir_tables, "chapter_overview.csv"))
readr::write_csv(diag_lex,   file.path(dir_tables, "lexicon_agreement.csv"))
readr::write_csv(diag_neg,   file.path(dir_tables, "negation_stats.csv"))
readr::write_csv(diag_unsc,  file.path(dir_tables, "unscored_top_tokens.csv"))
readr::write_csv(diag_xtrem, file.path(dir_tables, "extreme_sentences.csv"))
readr::write_csv(sent_stop,  file.path(dir_tables, "stop_sentiment_summary.csv"))
readr::write_csv(sent_chap,  file.path(dir_tables, "chapter_sentiment_summary.csv"))

# key numbers for the paper
nums <- tibble::tibble(
  n_stops              = dplyr::n_distinct(sent_stop$order),
  mean_coverage        = mean(sent_stop$coverage, na.rm = TRUE),
  median_coverage      = stats::median(sent_stop$coverage, na.rm = TRUE),
  min_coverage         = min(sent_stop$coverage, na.rm = TRUE),
  max_coverage         = max(sent_stop$coverage, na.rm = TRUE),
  min_stop_valence     = min(sent_stop$mean_val_base_scored, na.rm = TRUE),
  max_stop_valence     = max(sent_stop$mean_val_base_scored, na.rm = TRUE),
  r_afinn_bing         = diag_lex$r_afinn_bing[1],
  r_afinn_nrc          = diag_lex$r_afinn_nrc[1],
  r_bing_nrc           = diag_lex$r_bing_nrc[1]
)
readr::write_csv(nums, file.path(dir_meta, "report_numbers.csv"))

# session info (reproducibility)
sink(file.path(dir_meta, "session_info.txt"))
print(Sys.time())
print(sessionInfo())
sink()

message("Tables exported to outputs/tables/, key numbers & session info to outputs/meta/.")
