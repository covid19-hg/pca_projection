# Prerequisites

- [PLINK 2.00 software](https://www.cog-genomics.org/plink/2.0/)
  - NB: This is **not PLINK 1.90 nor 1.07**. We need **the latest version of PLINK 2.0** for analysis.
- R packages: please see details [here](plot_projected_pc.md#required-packages).
- Pre-computed PCA loadings: see [below](#download-the-pre-computed-pca-loadings-and-reference-allele-frequencies).
- Reference allele frequencies: see [below](#download-the-pre-computed-pca-loadings-and-reference-allele-frequencies).
- Imputed genotypes in PLINK compatible format
  - Imputed dosages (`.pgen`/`.pvar`/`.psam`, `.vcf`, or `.bgen`) are preferred; but hard-called genotypes (`.bed`/`.bim`/`.fam`) are acceptable.
  - Please follow the following instructions to convert non-PLINK files (`.vcf` or `.bgen`) to PLINK binary format.
- Phenotype file
- Covariate file
  - Please use the same files that you used for GWAS.

## Download the pre-computed PCA loadings and reference allele frequencies

We provide variant IDs in three formats: 1) `chromosome:position:ref:alt` in GRCh37, 2) in GRCh38, and 3) rsid. **Please double check variant IDs of your dataset and choose appropriate one from below.**

### GRCh37

- Pre-compmuted PCA loadings: [hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh37.plink.tsv](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh37.plink.tsv)
- Reference allele frequencies: [hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh37.plink.afreq](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh37.plink.afreq)

### GRCh38

- Pre-compmuted PCA loadings: [hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh38.plink.tsv](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh38.plink.tsv)
- Reference allele frequencies: [hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh38.plink.afreq](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.GRCh38.plink.afreq)

### rsid

- Pre-compmuted PCA loadings: [hgdp_tgp_pca_covid19hgi_snps_loadings.rsid.plink.tsv](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.rsid.plink.tsv)
- Reference allele frequencies: [hgdp_tgp_pca_covid19hgi_snps_loadings.rsid.plink.afreq](https://storage.googleapis.com/covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.rsid.plink.afreq)

### For advanced users: Hail format

For advanced users, we also provide the files in Hail format here: `gs://covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.ht`.

Please refer to [our example script](../hail_project_pc.py) and [the Hail documentation](https://hail.is/) for further information.

## Prepare imputed dosages in PLINK2 format

If you have imputed dosage files split by chromosome, you need to combine them first before using it with `plink2 --score`. Please refer to [PLINK 2’s documentation](https://www.cog-genomics.org/plink/2.0/input) for more information. Depending on which file format you have, please use the following commands to 1) extract the relevant set of variants for each chromosome, and 2) merge them in PLINK 2 binary format for downstream processing.

### Make a variant list

To avoid creating too big dosage files, we first extract a variant list from the pre-computed loadings file for filtering.

```
cut -f1 [path to the pre-computed loadings file] | tail -n +2 > variants.extract
```

### PLINK 2 binary format (`.pgen`/`.pvar`/`.psam`)

#### Extraction

For each chromosome file, please run the following extraction command:

```
plink2 \
  --pfile [path to your per-chromosome pfile] \
  --extract variants.extract \
  --make-pfile \
  --out [per-chromosome output name]
```

#### Merging

First, please collect file names of the filtered per-chromosome pfiles above.

```
ls [the previous per-chromosome output prefix].*.pgen | sed -e ‘s/.pgen//’ > merge-list.txt
```

Then, use `plink2 --pmerge-list` to merge.

```
plink2 --pmerge-list merge-list.txt --out [all-chromosome output name]
```

### PLINK 1 binary format (`.bed`/`.bim`/`.fam`)

#### Extraction

For each chromosome file, please run the following extraction command:

```
plink \
  --bfile [path to your per-chromosome pfile] \
  --extract variants.extract \
  --make-bed \
  --out [per-chromosome output name]
```

#### Merging

First, please collect file names of the filtered per-chromosome pfiles above.

```
ls [outname].*.bed | sed -e ‘s/.bed//’ > merge-list.txt
```

Then, use `plink --merge-list` to merge.

```
plink --merge-list merge-list.txt --out [all-chromosome output name]
```

### BGEN format (`.bgen`/`.sample`)

For manipulating `.bgen` files, you additionally need to install [bgenix](https://enkre.net/cgi-bin/code/bgen/wiki?name=bgenix) and [cat-bgen](https://enkre.net/cgi-bin/code/bgen/wiki?name=cat-bgen).

#### Extraction

For each chromosome file, please run the following extraction command:

```
bgenix \
  -g [path to your per-chromosome bgen] \
  -incl-rsids variant.extract \
  > [per-chromosome output name].bgen
```

If your `.bgen` files have different variant IDs, please make appropriate list of `variant.extract`. You can check variant IDs via `bgenix -g [path to bgen] -list`.

#### Merging

```
cat-bgen \
-g [path to your per-chromosome bgen 1] \
   [path to your per-chromosome bgen 2] \
...
   [path to your per-chromosome bgen 22] \
-og [all-chromosome outname]
```

Note that you can also glob all 22 `.bgen` files via `[prefix].*.bgen`.

#### Import

Finally, please use the following command to import `.bgen` into PLINK 2 pfiles.

```
plink2 \
  --bgen [path to all-chromosome bgen] [REF/ALT mode: see below] \
  --make-pfile \
  --out [output pfile name]
```

For `[REF/ALT mode]`, please refer to [the PLINK 2 documentation](https://www.cog-genomics.org/plink/2.0/input#oxford). Basically, you can specify the following three options.

> - 'ref-first': The first allele for each variant is REF.
> - 'ref-last': The last allele for each variant is REF.
> - 'ref-unknown': The last allele for each variant is treated as provisional-REF.

You can see whether REF is first/alt by checking `bgenix -g [path to bgen] -list`.

### VCF format (`.vcf`)

For manipulating vcf files, you additionally need to install [bcftools](http://www.htslib.org/doc/bcftools.html).

#### Extraction

For each chromosome file, please run the following extraction command:

```
bcftools view -Oz \
  -i “ID = @variants.extract” \
  [path to your per-chromosome vcf file] \
  > [per-chromosome outname>.vcf.gz]
```

#### Merging

```
bcftools concat -Oz [per-chromosome vcf files] > [all-chromosome outname].vcf.gz
```

#### Import

Finally, please use the following command to import `.vcf` into PLINK 2 pfiles.

```
plink2 \
  --vcf [all-chromosome outname].vcf.gz \
  dosage=[dosage field name: see below] \
  --make-pfile \
  --out [outname]
```

For the dosage field name, please refer to the following instructions from [the PLINK 2 documentation](https://www.cog-genomics.org/plink/2.0/input#vcf).

> To import the GP field (a posterior probability per possible genotype, not phred scaled), add `'dosage=GP'` (or `'dosage=GP-force'`, see below). To import Minimac4-style DS+HDS phased dosage, add `'dosage=HDS'`. `'dosage=DS'` (or anything else for now) causes the named field to be interpreted as a Minimac3-style dosage.

## Prepare phenotype and covariate files

Please use the same phenotype and covariate files that you used for GWAS. We expect `FID` and `IID` exactly match to those in genotypes. If `FID` and `IID` columns are not in these files, please remake the files with these columns.
