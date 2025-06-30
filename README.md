# Zebrafish Genomic Safe Harbor Sites Identification Hackathon

Welcome to the **Zebrafish Genomic Safe Harbor Sites Identification Hackathon**!  
This challenge invites participants to identify potential **genomic safe harbor (GSH) sites** in the **zebrafish genome** using an **integrative omics approach**.

---
## Background

Identifying genomic safe harbor (GSH) sites in the zebrafish genome enables precise and stable transgene integration without disrupting endogenous gene function or regulation. Zebrafish is a widely used model organism in genetics, developmental biology, and disease modeling, and finding reliable GSH sites facilitates consistent gene expression for functional studies, therapeutic gene delivery, and synthetic biology applications. Establishing these sites enhances experimental reproducibility and reduces the risk of insertional mutagenesis, advancing both basic research and translational efforts using zebrafish as a platform.


---

## Goal

Identify candidate **genomic safe harbor (GSH)** sites in the zebrafish genome that meet the following criteria:

- **Safe**: Insertion does not disrupt essential genes or regulatory elements.
- **Stable**: Integration site allows for consistent transgene expression across time.
- **Accessible**: Site is located in transcriptionally active and/or open chromatin regions.

---

## Data

Participants will be provided with the following datasets in the `data/` directory:

| Data Type         | Description                                                        | Format               |
|-------------------|--------------------------------------------------------------------|----------------------|
| Gene Expression   | RNA-seq profiles across developmental stages           | `.tsv`       |
| Hi-C Data         | Genomic compartment data across developmental stages               | `.bw` |
| Genome Annotations| Zebrafish GRCz11 gene and regulatory annotations                  | `.gtf`, `.bed`       |

---

## Suggested Approach

Participants are encouraged to take an **integrative multi-omics approach**. Ideas include:

- Using **RNA-Seq data** to find areas of the genome containing **ubiquitously expressed genes** across developmental timepoints.
- Using **Hi-C data** to locate **A compartments** or **TADs** associated with open chromatin.
- Avoiding genes and regulatory elements.

---

## Repository Structure

```text
.
├── data/             # Input data: expression, Hi-C, annotations
├── notebooks/        # Jupyter or R notebooks
├── scripts/          # Python/R scripts for analysis
├── results/          # Output files, figures, candidate GSHs
├── README.md         # This readme file
└── requirements.txt  # Software dependencies
```

## Getting Started

You can get started using either the **provided Docker container** or by setting up the environment manually.

---

### Option 1: Using the Provided Docker Container (Recommended)

1. **Install Docker** (if you don't have it):  
   https://docs.docker.com/get-docker/

2. **Pull the Docker image**:
   ```bash
   docker pull parnaljoshi/gsh-zebrafish-hackathon:latest
   ```
   
3. **Run the container**:
   ```bash
   docker run -it --rm -v $(pwd):/workspace -p 8888:8888 parnaljoshi/gsh-zebrafish-hackathon
   ```

4. **Access Jupyter Notebook**:  
   Open your browser and go to: http://localhost:8888

---

### Option 2: Manual Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/parnaljoshi/gsh-zebrafish-hackathon.git  
   cd gsh-zebrafish-hackathon
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Begin your analysis** using notebooks or scripts provided.

---

