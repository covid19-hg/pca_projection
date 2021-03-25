# Project PC

**Note: If you download `project_pc.sh` before March 25, please rerun the code. The update one specifies "variance-standardize" instead of "center".**

## Set cohort-specific variables
Before running please edit `project_pc.sh` with your cohort-specific parameters. Specifically:
* `STUDY_NAME`: Name of your study
* `ANALYST_NAME`: Analyst name
* `PCA_LOADINGS`: Path to the pre-computed PCA loadings downloaded from [here](prerequisites.md#download-the-pre-computed-pca-loadings-and-reference-allele-frequencies).
* `PCA_AF`: Path to the reference allele frequencies downloaded from [here](prerequisites.md#download-the-pre-computed-pca-loadings-and-reference-allele-frequencies).

You need to prepare imputed dosage files in PLINK binary format. Please refer to [prerequisites.md](prerequisites.md) for more instructions. You need either:
* `PFILE`: [Recommended] PLINK 2 binary format
* `BFILE`: [Acceptable] PLINK 1 binary format

## Run the script
After setting the variables, please run the script.
```
bash project_pc.sh
```

Internally, it calls `plink2 --score` with the following options.
```
plink2 \
  ${input_command} \
  --score ${PCA_LOADINGS} \
  variance-standardize \
  cols=-scoreavgs,+scoresums \
  list-variants \
  header-read \
  --score-col-nums 3-22 \
  --read-freq ${PCA_AF} \
  --out ${OUTNAME}
```
