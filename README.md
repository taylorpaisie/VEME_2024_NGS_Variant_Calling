Repo for the VEME 2024 NGS Variant Calling Tutorial!

[![Open with Gitpod](https://img.shields.io/badge/Open%20with-Gitpod-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/taylorpaisie/VEME_2024_NGS_Variant_Calling)

# VEME 2023 NGS Variant Calling Tutorial

## Taylor K. Paisie
### CDC - Bacterial Special Pathogens Branch (BSPB)
### Email:  ltj8@cdc.gov

#### Command line cheat sheet
<figure>
    <img src="images/command-line-cheat-sheet-large.png" height="800">
    <figcaption>Variant Calling Workflow</figcaption>
</figure>

### 1. Background and Metadata
#### What is Variant (or SNP) Calling?
#### Variant calling is the process of identifying and cataloging the differences between the observed sequencing reads and a reference genome
#### Variants are usually determined from alignments or BAM files Typical variant calling process:
1. Align reads to the reference genome
2. Correct and refine alignments
3. Determine variants from the alignments
4. Filter the resulting variants for the desired characteristics

#### In the variant calling process you will run into terminologies that are not always used consistently
#### We will attempt to define a few of these terms while making a note that these definitions are not “textbook” definitions designed to accurately capture the proper terminology
### 2. Assessing Read Quality

<figure>
    <img src="images/variant_calling_steps.png" width="230" height="300">
    <figcaption>Variant Calling Workflow</figcaption>
</figure>

<figure>
    <img src="images/variant_calling_steps.png" width="230" height="300">
    <figcaption>Variant Calling Workflow</figcaption>
</figure>
	
1. Downloading SRA files:  
    * Make a directory to download fastq files:  
    `$ mkdir -p ~/variant_calling/data/untrimmed_fastq`  
    `$ cd ~/variant_calling/data/untrimmed_fastq`
    * Download fastq files:  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1972917/SRR1972917_1.fastq.gz`   
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/007/SRR1972917/SRR1972917_2.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1972918/SRR1972918_1.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/008/SRR1972918/SRR1972918_2.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1972919/SRR1972919_1.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/009/SRR1972919/SRR1972919_2.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1972920/SRR1972920_1.fastq.gz`  
	`$ curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR197/000/SRR1972920/SRR1972920_2.fastq.gz`  
	
2. Let's take a look at one of our fastq files:
	* In order to view our the fastq file, we must decompress it:  
		`$ gunzip SRR1972917_1.fastq.gz`
	* We can view the first complete read in one of the files our dataset by using head to look at the first four lines:  
		`$ head -n 4 SRR1972917_1.fastq`  
    * Output:  
  
```
@SRR1972917.1 1/1
TCCGTGGGGCTGGTACGACAGTATCGATGAGGGTGGACGCTTCAAGGTCAAGCGTATACAGGTCAACCCCAAAGCTAGCCTGAGCCTTCAGAAACACCACC  
+  
@CCFDDFFHGHHHGIJJIIJJJJGJJJJGIJIJJFIJJJIIJJJJHHFHHFFFFAADEFEDDDDDDDDDDDD??CCCDDDDDDCCCDDCCCDD:?CABDDB
``` 

   * Each quality score represents the probability that the corresponding nucleotide call is incorrect  
   * This quality score is logarithmically based, so a quality score of 10 reflects a base call accuracy of 90%, but a quality score of 20 reflects a base call accuracy of 99%
   * These probability values are the results from the base calling algorithm and depend on how much signal was captured for the base incorporation  


```
Quality encoding: !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ
             |         |         |         |         |  
Quality score: 01........11........21........31........41
```

* Compress Fastq file again:  

`$ gzip SRR1972917_1.fastq`  

1. Assessing read quality using FastQC
    * FastQC has a number of features which can give you a quick impression of any problems your data may have, so you can take these issues into consideration before moving forward with your analyses   
    * Rather than looking at quality scores for each individual read, FastQC looks at quality collectively across all reads within a sample  
    * The x-axis displays the base position in the read, and the y-axis shows quality scores  
    * For each position, there is a box-and-whisker plot showing the distribution of quality scores for all reads at that position  
    * The horizontal red line indicates the median quality score and the yellow box shows the 1st to 3rd quartile range  
    * This means that 50% of reads have a quality score that falls within the range of the yellow box at that position  
    * The whiskers show the absolute range, which covers the lowest (0th quartile) to highest (4th quartile) values  
    *The plot background is also color-coded to identify good (green), acceptable (yellow), and bad (red) quality scores  


    `$ fastqc -h`  
    `$ fastqc *.fastq*`  

    * Output should look like this:  
```
application/gzip   
    Started analysis of SRR1972917_1.fastq.gz  
    Approx 5% complete for SRR1972917_1.fastq.gz  
    Approx 10% complete for SRR1972917_1.fastq.gz  
    Approx 15% complete for SRR1972917_1.fastq.gz  
    Approx 20% complete for SRR1972917_1.fastq.gz  
    Approx 25% complete for SRR1972917_1.fastq.gz  
    Approx 30% complete for SRR1972917_1.fastq.gz  
    Approx 35% complete for SRR1972917_1.fastq.gz  
    Approx 40% complete for SRR1972917_1.fastq.gz  
    Approx 45% complete for SRR1972917_1.fastq.gz  
    Approx 50% complete for SRR1972917_1.fastq.gz  
    Approx 55% complete for SRR1972917_1.fastq.gz  
    Approx 60% complete for SRR1972917_1.fastq.gz  
    Approx 65% complete for SRR1972917_1.fastq.gz  
    Approx 70% complete for SRR1972917_1.fastq.gz  
    Approx 75% complete for SRR1972917_1.fastq.gz  
    Approx 80% complete for SRR1972917_1.fastq.gz  
    Approx 85% complete for SRR1972917_1.fastq.gz  
    Approx 90% complete for SRR1972917_1.fastq.gz  
    Approx 95% complete for SRR1972917_1.fastq.gz  
    Analysis complete for SRR1972917_1.fastq.gz
```

   * Lets now look at the files created by FastQC:  
    `$ ls -al` 

   * For each input FASTQ file, FastQC has created a .zip file and a .html file  
   * The .zip file extension indicates that this is actually a compressed set of multiple output files   
   * The .html file is a stable webpage displaying the summary report for each of our samples  
   * We want to keep our data files and our results files separate, so we will move these output files into a new directory within our results/ directory  
    
`$ cd ~/variant_calling`  
`$ mkdir -p results/fastqc_untrimmed_reads`  
`$ mv ~/variant_calling/data/untrimmed_fastq/*.zip ~/variant_calling/results/fastqc_untrimmed_reads`  
`$ mv ~/variant_calling/data/untrimmed_fastq/*.html ~/variant_calling/results/fastqc_untrimmed_reads`  
`$ cd ~/variant_calling/results/fastqc_untrimmed_reads`  

   * We can now open the .html file to view the FastQC results:  

<figure>
    <img src="images/untrimmed_fastqc_picture.png" width="500" height="300">
    <figcaption>FastQC output of SRR1972917_1.fastq.gz</figcaption>
</figure>

