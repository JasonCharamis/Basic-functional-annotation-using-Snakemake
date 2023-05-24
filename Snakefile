rule all:
      input:
         expand ("{species}.hmmsearch.out", species = species)
	       expand ( "{geneset}.VS.SwissProt.fmt6", geneset = geneset )

rule hmmsearch:
     input: "{geneset}.aa"
     output: "{species}.hmmsearch.out"
     params: db = 'pfam/Pfam-A.hmm'
     shell: "hmmsearch --cpu 20 --domtblout {output} {params.db} {input}"

rule domain:
     input: "{geneset}.hmmsearch.out"
     output: "{geneset}.hmmsearch.out"
     params: <PF domain of interest>
     shell: "grep {params} {input} > {output}"

rule makedb:
     input: "SwissProt.fasta"
     output: "SwissProt.dmnd"
     shell: "diamond makedb {input} {output} "

rule diamond:
     input: "{species}.dmnd", "{geneset}.aa"
     output: "{geneset}.VS.SwissProt.fmt6"
     shell: " diamond blastp --query {geneset}.aa --db {input} --out {output} --ultra-sensitive "
