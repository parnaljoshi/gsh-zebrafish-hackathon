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

Participants will be provided with the following datasets:

Data is available on Box: https://iastate.app.box.com/s/rw07ev9hvlcc4f63e5361jrpmq7e4fne 

| Data Type         | Description                                                        | Format                                         |
|-------------------|--------------------------------------------------------------------|------------------------------------------------|
| Genome Annotations| Zebrafish GRCz11 gene and regulatory annotations                   | `.gtf`, `.bed`, `.tsv`, `.txt`, `.fasta`       |
| Gene Expression   | RNA-seq profiles across developmental stages                       | `.tsv`                                         |
| Hi-C Data         | Genomic compartment data across developmental stages               | `.bw`                                          |

---

## Suggested Approach

Participants are encouraged to take an **integrative multi-omics approach**. Ideas include:

- Using **RNA-Seq data** to find areas of the genome containing **ubiquitously expressed genes** across developmental timepoints.
- Using **Hi-C data** to locate **A compartments** or **TADs** associated with open chromatin.
- Avoiding genes and regulatory elements.

---

## Deliverables

1. **List of predicted genomic safe harbor regions using your approach of choice:**
 - A tab-separated (or similar formatted) file with columns:
      * `Chromosome number`
      * `Start coordinates`
      * `End coordinates`
      * `Size in bp`
      * `Strand`
    
3. **Well-documented and reproducible workflow:**
  - A containerized pipeline using tools such as Docker/Singularity (preferred), or other approach of your choice
  - Instructions on how to run/execute the pipeline


---

## Repository Structure

```text
.
├── gsh.sh        # Starter script
├── Dockerfile        # Dockerfile
├── GSH_Zebrafish_Hackathon_ISMB2025.pdf          # Instructions
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
   docker pull kunalxs/gsh-docker-v5:hackathon
   ```
   
3. **Run the container**:
   ```bash
   docker run --rm -it -v ${PWD}\gshDataRepo:/app/data/gshdatarepo kunalxs/gsh-docker-v5:hackathon
   ```

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

4. **Begin your analysis** using the starter script ```gsh.sh```.

---

