#!/bin/bash

cd
git clone https://github.com/ctb/2017-ucdavis-igg201b.git

sudo Rscript --no-save ~/2017-ucdavis-igg201b/lab7/install-edgeR.R

cd
curl -L -O https://github.com/COMBINE-lab/salmon/releases/download/v0.8.0/Salmon-0.8.0_linux_x86_64.tar.gz
tar xzf Salmon-0.8.0_linux_x86_64.tar.gz
export PATH=$PATH:$HOME/Salmon-latest_linux_x86_64/bin

mkdir yeast
cd yeast

# mutant data sets:
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458500/ERR458500.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458501/ERR458501.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458502/ERR458502.fastq.gz
# new mutant data sets:
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458503/ERR458503.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458504/ERR458504.fastq.gz

# wild types:
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458493/ERR458493.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458494/ERR458494.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458495/ERR458495.fastq.gz
# new wild type data sets:
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458496/ERR458496.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458497/ERR458497.fastq.gz

curl -O http://downloads.yeastgenome.org/sequence/S288C_reference/orf_dna/orf_coding.fasta.gz

salmon index --index yeast_orfs --type quasi --transcripts orf_coding.fasta.gz

for i in *.fastq.gz
do
salmon quant -i yeast_orfs --libType U -r $i -o $i.quant --seqBias --gcBias
done

curl -L -O https://github.com/ngs-docs/2016-aug-nonmodel-rnaseq/raw/master/files/gather-counts.py
python2 gather-counts.py

git clone https://github.com/aaliyari/201B-HW3.git

Rscript --no-save 201B-HW3/yeast.salmon.R

mv *.csv 201B-HW3/
git commit -m "adding CSV file"
git push origin master

mv ../*.pdf .
git add .
git commit -m "adding the plots and stuff"
git push origin master

cat ~/2017-ucdavis-igg201b/lab8/yeast-edgeR.csv | (read;cat) | awk -F',' '$5<0.05 && $4<0.
05' | wc -l
# output: 4030 (number of genes)

cat yeast-edgeR.csv | (read;cat) | awk -F',' '$5<0.05 && $4<0.05' | wc -l
# output: 4457 (number of genes)

## conclusion: by adding four more data sets, our statistical power is increased
## and we are able to detect more significantly differentially expressed genes.
