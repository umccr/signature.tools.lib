% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signatureFit_pipeline.R
\name{signatureFit_pipeline}
\alias{signatureFit_pipeline}
\title{Signature fit pipeline}
\usage{
signatureFit_pipeline(
  catalogues = NULL,
  genome.v = "hg19",
  organ = NULL,
  SNV_vcf_files = NULL,
  SNV_tab_files = NULL,
  DNV_vcf_files = NULL,
  DNV_tab_files = NULL,
  SV_bedpe_files = NULL,
  signatures = NULL,
  rare_signatures = NULL,
  signature_version = "RefSigv2",
  signature_names = NULL,
  fit_method = "FitMS",
  optimisation_method = "KLD",
  useBootstrap = FALSE,
  nboot = 200,
  exposureFilterType = "fixedThreshold",
  threshold_percent = 5,
  giniThresholdScaling = 10,
  multiStepMode = "errorReduction",
  threshold_p.value = 0.05,
  rareSignatureTier = "T2",
  residualNegativeProp = 0.003,
  minResidualMutations = NULL,
  minCosSimRareSig = 0.8,
  minErrorReductionPerc = 15,
  minCosSimIncrease = 0.02,
  maxRareSigsPerSample = 1,
  noFit = FALSE,
  nparallel = 1,
  randomSeed = NULL,
  verbose = FALSE
)
}
\arguments{
\item{catalogues}{catalogues matrix, samples as columns, channels as rows. The mutation type of the catalogue will be inferred automatically by checking the rownames.}

\item{genome.v}{either "hg38" (will load BSgenome.Hsapiens.UCSC.hg38), "hg19" (will load BSgenome.Hsapiens.1000genomes.hs37d5), mm10 (will load BSgenome.Mmusculus.UCSC.mm10::BSgenome.Mmusculus.UCSC.mm10) or canFam3 (will load BSgenome.Cfamiliaris.UCSC.canFam3::BSgenome.Cfamiliaris.UCSC.canFam3)}

\item{organ}{If signatures is not specified, then use this paramenter to provide an organ name to automatically select appropriate signatures. Organ names and signature selection depends on the signature_version provided. When using RefSigv1 or RefSigv2 as signature_version organ-specific signatures will be used. Use one of the following organs: "Biliary", "Bladder", "Bone_SoftTissue", "Breast", "Cervix" (v1 only), "CNS", "Colorectal", "Esophagus", "Head_neck", "Kidney", "Liver", "Lung", "Lymphoid", "NET" (v2 only), "Oral_Oropharyngeal" (v2 only), "Ovary", "Pancreas", "Prostate", "Skin", "Stomach", "Uterus". If COSMICv2 or COSMICv3.2 are used, signatures are selected if the were found in the given organ/dataset. The mutation type is automatically inferred from the catalogue.}

\item{SNV_vcf_files}{list of file names corresponding to SNV VCF files to be used to construct 96-channel substitution catalogues. This should be a named vector, where the names indicate the sample name.}

\item{SNV_tab_files}{list of file names corresponding to SNV TAB files to be used to construct 96-channel substitution catalogues. This should be a named vector, where the names indicate the sample name. The files should contain a header in the first line with the following columns: chr, position, REF, ALT.}

\item{DNV_vcf_files}{list of file names corresponding to SNV/DNV VCF files to be used to construct 96-channel substitution catalogues. Adjacent SNVs will be combined into DNVs. This should be a named vector, where the names indicate the sample name.}

\item{DNV_tab_files}{list of file names corresponding to SNV/DNV TAB files to be used to construct 96-channel substitution catalogues. Adjacent SNVs will be combined into DNVs. This should be a named vector, where the names indicate the sample name. The files should contain a header in the first line with the following columns: chr, position, REF, ALT.}

\item{SV_bedpe_files}{list of file names corresponding to SV (Rearrangements) BEDPE files to be used to construct 32-channel rearrangement catalogues. This should be a named vector, where the names indicate the sample name. The files should contain a rearrangement for each row (two breakpoint positions should be on one row as determined by a pair of mates of paired-end sequencing) and should already be filtered according to the user preference, as all rearrangements in the file will be used and no filter will be applied. The files should contain a header in the first line with the following columns: "chrom1", "start1", "end1", "chrom2", "start2", "end2" and "sample" (sample name). In addition, either two columns indicating the strands of the mates, "strand1" (+ or -) and "strand2" (+ or -), or one column indicating the structural variant class, "svclass": translocation, inversion, deletion, tandem-duplication. The column "svclass" should correspond to (Sanger BRASS convention): inversion (strands +/- or -/+ and mates on the same chromosome), deletion (strands +/+ and mates on the same chromosome), tandem-duplication (strands -/- and mates on the same chromosome), translocation (mates are on different chromosomes).}

\item{signatures}{signatures should be a matrix or dataframe, signatures as columns, channels as rows. The mutation type of the signatures will be inferred automatically by checking the rownames. Use this parameter only if you want to use your own signatures. Leave NULL if you want to use the signatures provided by the package, for example by specifying a specific organ or signature_version.}

\item{rare_signatures}{used only when fit_method=FitMS, and the signature parameter is also given. The parameter rare_signatures should be a matrix or dataframe, signatures as columns, channels as rows. The mutation type of the signatures will be inferred automatically by checking the rownames.}

\item{signature_version}{either "COSMICv2", "COSMICv3.2", "RefSigv1" or "RefSigv2". If not specified, "RefSigv2 will be used. The mutation type is automatically inferred from the catalogue.}

\item{signature_names}{if no signatures have been provided using the signatures and rare_signatures parameters, and if no organ is specified, then signature_names can be used to specify a list of signature names, which should match the corresponding mutation type (inferred automatically) and reference signatures requested using the signature_version parameter.}

\item{fit_method}{either Fit or FitMS. Notice that automatic selection of signatures in FitMS is currrently available only for SNV mutations or catalogues, signature_version=RefSigv2 and specifying an organ. Alternatively, FitMS can be used by specifying both signatures (which will be considered common signatures) and rare_signatures parameters.}

\item{optimisation_method}{KLD or NNLS}

\item{useBootstrap}{set to TRUE to use bootstrap}

\item{nboot}{number of bootstraps to use, more bootstraps more accurate results}

\item{exposureFilterType}{use either fixedThreshold or giniScaledThreshold. When using fixedThreshold, exposures will be removed based on a fixed percentage with respect to the total number of mutations (threshold_percent will be used). When using giniScaledThreshold each signature will used a different threshold calculated as (1-Gini(signature))*giniThresholdScaling}

\item{threshold_percent}{threshold in percentage of total mutations in a sample, only exposures larger than threshold are considered}

\item{giniThresholdScaling}{scaling factor for the threshold type giniScaledThreshold, which is based on the Gini score of a signature}

\item{multiStepMode}{use one of the following: "constrainedFit", "partialNMF", "errorReduction", or "cossimIncrease".}

\item{threshold_p.value}{p-value to determine whether an exposure is above the threshold_percent. In other words, this is the empirical probability that the exposure is lower than the threshold}

\item{rareSignatureTier}{either T1 or T2. For each organ we provide two lists of rare signatures that can be used. Tier 1 (T1) are rare signatures
that were observed in the requested organ. The problem with T1 is that it may be that a signature is not observed simply because there were not enough samples for a certain organ in the particular
dataset that was used to extract the signatures. So in general we advise to use Tier 2 (T2) signatures, which extend the rare signature to a wider number of rare signatures.}

\item{residualNegativeProp}{maximum proportion of mutations (w.r.t. total mutations in a sample) that can be in the negative part of a residual when using the constrained least squares fit
when using multiStepMode=constrainedFit}

\item{minResidualMutations}{minimum number of mutations in a residual when using constrainedFit or partialNMF. Deactivated by default.}

\item{minCosSimRareSig}{minimum cosine similarity between a residual and a rare signature for considering the rare signature as a candidate for a sample when using constrainedFit or partialNMF}

\item{minErrorReductionPerc}{minimum percentage of error reduction for a signature to be considered as candidate when using the errorReduction method. The error is computed as mean absolute deviation}

\item{minCosSimIncrease}{minimum cosine similarity increase for a signature to be considered as candidate when using the cossimIncrease method}

\item{maxRareSigsPerSample}{masimum number of rare signatures that should be serched in each sample. In most situations, leaving this at 1 should be enough.}

\item{noFit}{if TRUE, terminate the pipeline early without running signature Fit. This is useful if one only wants to generate catalogues from mutation lists.}

\item{nparallel}{to use parallel specify >1}

\item{randomSeed}{set an integer random seed}

\item{verbose}{use FALSE to suppress messages}
}
\value{
returns the fit object with activities/exposures of the signatures in the given sample and other information
}
\description{
This function is the main interface for computing signature fit using the signature.tools.lib R package.
}
\details{
The pipeline will produce some feedback in the form or info, warning, and error messages.
Please check the output to see whether everything worked as planned.
}
\examples{
res <- signatureFit_pipeline(catalogues,"Breast")
plotFitResults(res$fitResults,"results/")
}
\keyword{fit}
\keyword{mutational}
\keyword{signatures}
