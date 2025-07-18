#!/bin/bash

#=======================================================================
# Created By: Iddo Friedberg Lab at Iowa State University
#=======================================================================


#=======================================================================
#							 Arguments
#=======================================================================

# THE DEFAULTS INITIALIZATION
# ./gsh.sh -genes true -oncogenes true -micrornas true -trnas true -lncrnas true -enhancers true -centromeres true -gaps true -dist_from_genes 50000 -dist_from_oncogenes 300000 -dist_from_micrornas 300000 -dist_from_trnas 150000 -dist_from_lncrnas 150000 -dist_from_enhancers 20000 -dist_from_centromeres 300000 -dist_from_gaps 300000

genes=true
oncogenes=true
micrornas=true
trnas=true
lncrnas=true
enhancers=true
centromeres=true
gaps=true
dist_from_genes=50000
dist_from_oncogenes=300000
dist_from_micrornas=300000
dist_from_trnas=150000
dist_from_lncrnas=150000
dist_from_enhancers=20000
dist_from_centromeres=300000
dist_from_gaps=300000

print_help()
{
	printf '%s\n' "Argbash is an argument parser generator for Bash."
	printf 'Usage: %s [-dist_from_genes] [-dist_from_oncogenes [-dist_from_micrornas] [-dist_from_micrornas] [-dist_from_trnas] [-dist_from_lncrnas] [-dist_from_enhancers] [-dist_from_centromeres] [-dist_from_gaps] [-h|--help]'
	printf '\t%s\n' "-genes: Whether to exclude regions with and around genes (default=true)"
	printf '\t%s\n' "-oncogenes: Whether to exclude regions with and around oncogenes (default=true)"
	printf '\t%s\n' "-micrornas: Whether to exclude regions with and around microRNAs (default=true)"
	printf '\t%s\n' "-trnas: Whether to exclude regions with and around tRNAs (default=true)"
	printf '\t%s\n' "-lncrnas: Whether to exclude regions with and around lncRNAs (default=true)"
	printf '\t%s\n' "-enhancers: Whether to exclude regions with and around enhancers (default=true)"
	printf '\t%s\n' "-centromeres: Whether to exclude regions with and around centromeres (default=true)"
	printf '\t%s\n' "-gaps: Whether to exclude regions with and around gaps (default=true)"
	printf '\t%s\n' "-dist_from_genes: Minimal distance from any safe harbor to any gene in bp (default=50000)"
	printf '\t%s\n' "-dist_from_oncogenes: Minimal distance from any safe harbor to any oncogene in bp (default=300000)"
	printf '\t%s\n' "-dist_from_micrornas: Minimal distance from any safe harbor to any microRNA in bp (default=300000)"
	printf '\t%s\n' "-dist_from_trnas: Minimal distance from any safe harbor to any tRNA in bp (default=150000)"
	printf '\t%s\n' "-dist_from_lncrnas: Minimal distance from any safe harbor to any long-non-coding RNA in bp (default=150000)"
	printf '\t%s\n' "-dist_from_enhancers: Minimal distance from any safe harbor to any enhancer in bp (default=20000)"
	printf '\t%s\n' "-dist_from_centromeres: Minimal distance from any safe harbor to any centromere in bp (default=300000)"
	printf '\t%s\n' "-dist_from_gaps: Minimal distance from any safe harbor to any gaps in bp (default=300000)"
	printf '\t%s\n' "-h, --help: Prints help"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    print_help
    exit 0
    ;;
    -genes)
    genes="$2"
    shift # past argument
    shift # past value
    ;;
    -oncogenes)
    oncogenes="$2"
    shift # past argument
    shift # past value
    ;;
    -micrornas)
    micrornas="$2"
    shift # past argument
    shift # past value
    ;;
    -trnas)
    trnas="$2"
    shift # past argument
    shift # past value
    ;;
    -lncrnas)
    lncrnas="$2"
    shift # past argument
    shift # past value
    ;;
    -ncrnas)
    ncrnas="$2"
    shift # past argument
    shift # past value
    ;;
    -smrnas)
    smrnas="$2"
    shift # past argument
    shift # past value
    ;;
    -enhancers)
    enhancers="$2"
    shift # past argument
    shift # past value
    ;;
    -centromeres)
    centromeres="$2"
    shift # past argument
    shift # past value
    ;;
    -gaps)
    gaps="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_genes)
    dist_from_genes="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_oncogenes)
    dist_from_oncogenes="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_micrornas)
    dist_from_micrornas="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_trnas)
    dist_from_trnas="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_lncrnas)
    dist_from_lncrnas="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_enhancers)
    dist_from_enhancers="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_centromeres)
    dist_from_centromeres="$2"
    shift # past argument
    shift # past value
    ;;
    -dist_from_gaps)
    dist_from_gaps="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

apt-get update && apt-get install -y less

set -- "${POSITIONAL[@]}" # restore positional parameters

#=======================================================================

DIRECTORY=tmpGsh
if [ -d "$DIRECTORY" ]; then
  rm -r $DIRECTORY
fi

mkdir tmpGsh	# Creatingg a temporary folder for intermediate files

#=======================================================================
#						     Genes
#=======================================================================

if [ "$genes" = true ] ; then
	echo "▶ Distance from genes = ${dist_from_genes} bp"

	mkdir -p tmpGsh/genes
	dir=tmpGsh/genes

	echo "1. Extracting gene entries from GTF..."
    grep -P '\tgene\t' /app/data/annotationdata/Danio_rerio.GRCz11.113.gtf > ${dir}/gencode_gene_anotation.gtf
	wc -l ${dir}/gencode_gene_anotation.gtf

	echo "2. Adding dummy transcript_id if missing..."
	awk '{ if ($0 ~ "transcript_id") print $0; else print $0" transcript_id \"\";"; }' \
		${dir}/gencode_gene_anotation.gtf > ${dir}/gencode_v24_annotation_genes_transcript_id.gtf
	wc -l ${dir}/gencode_v24_annotation_genes_transcript_id.gtf

	echo "3 .Converting GTF to BED (gene coordinates only)..."
	gtf2bed --max-mem 3G < ${dir}/gencode_v24_annotation_genes_transcript_id.gtf | \
		awk -v OFS="\t" '{print $1, $2, $3}' > ${dir}/gencode_v24_annotation_genes_raw.bed
	wc -l ${dir}/gencode_v24_annotation_genes_raw.bed

    echo "4. Filtering BED to include only valid chromosomes (starting with chr, excluding chrM)..."

    awk 'BEGIN { OFS="\t" }
    {
        if ($1 ~ /^[0-9XY]+$/) {
            $1 = "chr" $1;
            print
        }
    }' ${dir}/gencode_v24_annotation_genes_raw.bed > ${dir}/gencode_v24_annotation_genes.bed

    wc -l ${dir}/gencode_v24_annotation_genes.bed

	echo "5. Adding ${dist_from_genes} bp flanks to gene coordinates..."
	bedtools slop -b ${dist_from_genes} \
		-i ${dir}/gencode_v24_annotation_genes.bed \
		-g /app/data/annotationdata/danRer11-chromInfo.txt \
		> ${dir}/gencode_v24_annotation_genes_with_flanks.bed
	wc -l ${dir}/gencode_v24_annotation_genes_with_flanks.bed

	echo "6. Sorting gene + flank regions..."
	sortBed -i ${dir}/gencode_v24_annotation_genes_with_flanks.bed \
		> ${dir}/gencode_v24_annotation_genes_with_flanks_sorted.bed
	wc -l ${dir}/gencode_v24_annotation_genes_with_flanks_sorted.bed

	echo "7. Merging overlapping flanked regions..."
	bedtools merge -i ${dir}/gencode_v24_annotation_genes_with_flanks_sorted.bed \
		> ${dir}/gencode_v24_annotation_genes_with_flanks_merged.bed
	wc -l ${dir}/gencode_v24_annotation_genes_with_flanks_merged.bed

	echo "✅ All processing steps completed."
fi

#=======================================================================
#							 Oncogenes 3.00
#=======================================================================

if [ "$oncogenes" = true ] ; then
	echo "Distance from oncogenes = ${dist_from_oncogenes} bp"

	# Create output directory
	echo "Creating directory: tmpGsh/oncogenes"
	mkdir -p tmpGsh/oncogenes
	dir=tmpGsh/oncogenes

	# Step 1: Extract GTF entries for oncogenes
	echo "Extracting GTF entries for oncogenes..."
	grep -w -f /app/data/annotationdata/danRer11-oncogenes_list.txt tmpGsh/genes/gencode_v24_annotation_genes_transcript_id.gtf \
		> ${dir}/gencode_oncogenes_annotation_transcript_id.gtf
	echo "GTF lines extracted: $(wc -l < ${dir}/gencode_oncogenes_annotation_transcript_id.gtf)"

	# Step 2: Convert GTF to BED, add 'chr' prefix
	echo "Converting GTF to BED format and adding 'chr' prefix..."
	gtf2bed --max-mem 3G < ${dir}/gencode_oncogenes_annotation_transcript_id.gtf \
	| awk -v OFS="\t" '{print "chr"$1, $2, $3}' \
	| tee ${dir}/gencode_v24_annotation_oncogenes_raw.bed \
	> ${dir}/gencode_v24_annotation_oncogenes.bed
	echo "Valid 'chr' BED entries: $(wc -l < ${dir}/gencode_v24_annotation_oncogenes.bed)"

	# Step 3: Save any non-'chr' entries (should be none now)
	echo "Saving non-'chr' BED entries for review..."
	grep -v "^chr" ${dir}/gencode_v24_annotation_oncogenes_raw.bed > ${dir}/excluded_non_chr.bed
	echo "Non-'chr' BED entries: $(wc -l < ${dir}/excluded_non_chr.bed)"

	# Step 4: Filter BED entries to match only known chromosomes in chromInfo
	echo "Filtering BED entries to only include chromosomes listed in danRer11-chromInfo.txt..."
	cut -f1 /app/data/annotationdata/danRer11-chromInfo.txt | sort | uniq > ${dir}/valid_chroms.txt

	awk 'NR==FNR {valid[$1]; next} $1 in valid' ${dir}/valid_chroms.txt ${dir}/gencode_v24_annotation_oncogenes.bed \
	> ${dir}/gencode_v24_annotation_oncogenes_filtered.bed
	echo "Filtered BED entries (valid chroms only): $(wc -l < ${dir}/gencode_v24_annotation_oncogenes_filtered.bed)"

	# Step 5: Add flanking regions to each oncogene
	echo "Adding flanks of ${dist_from_oncogenes} bp to each oncogene region..."
	bedtools slop -b ${dist_from_oncogenes} -i ${dir}/gencode_v24_annotation_oncogenes_filtered.bed -g /app/data/annotationdata/danRer11-chromInfo.txt \
		> ${dir}/gencode_v24_annotation_oncogenes_with_flanks.bed
	echo "Oncogene regions with flanks: $(wc -l < ${dir}/gencode_v24_annotation_oncogenes_with_flanks.bed)"

	# Step 6: Sort the flanked regions
	echo "Sorting the flanked regions..."
	sortBed -i ${dir}/gencode_v24_annotation_oncogenes_with_flanks.bed \
		> ${dir}/gencode_v24_annotation_oncogenes_with_flanks_sorted.bed
	echo "Sorted flanked regions: $(wc -l < ${dir}/gencode_v24_annotation_oncogenes_with_flanks_sorted.bed)"

	# Step 7: Merge overlapping flanked regions
	echo "Merging overlapping flanked regions..."
	bedtools merge -i ${dir}/gencode_v24_annotation_oncogenes_with_flanks_sorted.bed \
		> ${dir}/gencode_v24_annotation_oncogenes_with_flanks_merged.bed
	echo "Merged flanked regions: $(wc -l < ${dir}/gencode_v24_annotation_oncogenes_with_flanks_merged.bed)"

	echo "✅ Oncogenes processing completed successfully."
fi

#=======================================================================
#						   MicroRNAs
#=======================================================================

if [ "$micrornas" = true ] ; then
	echo "Distance from microRNAs = ${dist_from_micrornas}" bp
	mkdir tmpGsh/micrornas
	dir=tmpGsh/micrornas
	
	# get genomic regions of length ${dist_from_micrornas} base pairs flanking microRNAs from both sides
	bedtools slop -b ${dist_from_micrornas} -i /app/data/annotationdata/danRer11-miRNAs.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/Micrornas_with_flanks.bed

	# merge regions containing microRNAs and their flanking regions
	sortBed -i ${dir}/Micrornas_with_flanks.bed >> ${dir}/Micrornas_with_flanks_sorted.bed

	bedtools merge -i ${dir}/Micrornas_with_flanks_sorted.bed >> ${dir}/Micrornas_with_flanks_merged.bed
	
fi

#=======================================================================
#					     Long-non-coding RNAs
#=======================================================================

if [ "$lncrnas" = true ] ; then
	echo "Distance from lncRNAs = ${dist_from_lncrnas}" bp

	mkdir tmpGsh/lncrnas
	dir=tmpGsh/lncrnas

	# get lncRNA annotation from GENCODE
	awk '{ if ($0 ~ "transcript_id") print $0; else print $0" transcript_id \"\";"; }' /app/data/annotationdata/danRer11-lncRNA.gtf >> ${dir}/gencode_v24_long_noncoding_RNAs_transcript_id.gtf

	gtf2bed < ${dir}/gencode_v24_long_noncoding_RNAs_transcript_id.gtf | awk -v OFS="\t" '{print $1, $2, $3}' >> ${dir}/gencode_v24_long_noncoding_RNAs.bed

	# get genomic regions of length ${dist_from_lncrnas} base pairs flanking lncRNAs from both sides
	bedtools slop -b ${dist_from_lncrnas} -i ${dir}/gencode_v24_long_noncoding_RNAs.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/gencode_v24_long_noncoding_RNAs_with_flanks.bed

	# merge regions containing lncRNAs and their flanking regions
	sortBed -i ${dir}/gencode_v24_long_noncoding_RNAs_with_flanks.bed >> ${dir}/gencode_v24_long_noncoding_RNAs_with_flanks_sorted.bed

	bedtools merge -i ${dir}/gencode_v24_long_noncoding_RNAs_with_flanks_sorted.bed >> ${dir}/gencode_v24_long_noncoding_RNAs_with_flanks_merged.bed
fi

#=======================================================================
#						     tRNAs
#=======================================================================

if [ "$trnas" = true ] ; then
	echo "Distance from tRNAs = ${dist_from_trnas}" bp

	mkdir tmpGsh/trnas
	dir=tmpGsh/trnas

	# get tRNA annotation from GENCODE
	gtf2bed < /app/data/annotationdata/danRer11-tRNAs.gtf | awk -v OFS="\t" '{print $1, $2, $3}' >> ${dir}/gencode_v24_tRNAs.bed

	# get genomic regions of length ${dist_from_trnas} base pairs flanking tRNAs from both sides
	bedtools slop -b ${dist_from_trnas} -i ${dir}/gencode_v24_tRNAs.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/gencode_v24_tRNAs_with_flanks.bed

	# merge regions containing tRNAs and their flanking regions
	sortBed -i ${dir}/gencode_v24_tRNAs_with_flanks.bed >> ${dir}/gencode_v24_tRNAs_with_flanks_sorted.bed

	bedtools merge -i ${dir}/gencode_v24_tRNAs_with_flanks_sorted.bed >> ${dir}/gencode_v24_tRNAs_with_flanks_merged.bed
	
fi

#=======================================================================
#							 Enhancers
#=======================================================================

if [ "$enhancers" = true ] ; then
	echo "Distance from enhancers = ${dist_from_enhancers}" bp

	mkdir tmpGsh/enhancers
	dir=tmpGsh/enhancers
	
	# get genomic regions of length ${dist_from_enhancers} base pairs flanking enhancers from both sides
	bedtools slop -b ${dist_from_enhancers} -i /app/data/annotationdata/danRer11-enhancers.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/All_human_enhancers_with_flanks.bed

	# merge regions containing enhancers and their flanking regions
	sortBed -i ${dir}/All_human_enhancers_with_flanks.bed >> ${dir}/All_human_enhancers_with_flanks_sorted.bed

	bedtools merge -i ${dir}/All_human_enhancers_with_flanks_sorted.bed >> ${dir}/All_human_enhancers_with_flank_merged.bed

fi

#=======================================================================
#    						Centromeres
#=======================================================================

if [ "$centromeres" = true ] ; then
	echo "Distance from centromeres = ${dist_from_centromeres}" bp

	mkdir tmpGsh/centromeres
	dir=tmpGsh/centromeres

	# get genomic coordinates of centromeres in the BED format
	less /app/data/annotationdata/danRer11-centromeres.tsv | tail -n +3 >> ${dir}/hgTables_centromeric_regions_38.bed
	less ${dir}/hgTables_centromeric_regions_38.bed | awk -v OFS="\t" '{print $1, $2, $3}' >> ${dir}/Centromeres.bed 

	# get genomic regions of length ${dist_from_centromeres} base pairs flanking centromeres from both sides
	bedtools slop -b ${dist_from_centromeres} -i ${dir}/Centromeres.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/Centromeres_with_flanks.bed

	# merge regions containing centromeres and their flanking regions
	sortBed -i ${dir}/Centromeres_with_flanks.bed >> ${dir}/Centromeres_with_flanks_sorted.bed

	bedtools merge -i ${dir}/Centromeres_with_flanks_sorted.bed >> ${dir}/Centromeres_with_flanks_merged.bed
fi

#=======================================================================
#   	Gaps: telomeres and other regions that cannot be sequenced
#=======================================================================

if [ "$gaps" = true ] ; then
	echo "Distance from gaps = ${dist_from_gaps}" bp

	mkdir tmpGsh/gaps
	dir=tmpGsh/gaps

	# get genomic coordinates of gaps in the BED format
	less /app/data/annotationdata/danRer11-gap.txt | tail -n +2 | cut -f 2,3,4 >> ${dir}/hgTables_gaps.bed

	# get genomic regions of length ${dist_from_centromeres} base pairs flanking gaps from both sides
	bedtools slop -b ${dist_from_gaps} -i ${dir}/hgTables_gaps.bed -g /app/data/annotationdata/danRer11-chromInfo.txt >> ${dir}/Gaps_with_flanks.bed

	# merge regions containing gaps and their flanking regions
	sortBed -i ${dir}/Gaps_with_flanks.bed >> ${dir}/Gaps_with_flanks_sorted.bed

	bedtools merge -i ${dir}/Gaps_with_flanks_sorted.bed >> ${dir}/Gaps_with_flanks_merged.bed
fi

#=======================================================================
#		 		  Union of all genomic regions to avoid
#=======================================================================

echo "Merging all genomic regions to avoid"

mkdir tmpGsh/merge
dir=tmpGsh/merge

# intersect of regions to avoid together
if [ "$genes" = true ] ; then
	cat tmpGsh/genes/gencode_v24_annotation_genes_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$genes" = true ] ; then
	cat tmpGsh/oncogenes/gencode_v24_annotation_oncogenes_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$micrornas" = true ] ; then
	cat tmpGsh/micrornas/Micrornas_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$trnas" = true ] ; then
	cat tmpGsh/trnas/gencode_v24_tRNAs_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$lncrnas" = true ] ; then
	cat tmpGsh/lncrnas/gencode_v24_long_noncoding_RNAs_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$enhancers" = true ] ; then
	cat tmpGsh/enhancers/All_human_enhancers_with_flank_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$centromeres" = true ] ; then
	cat tmpGsh/centromeres/Centromeres_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

if [ "$gaps" = true ] ; then
	cat tmpGsh/gaps/Gaps_with_flanks_merged.bed >> ${dir}/Regions_to_avoid.bed
fi

sortBed -i ${dir}/Regions_to_avoid.bed >> ${dir}/Regions_to_avoid_sorted.bed

bedtools merge -i ${dir}/Regions_to_avoid_sorted.bed >> ${dir}/Regions_to_avoid_merged.bed

#=======================================================================
#							Safe harbors
#=======================================================================

echo "Obtaining genomic coordinates and sequences of safe harbors"

mkdir tmpGsh/safe_harbors
dir=tmpGsh/safe_harbors

# substract all regions to avoid from the whole genome
bedtools subtract -a /app/data/annotationdata/danRer11-chrom_coordinates.bed -b tmpGsh/merge/Regions_to_avoid_merged.bed >> ${dir}/Safe_harbors_with_alt.bed

# exclude pseudo-chromosomes and alterative loci
grep -v '_' ${dir}/Safe_harbors_with_alt.bed >> ${dir}/Safe_harbors.bed

FILE=Safe_harbors.bed
if [[ -f "$FILE" ]]; then
    rm $FILE
fi

sortBed -i ${dir}/Safe_harbors.bed >> Safe_harbors.bed

FILE=Safe_harbors.fasta
if [[ -f "$FILE" ]]; then
    rm $FILE
fi

# get sequences of those regions
bedtools getfasta -fi /app/data/annotationdata/Danio_rerio.GRCz11.dna.primary_assembly.fa -bed Safe_harbors.bed >> Safe_harbors.fasta

echo "----- Safe Harbor bed file created with a list of GSH -----"
wc -l Safe_harbors.bed

echo "Files modified ...."
ls -l

# Copy output files/folders to mounted volume path for host access
echo "Copying output files and folders to the mounted volume..."

# mkdir /app/data/annotationdata/output/

echo "Preparing clean output directory..."

# Remove if already exists
if [ -d /app/data/annotationdata/output ]; then
    rm -rf /app/data/annotationdata/output
fi

# Recreate clean output folder
mkdir -p /app/data/annotationdata/output

# Copy the tmpGsh folder
cp -r tmpGsh /app/data/annotationdata/output/tmpGsh

# Copy Safe_harbors output files
cp Safe_harbors.bed /app/data/annotationdata/output/
cp Safe_harbors.fasta /app/data/annotationdata/output/

echo "Copy finished."
echo "Outputs are saved inside the mounted volume /AnnotationData/output/"
echo "Good Luck with the Hackathon...! "


# docker tag local-image:tagname new-repo:tagname
# docker push new-repo:tagname
