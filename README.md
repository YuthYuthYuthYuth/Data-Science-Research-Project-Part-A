# Data-Science-Research-Project-Part-A
I Will try and comment as much as I can regarding what I have done for the Codes for my research project A. To make it easy to read and follow, I will outline it with numbers in numerically order!

1) What this project does
This repository provides a completely replicable R pipeline to examine if the narrator's tone in Jules Verne's Around the World in 80 Days fluctuates with location. We acquire the public-domain text from Project Gutenberg, normalise and de-paratext the novel, eliminate dialogue using quote-aware filters to preserve the narrator's voice, segment the narrative into 19 geographic locations, tokenize, evaluate tokens with three sentiment lexicons (AFINN, Bing, NRC) employing minimal contextual rules (negation/intensifiers/downtoners), summarise by location with bootstrap confidence intervals and an LOESS smooth, and produce the figures and tables utilised in the paper.

2) Quick start
Open the project in RStudio (recommended).

Run scripts in numeric order from 00_...R through 14_...R.
Each script writes its results to data/processed and/or outputs/*, so you can resume from any point.

Outputs will appear in:

outputs/figures/ (PNG figures for the paper)

outputs/tables/ (CSV and LaTeX table snippets)

data/processed/ (.rds intermediates used by later steps)

Paths are relative via here::here(); you can run from the project root regardless of OS.

3) Software & packages
R (≥ 4.2 recommended)

CRAN packages: tidyverse, here, readtext or readr, stringr, tidytext, textdata, tokenizers, dplyr, purrr, ggplot2, scales, forcats, broom, modelr, cowplot, ggtext

For the route map: sf, rnaturalearth, rnaturalearthdata, geosphere (or ggplot2::map_data fallback)

4) Repository layout
/data
  /raw           <- original inputs (downloaded Gutenberg text, etc.)
  /processed     <- intermediate .rds objects (token lists, scores, summaries)
  
/outputs
  /figures       <- final PNGs used in the paper
  /tables        <- final CSVs and LaTeX table snippets

/scripts (if you keep them here) or project root
  00_setup.R
  01_download_text.R
  02_normalise_paratext.R
  03_quote_filters.R
  04_segment_stops_and_route_map.R
  05_tokenise.R
  06_join_lexicons.R
  07_context_rules.R
  08_aggregate_by_stop.R
  09_bootstrap_and_loess.R
  10_fig_journey_curve.R
  11_fig_bars_with_CIs.R
  12_fig_lexicon_facets.R
  13_fig_lexicon_overlay.R
  14_tables.R

  5) Script-by-script guide (00–14)
00_setup.R

Installs/loads packages, sets global options, seeds resampling for reproducibility.

Creates data/raw, data/processed, outputs/figures, outputs/tables if missing.

01_download_text.R

Downloads Around the World in 80 Days from Project Gutenberg to data/raw/.

Saves a canonical UTF-8 text file. (If offline, expects the file to already exist.)

02_normalise_paratext.R

Removes licence/front/back matter and other paratext to retain the novel only.

Normalises whitespace, punctuation spacing, and lower-case copy for lexicon matching (archival case preserved separately).

Writes data/processed/novel_clean.rds.

03_quote_filters.R

Builds two quote-aware narrator filters: strict (max removal) and conservative (keeps nearby narration).

Applies both to the clean text; conservative is used downstream by default.

Writes data/processed/narrator_strict.rds and .../narrator_conservative.rds.

04_segment_stops_and_route_map.R

Maps chapters/paragraphs to 19 journey stops (London → … → London) and aggregates narrator text per stop.

Creates geocoordinates for the 19 stops and draws the route map (great-circle arcs).

Outputs:

data/processed/stops_segments.rds

Figure: outputs/figures/fig06_route-map.png (label fig:route-map)

05_tokenise.R

Sentence tokenisation (for diagnostics) and word tokenisation (no stemming).

Saves token lists per stop: data/processed/tokens_by_stop.rds.

06_join_lexicons.R

Loads three lexicons (AFINN, Bing, NRC) via textdata/bundled copies.

Joins tokens with lexicon entries; records coverage (share of tokens scored).

Outputs data/processed/lexicon_scored.rds.

07_context_rules.R

Applies light negation, intensifier, downtoner rules within a short window.

Adjusts token scores accordingly; saves data/processed/scored_context.rds.

08_aggregate_by_stop.R

Aggregates to per-stop summaries: mean valence per lexicon, overall mean (if used), and coverage.

Writes data/processed/stop_means.rds.

09_bootstrap_and_loess.R

Nonparametric bootstrap (per stop) to estimate 95% CIs.

Fits LOESS smooth for the overall trajectory (span set here).

Writes data/processed/stop_means_boot.rds and .../loess_fit.rds.

10_fig_journey_curve.R

Produces Figure 2: Emotional Journey Across Stops (curve + LOESS)
File: outputs/figures/fig02_journey-curve.png (label fig:journey-curve).

11_fig_bars_with_CIs.R

Produces Figure 3: Per-stop sentiment bars with CIs & coverage decimals
File: outputs/figures/fig03_stop-bars.png (label fig:bars).

12_fig_lexicon_facets.R

Produces Figure 4: Lexicon-specific trends (AFINN/Bing/NRC small multiples)
File: outputs/figures/fig04_lexicon-facets.png (label fig:lexicon-panel).

13_fig_lexicon_overlay.R

Produces Figure 5: Overlaid lexicon comparison (clean lines)
File: outputs/figures/fig05_lexicon-overlay.png (label fig:lexicon-overlay).

14_tables.R

Computes numeric extremes (max positive & min mean) and the full per-stop table.

Outputs:

Table 1 snippet (LaTeX): outputs/tables/tab_extremes.tex (label tab:extremes)

Full table (CSV and/or LaTeX in Appendix): outputs/tables/tab_allstops.csv and tab_allstops.tex (label tab:allstops)

6) How to reproduce exactly
Run each script from the project root:

source("00_setup.R")
source("01_download_text.R")
source("02_normalise_paratext.R")
source("03_quote_filters.R")
source("04_segment_stops_and_route_map.R")
source("05_tokenise.R")
source("06_join_lexicons.R")
source("07_context_rules.R")
source("08_aggregate_by_stop.R")
source("09_bootstrap_and_loess.R")
source("10_fig_journey_curve.R")
source("11_fig_bars_with_CIs.R")
source("12_fig_lexicon_facets.R")
source("13_fig_lexicon_overlay.R")
source("14_tables.R")

7) Key parameters you can change (all in scripts)
Quote filter used: set to "conservative" by default in 03_quote_filters.R / used downstream.

Negation/intensity window: small window in 07_context_rules.R.

LOESS span: set in 09_bootstrap_and_loess.R.

Bootstrap reps: set in 09_bootstrap_and_loess.R.

All changes propagate to figures/tables when you re-run later scripts.


8) Data & licensing
Source text: Project Gutenberg (public domain).

Derived data/figures in outputs/ were generated by the scripts above.

Lexicons: AFINN, Bing Liu, NRC (see paper references for attribution).


9) Troubleshooting
Paths: All scripts use here::here(); run from the project root.

Encoding: The novel is handled as UTF-8. If you see garbled punctuation, confirm your locale is UTF-8.

Packages not found: Run 00_setup.R again to install/load dependencies.

Maps: If sf/rnaturalearth fail to install, switch the route map code to ggplot2::map_data("world") (fallback is included/commented where applicable).

Re-running: Intermediates in data/processed/ allow you to skip earlier steps; delete files to force regeneration.


10) Figure & table checklist (for the paper)
Fig. 1 Methods pipeline overview (fig01_methods-pipeline.png) – optional static asset you can include.

Fig. 2 Emotional Journey Across Stops — curve + LOESS.

Fig. 3 Per-stop bar chart with 95% CIs and coverage.

Fig. 4 Lexicon-specific trends (AFINN/Bing/NRC facets).

Fig. 5 Overlaid lexicon comparison (clean lines).

Fig. 6 Route map with numbered stops.

Table 1 Numeric extremes (Calcutta most positive; Bombay lowest mean).

Appendix Table Full per-stop means, 95% CIs, coverage.
