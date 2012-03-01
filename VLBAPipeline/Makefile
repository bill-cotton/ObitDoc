all: VLBAPipelineUserManual.html VLBAPipelineUserManual.pdf metadata.html

VLBAPipelineUserManual.html: VLBAPipelineUserManual.rst
	rst2html.py VLBAPipelineUserManual.rst VLBAPipelineUserManual.html -t \
--section-numbering --cloak-email-addresses

VLBAPipelineUserManual.pdf: VLBAPipelineUserManual.rst
	rst2latex.py VLBAPipelineUserManual.rst VLBAPipelineUserManual.tex -t \
--section-numbering --documentoptions=letter
	pdflatex VLBAPipelineUserManual.tex
	pdflatex VLBAPipelineUserManual.tex
	pdflatex VLBAPipelineUserManual.tex

metadata.html: VOTable.xml VOTable2HTML.xsl
	xsltproc -o metadata.html VOTable2HTML.xsl VOTable.xml

clean:
	rm VLBAPipelineUserManual.aux \
VLBAPipelineUserManual.html \
VLBAPipelineUserManual.log \
VLBAPipelineUserManual.out \
VLBAPipelineUserManual.pdf \
VLBAPipelineUserManual.tex \
VLBAPipelineUserManual.toc \
metadata.html
