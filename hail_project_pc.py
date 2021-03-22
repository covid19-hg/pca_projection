#!/usr/bin/env python
import hail as hl
from gnomad.sample_qc.ancestry import pc_project

MT_PATH = "gs://"
PCA_LOADINGS_PATH = "gs://covid19-hg-public/pca_projection/hgdp_tgp_pca_covid19hgi_snps_loadings.ht"
SAMPLE_FIELD_NAME = "s"
OUTPATH = "gs://"


def project_individuals(pca_loadings, project_mt):
    """
    Project samples into predefined PCA space
    :param pca_loadings: existing PCA space
    :param project_mt: matrix table of data to project
    :param project_prefix: directory and filename prefix for where to put PCA projection output
    :return:
    """
    ht_projections = pc_project(project_mt, pca_loadings)
    ht_projections = ht_projections.transmute(**{f"PC{i}": ht_projections.scores[i - 1] for i in range(1, 21)})
    return ht_projections


mt = hl.read_matrix_table(MT_PATH)
pca_loadings = hl.read_table(PCA_LOADINGS_PATH)
mt = mt.filter_rows(hl.is_defined(pca_loadings[mt.locus, mt.alleles]))
ht = project_individuals(pca_loadings, mt)

# output the result in .sscore format
ht = ht.key_by()
ht = ht.select(
    **{"#FID": ht[SAMPLE_FIELD_NAME], "IID": ht[SAMPLE_FIELD_NAME]}, **{f"PC{i}": ht[f"PC{i}"] for i in range(1, 21)}
)
ht.export(OUTPATH)
