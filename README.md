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

| Data Type         | Description                                          | Format                                         | Wiki page                                                                        |
|-------------------|------------------------------------------------------|------------------------------------------------|----------------------------------------------------------------------------------|
| Genome Annotations| Zebrafish GRCz11 gene and regulatory annotations     | `.gtf`, `.bed`, `.tsv`, `.txt`, `.fasta`       | https://github.com/parnaljoshi/gsh-zebrafish-hackathon/wiki/Annotation-Data      |
| Gene Expression   | RNA-seq profiles across developmental stages         | `.tsv`                                         | https://github.com/parnaljoshi/gsh-zebrafish-hackathon/wiki/Gene-Expression-Data |
| Hi-C Data         | Genomic compartment data across developmental stages | `.bw`                                          | https://github.com/parnaljoshi/gsh-zebrafish-hackathon/wiki/Hi%E2%80%90C-Data    |

For details about individual datasets, please refer to the [Wiki](https://github.com/parnaljoshi/gsh-zebrafish-hackathon/wiki)

---

## More about the goal and approach

The overarching goal of this project is to identify genomic safe harbor sites in the zebrafish genome that are stable and active across developmental timepoints. The current approach that we have implemented as a Dockerized workflow [below](https://github.com/parnaljoshi/gsh-zebrafish-hackathon/blob/main/README.md#option-1-using-the-provided-docker-container-recommended) uses genomic annotation features to filter and select appropriate locations where a transgene can be inserted. This method provides 19 locations across all chromosomes that could serve as potential safe harbor sites. **This list of sites can be a starting point for further filtering to include the temporal aspect.** Additional information about the Docker setup and workflow is available on [Wiki](https://github.com/parnaljoshi/gsh-zebrafish-hackathon/wiki/Docker-Setup) 

To obtain a confident list of safe harbor sites across different zebrafish developmental stages, participants are encouraged to take an **integrative multi-omics approach**. Ideas include but are not limited to:

- Using **RNA-Seq data** to find areas of the genome containing **ubiquitously expressed genes** across developmental timepoints.
- Using **Hi-C data** to locate **A compartments** or **TADs** associated with open chromatin.
- Avoiding genes and regulatory elements.

---

## Deliverables

1. **A list of predicted genomic safe harbor regions using your approach of choice:**
   - A tab-separated (or similar formatted) file with columns:
      * `Chromosome number`
      * `Start coordinates`
      * `End coordinates`
      * `Size in bp`
      * `Strand`
    
2. **A well-documented and reproducible workflow:**
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
└── install_gsh_dependencies.sh  # Software dependencies
```
---

## Getting Started

You can get started using either the **provided Docker container** or by **setting up the environment manually**. To run the provided Docker container, download the data from Box https://iastate.app.box.com/s/rw07ev9hvlcc4f63e5361jrpmq7e4fne, and make sure the following directory structure exists:

```
.                                # Working directory to run Docker from
├── AnnotationData/              # Contains all input files and receives output
    ├── Danio_rerio.GRCz11.113.gtf
    ├── danRer11-chromInfo.txt
    ├── ... (all other input files)
```

The list of safe harbors will be written to **`Output/Safe_harbors.bed`**. The directory will also contain a `.fasta` format file containing sequences of the corresponding safe harbor regions.

---

### Option 1: Using the Provided Docker Container (Recommended)

1. **Install Docker** (if you don't have it):  
   https://docs.docker.com/get-docker/

2. **Pull the Docker image**:
   ```bash
   docker pull parnaljoshi/gsh-docker-hackathon
   ```
   
3. **Run the container**:

   `docker run` needs to be executed from the same directory where `AnnotationData/` folder is placed.

   On **Linux/MacOS**:
   ```bash
   docker run --rm -v "$(pwd)/AnnotationData:/app/AnnotationData" -v "$(pwd)/Output:/app/Output" parnaljoshi/gsh-docker-hackathon
   ```

   On **PowerShell (Windows)**:
   ```powershell
   docker run --rm -v "${PWD}/AnnotationData:/app/AnnotationData" -v "${PWD}/Output:/app/Output" parnaljoshi/gsh-docker-hackathon
   ```

   On **WSL + Docker Desktop (Windows)**:
   ```powershell
   docker run --rm -v "/mnt/path/to/AnnotationData:/app/AnnotationData" -v "/mnt/path/to/Output:/app/Output" parnaljoshi/gsh-docker-hackathon
   ```
   
---

### Option 2: Manual Setup 

Requires Linux/MacOS or Windows Subsystem for Linux 

1. **Clone the repository**:
   ```bash
   git clone https://github.com/parnaljoshi/gsh-zebrafish-hackathon.git  
   cd gsh-zebrafish-hackathon
   ```

2. **Make the shell file executable**
   ```bash
   chmod +x install_gsh_dependencies.sh
   ```

3. **Install dependencies**
   ```bash
   ./install_gsh_dependencies.sh
   ```

4. **Begin your analysis** using the starter script `gsh.sh`
   Ensure that `AnnotationData` directory and `gsh.sh` script are in the same directory 
   ```bash
   cp gsh.sh ..
   cd ..
   bash gsh.sh
   ```

`Safe_harbors.bed` and `Safe_harbors.fasta` are written to `Output/` directory.
 
---

