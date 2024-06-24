setwd("AAA")
data <- read.table("Frantz.cntTable",header=T,row.names=1)
data <- data[,c(5:7,21:24)]
groups <- factor(c(rep("TGroup",3),rep("CGroup",4)))
min_read <- 1
data <- data[apply(data,1,function(x){max(x)}) > min_read,]
sampleInfo <- data.frame(groups,row.names=colnames(data))
suppressPackageStartupMessages(library(DESeq2))
dds <- DESeqDataSetFromMatrix(countData = data, colData = sampleInfo, design = ~ groups)
dds$groups = relevel(dds$groups,ref="CGroup")
dds <- DESeq(dds)
res <- results(dds,independentFiltering=F)
write.table(res, file="E73_Frantz_gene_TE_analysis.txt", sep="\t",quote=F)
resSig <- res[(!is.na(res$padj) & (res$padj < 0.050000) &         (abs(res$log2FoldChange)> 0.000000)), ]
write.table(resSig, file="E73_Frantz_sigdiff_gene_TE.txt",sep="\t", quote=F)
