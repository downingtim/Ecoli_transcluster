# Ecoli_transcluster

# Ecoli_transcluster

Transmission cluster analysis of *Escherichia coli* isolates using SNP distance matrices and the R package **transcluster**.

This repository contains scripts used to infer putative transmission networks within *E. coli* phylogroups using pairwise SNP distances and isolate collection dates. Analyses are performed separately for each phylogroup (A, B1, B2, C, D, and G), generating SNP-based clusters, transmission clusters, network summaries, and graphical outputs.

---

## Overview

The workflow:

1. Generate a pairwise SNP distance matrix from a VCF file.
2. Match isolates to collection dates.
3. Build a `transcluster` model.
4. Explore combinations of:
   - Mutation rate (`lambda`)
   - Transmission rate (`beta`)
5. Generate:
   - SNP distance histograms
   - SNP heatmaps
   - SNP cluster plots
   - Transmission cluster plots
   - Transmission edge tables
   - Connection-versus-threshold summaries

---

## Repository Structure

```text
.
├── scripts
│   ├── A.Rmd
│   ├── B1.Rmd
│   ├── B2.Rmd
│   ├── C.Rmd
│   ├── D.Rmd
│   ├── G.Rmd
│   └── matrix.pl
```

### R scripts

Each phylogroup is analysed independently:

| Script | Phylogroup |
|----------|----------|
| A.Rmd | A |
| B1.Rmd | B1 |
| B2.Rmd | B2 |
| C.Rmd | C |
| D.Rmd | D |
| G.Rmd | G |

The scripts are functionally equivalent, differing primarily in the value assigned to:

```r
dataset = "A"
```

which should correspond to the appropriate phylogroup-specific SNP matrix file.

---

## Requirements

### R packages

```r
devtools
transcluster
data.table
stats
clue
igraph
stringr
BiocManager
dplyr
ggplot2
```

Install the development version of transcluster:

```r
devtools::install_github(
  "JamesStimson/transcluster",
  build_vignettes = TRUE
)
```

Versions used during the original analysis:

| Package | Version |
|----------|----------|
| transcluster | 0.1.0 |
| stats | 4.1.0 |
| clue | 0.3.64 |
| igraph | 1.4.2 |
| stringr | 1.5.0 |
| ggplot2 | 3.4.2 |

### Perl

Perl is required to run:

```text
scripts/matrix.pl
```

for SNP matrix generation.

---

## Input Files

### 1. SNP Distance Matrix

Each phylogroup requires a square SNP distance matrix:

```text
A.matrix.csv
B1.matrix.csv
B2.matrix.csv
C.matrix.csv
D.matrix.csv
G.matrix.csv
```

Rows and columns must contain identical isolate names.

### 2. Isolate Metadata

```text
05312023_isolatelistfortranscluster.csv
```

Expected columns:

| Column |
|----------|
| Assembly_Name |
| Source |
| Phylogroup |
| Date_Collection |
| Farm.Name |

The scripts match isolate names against the SNP matrix and extract collection dates for use in transmission modelling.

---

## Generating SNP Distance Matrices

The script:

```bash
perl scripts/matrix.pl input
```

expects:

```text
input.vcf
```

and produces:

```text
input.matrix.csv
```

The script calculates pairwise SNP differences between all samples in the VCF and outputs a square SNP distance matrix suitable for subsequent analysis with `transcluster`.

Example:

```bash
perl scripts/matrix.pl A
```

Input:

```text
A.vcf
```

Output:

```text
A.matrix.csv
```

---

## Analysis Parameters

The workflow evaluates a range of transmission and mutation assumptions.

### Mutation rate (λ)

Representing SNP accumulation rate:

```r
lambda1 = c(
  0.68,
  0.63,
  0.58
)
```

Units:

```text
SNPs/core genome/year
```

### Transmission rate (β)

Representing serial transmission interval assumptions:

```r
beta1 = c(
  5.5,
  5.0,
  4.5
)
```

The scripts iterate through all combinations of:

```text
3 beta values × 3 lambda values
```

for each phylogroup.

---

## Clustering Strategy

### SNP Clusters

SNP thresholds:

```r
setSNPThresholds(myModel, c(3,6,9))
```

Clusters are generated using:

```r
makeSNPClusters()
```

### Transmission Clusters

Transmission thresholds:

```r
setTransThresholds(myModel, c(5,10,15))
```

Clusters are generated using:

```r
makeTransClusters()
```

Network visualisations are examined at thresholds:

```r
7
12
18
24
```

transmission events.

---

## Outputs

### SNP Distance Distribution

```text
<dataset>_SNP_hist.pdf
```

Histogram of pairwise SNP distances.

---

### SNP Heatmap

```text
<dataset>.heatmap.pdf
```

Heatmap of pairwise SNP distances.

---

### SNP Cluster Networks

```text
<dataset>_SNPclusters_<lambda>_<beta>.pdf
```

Visualisation of clustering using SNP thresholds.

---

### Transmission Networks

```text
<dataset>_Transmission_model_<lambda>_<beta>.pdf
```

Primary output showing inferred transmission relationships under different parameter combinations.

---

### Transmission Edge Lists

```text
<dataset>_transcluster_order_<lambda>_<beta>.csv
```

Contains unique inferred connections extracted from transmission networks.

Columns:

| Column | Description |
|----------|----------|
| A | Isolate 1 |
| B | Isolate 2 |
| Stage | Earliest transmission threshold at which the connection appears |

---

### Connection Summary Plots

```text
<dataset>_Connections_<beta>.pdf
```

Plots the number of inferred connections across transmission thresholds for different mutation rate assumptions.

These plots provide a simple sensitivity analysis of network structure across parameter combinations.

---

## Running an Analysis

Example for phylogroup A:

1. Generate SNP matrix:

```bash
perl scripts/matrix.pl A
```

2. Ensure metadata file is present:

```text
05312023_isolatelistfortranscluster.csv
```

3. Edit the dataset variable if required:

```r
dataset = "A"
```

4. Run the R Markdown script:

```r
source("scripts/A.Rmd")
```

or execute interactively within RStudio.

---

## Notes

- Isolate names in the metadata file are converted from underscores to periods before matching.
- Analyses are performed independently for each phylogroup.
- Transmission networks are exploratory and depend strongly on the chosen mutation and transmission parameters.
- The repository reproduces the analyses performed using `transcluster` version 0.1.0.

---

## Citation

If using this workflow, please cite:

- Genomic Analysis of E. coli Strains Circulating During Colibacillosis Outbreaks on Broiler Farms. Chinenye R Nnajide; Haley Sanderson; Sylvia Li; Murugesan Sivaranjani; Himen Salimizand; Mohamed Helmy; Tim Downing; Robert G Beiko; Joseph E Rubin; Jo-Anne Dillon; Aaron P White. 2026.
- Any associated publication describing the study and dataset analysed with this repository.
