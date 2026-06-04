.PHONY: paper clean wordcount sim visium rctd joint_mu download figures validation

PAPER = main

paper: $(PAPER).pdf

$(PAPER).pdf: $(PAPER).tex sections/*.tex refs.bib
	pdflatex $(PAPER).tex
	bibtex $(PAPER)
	pdflatex $(PAPER).tex
	pdflatex $(PAPER).tex

cell_total: results_cell_total.rds

results_cell_total.rds: scripts/cell_total_kernel.R
	Rscript scripts/cell_total_kernel.R

sim: results.rds

results.rds: scripts/sim.R scripts/run.R
	Rscript scripts/run.R

visium: results_visium.rds

results_visium.rds: scripts/sim.R scripts/visium.R data/filtered_feature_bc_matrix/matrix.mtx.gz
	Rscript scripts/visium.R

rctd: results_rctd.rds

results_rctd.rds: scripts/sim.R scripts/rctd_compare.R
	Rscript scripts/rctd_compare.R

joint_mu: results_joint_mu.rds

results_joint_mu.rds: scripts/sim.R scripts/joint_mu.R
	Rscript scripts/joint_mu.R

data/filtered_feature_bc_matrix/matrix.mtx.gz:
	bash scripts/download_data.sh

download: data/filtered_feature_bc_matrix/matrix.mtx.gz

figures: figures/rank_diagnostic.pdf figures/marker_bias.pdf figures/visium_spectrum.pdf

figures/rank_diagnostic.pdf figures/marker_bias.pdf figures/visium_spectrum.pdf: scripts/figures.R results.rds results_visium.rds
	Rscript scripts/figures.R

validation: results.rds results_visium.rds figures

clean:
	rm -f $(PAPER).aux $(PAPER).bbl $(PAPER).blg $(PAPER).log \
	      $(PAPER).out $(PAPER).pdf $(PAPER).fdb_latexmk \
	      $(PAPER).fls $(PAPER).synctex.gz $(PAPER).toc \
	      sections/*.aux

wordcount:
	@texcount -inc -sum -1 $(PAPER).tex 2>/dev/null || \
	  echo "(install texcount for word count)"
