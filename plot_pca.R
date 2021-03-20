library(tidyverse)
library(cowplot)

setwd('/Users/alicia/martin_lab/projects/covid19_hgi')

pca <- read.table(gzfile('hgdp_tgp_pca_covid19hgi_snps_scores.txt.bgz'), header=T) %>%
  left_join(read.delim('/Users/alicia/martin_lab/projects/hgdp_tgp/gnomad_meta_hgdp_tgp_v1.txt', header=T, sep='\t'))

plot_pca <- function(pca, first_PC, second_PC) {
  p_pca <- ggplot(pca, aes_string(x=first_PC, y=second_PC, color='hgdp_tgp_meta.Genetic.region')) +
    geom_point() +
    theme_classic() +
    scale_color_brewer(palette='Set1') +
    guides(color=guide_legend(title="Genetic region")) +
    theme(text=element_text(size=14))
  return(p_pca)
}

pc1_2 <- plot_pca(pca, 'PC1', 'PC2')
pc3_4 <- plot_pca(pca, 'PC3', 'PC4')
pc5_6 <- plot_pca(pca, 'PC5', 'PC6')
pc7_8 <- plot_pca(pca, 'PC7', 'PC8')
pc9_10 <- plot_pca(pca, 'PC9', 'PC10')

p1_10 <- plot_grid(pc1_2, pc3_4, pc5_6, pc7_8, pc9_10, labels=LETTERS[1:5], nrow=2)

save_plot('hgdp_tgp_pc1_10_covid19hgi_snps.pdf', p1_10, base_height=8, base_width=15)

