params.cpus = 1
params.memory = "4g"
params.output = ""
params.mapping_quality = 0
params.base_call_quality = 0
params.skip_multiallelic_filter = false
params.enable_conda = false


process VAFATOR {
    cpus params.cpus
    memory params.memory
    tag "${patient_name}"
    publishDir "${params.output}/${patient_name}", mode: "copy"

    conda (params.enable_conda ? "bioconda::vafator=1.1.4" : null)

    input:
    tuple val(patient_name), file(vcf), val(bams)

    output:
    tuple val(patient_name), file("${vcf.baseName}.vaf.vcf"), emit: annotated_vcf

    script:
    bams_param = bams.collect { b -> "--bam " + b.split(":").join(" ") }.join(" ")
    """
    vafator \
    --input-vcf ${vcf} \
    --output-vcf ${vcf.baseName}.vaf.vcf \
    ${bams_param} \
    --mapping-quality ${params.mapping_quality} \
    --base-call-quality ${params.base_call_quality}
    """
}


process MULTIALLELIC_FILTER {
    cpus params.cpus
    memory params.memory
    tag "${name}"
    publishDir "${params.output}/${name}", mode: "copy"

    conda (params.enable_conda ? "bioconda::vafator=1.1.4" : null)

    input:
    tuple val(name), file(vcf)

    output:
    tuple val(name), file("${vcf.baseName}.filtered_multiallelics.vcf"), emit: filtered_vcf

    script:
    """
    multiallelics-filter --input-vcf ${vcf} --output-vcf ${vcf.baseName}.filtered_multiallelics.vcf
    """
}
