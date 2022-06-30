params.cpus = 1
params.memory = "4g"
params.output = "output"
params.filter = false


process FILTER_VCF {
    cpus params.cpus
    memory params.memory
    tag "${name}"

    conda (params.enable_conda ? "bioconda::bcftools=1.15.1" : null)

    input:
    	tuple val(name), file(vcf)

    output:
      tuple val(name), file("${vcf.baseName}.filtered.vcf"), emit: filtered_vcfs

    """
    # filter variants
    bcftools view --apply-filters ${params.filter} -o ${vcf.baseName}.filtered.vcf ${vcf}
    """
  }