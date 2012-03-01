all: VLBAPipelineUserManual.html VLBAPipelineUserManual.pdf metadata.html \
PipelineHeuristics.pdf Report_20110607.pdf

VLBAPipelineUserManual.html: VLBAPipelineUserManual.rst
	rst2html.py VLBAPipelineUserManual.rst VLBAPipelineUserManual.html -t \
--section-numbering --cloak-email-addresses

VLBAPipelineUserManual.pdf: VLBAPipelineUserManual.rst
	rst2latex.py VLBAPipelineUserManual.rst VLBAPipelineUserManual.tex -t \
--section-numbering --documentoptions=letter
	pdflatex VLBAPipelineUserManual.tex
	pdflatex VLBAPipelineUserManual.tex
	pdflatex VLBAPipelineUserManual.tex

PipelineHeuristics.pdf: PipelineHeuristics.tex
	pdflatex PipelineHeuristics.tex

metadata.html: VOTable.xml VOTable2HTML.xsl
	xsltproc -o metadata.html VOTable2HTML.xsl VOTable.xml

Report_20110607.pdf: Report_20110607.rst
	rst2latex.py Report_20110607.rst Report_20110607.tex --use-latex-docinfo \
--documentoptions='letterpaper' --stylesheet=fullpage
	pdflatex Report_20110607.tex
	pdflatex Report_20110607.tex

dist: VLBAPipelineUserManual.html VLBAPipelineUserManual.pdf metadata.html \
PipelineHeuristics.pdf
	cp VLBAPipelineUserManual.html VLBAPipelineUserManual.pdf metadata.html \
PipelineHeuristics.pdf /users/jcrossle/public_html/VLBAPipeline/

clean:
	rm VLBAPipelineUserManual.aux \
VLBAPipelineUserManual.html \
VLBAPipelineUserManual.log \
VLBAPipelineUserManual.out \
VLBAPipelineUserManual.pdf \
VLBAPipelineUserManual.tex \
VLBAPipelineUserManual.toc \
metadata.html \
PipelineHeuristics.pdf \
PipelineHeuristics.aux \
PipelineHeuristics.log \
Report_20110607.aux \
Report_20110607.log \
Report_20110607.out \
Report_20110607.pdf \
Report_20110607.tex
