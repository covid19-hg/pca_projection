# Plot projected PCs

Once `project_pc.sh` finished, please run `Rscript plot_projected_pc.R` to plot all the projected PCs. This script also generates a text file containing per-sample projected PCs **without including cohort-specific individual IDs**.

## Required packages
To run the script, please install the following packages.
```
install.packages(c("data.table", "hexbin", "optparse", "patchwork", "R.utils", "tidyverse"))
```

## Available options
```
Rscript plot_projected_pc.R \
  --sscore [path to .sscore output] \
  --phenotype-file [path to phenotype file] \
  --phenotype-col [phenotype column name]
  --covariate-file [path to covariate file] \
  --pc-prefix [prefix of PC columns: default "PC"] \
  --pc-num [number of PCs used in GWAS] \
  --ancestry [ancestry code: AFR, AMR, EAS, EUR, MID, or SAS] \
  --study [your study name] \
  --out [output name prefix]
```

Ancestry codes for `--ancestry` are from [the flagship paper](https://www.medrxiv.org/content/10.1101/2021.03.10.21252820v1):
* African (AFR)
* Admixed American (AMR)
* East Asian (EAS)
* European (EUR)
* Middle Eastern (MID)
* South Asian (SAS)

If your cohort contains multiple ancestries, please use `--ancestry-file` and `--ancestry-col` to specify for each individual.
```
  --ancestry-file [path to ancestry file] \
  --ancestry-col [ancestry column name]
```

If your cohort submits multiple analyses, please run the script with different `--phenotype-col`. It will automatically excludes samples without case/control status.

If your system doesn't have access to the Internet, please download a reference score file [here](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_scores.txt.gz) and specify it via `--reference-score-file`.

## Upload

Please upload all the `.png` files and `.projected.pca.tsv.gz` file. Detailed instruction can be found [here](https://docs.google.com/document/d/1Z8Vurk49RsTyX9YRhcleXKZomZwG84lj2V_YXjUi1LI/edit).
