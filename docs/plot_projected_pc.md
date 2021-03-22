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
  --pc-prefix [prefix of PC columns] \
  --pc-num [number of PCs used in GWAS] \
  --ancestry [ancestry code: AFR, AMR, EAS, EUR, MID, or SAS] \
  --out [output name prefix]
```

If your cohort contains multiple ancestries, please use `--ancestry-file` and `--ancestry-col` to specify for each individual.
```
  --ancestry-file [path to ancestry file] \
  --ancestry-col [ancestry column name]
```

If your cohort submits multiple analyses, please run the script with different `--phenotype-col`. It will automatically excludes samples without case/control status.

## Upload

Please upload all the `.png` files and `.projected.pca.tsv.gz` file. Detailed instruction can be found [here](https://docs.google.com/document/d/1Z8Vurk49RsTyX9YRhcleXKZomZwG84lj2V_YXjUi1LI/edit).
