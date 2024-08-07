# Running reference-based viral genome assembly using miniwdl

This describes running WDL-defined viral workflows using the command line.
These are the same pipelines from the Broad Institute Viral Genomics Group available on Dockstore:
https://dockstore.org/organizations/BroadInstitute/collections/pgs

### Obtain the viral-pipelines workflows 

This mirrors the instructions in the [miniwdl documentation](https://miniwdl.readthedocs.io/en/latest/getting_started.html#fetch-viral-pipelines); 
start by obtaining a copy of the WDL workflows from [broadinstitute/viral-pipelines](https://github.com/broadinstitute/viral-pipelines):


```
wget -nv -O - https://github.com/broadinstitute/viral-pipelines/archive/v2.2.4.0.tar.gz | tar zx
cd viral-pipelines-*
```

### Run reference-based assembly

Miniwdl can tell us the inputs and outputs of the [assemble_refbased workflow](https://github.com/broadinstitute/viral-pipelines/blob/master/pipes/WDL/workflows/assemble_refbased.wdl):

```
miniwdl run pipes/WDL/workflows/assemble_refbased.wdl
```

This provides us with the following information:

```
missing required inputs for assemble_refbased: reads_unmapped_bams, reference_fasta

required inputs:
  Array[File]+ reads_unmapped_bams
  File reference_fasta

optional inputs:
  String sample_name
  ...

outputs:
  File assembly_fasta
  Int assembly_length
  Int assembly_length_unambiguous
  Int reference_genome_length
  Float assembly_mean_coverage
  ...
```

To run the workflow, the required inputs will need to be specified. They can be passed as command-line arguments to miniwdl:

```
miniwdl run pipes/WDL/workflows/assemble_refbased.wdl   \
    reads_unmapped_bams=test/input/G5012.3.testreads.bam  \
    reference_fasta=test/input/ebov-makona.fasta          \
    sample_name=G5012.3 --verbose
```
In this case, sequence read data from the [viral-pipelines repository](https://github.com/broadinstitute/viral-pipelines) is used as input.

The pipeline will quickly finish running on the small input data.
The output from each execution of the pipeline will be stored in the current directory, in a timestamped sub-directory.
Take a look within to find the results of the execution initiated above.

When running, miniwdl sets a [symlink](https://en.wikipedia.org/wiki/Symbolic_link), `_LAST`, to point to the directory containing the output from the most recent execution.