file="gfss_2013"
slides="$(file).md"
theme="$(HOME)/mywork/landslide-themes/simple"

# Extensions:
# http://pythonhosted.org/Markdown/extensions/tables.html

html:
	landslide --linenos=no --encoding=utf8 --relative --embed --destination $(file).html $(slides)

html_simple:
	landslide --theme=$(theme) --linenos=no --encoding=utf8 --extensions=tables --relative --embed --destination $(file).html $(slides)

pdf:
	landslide --theme=$(theme) --linenos=table --encoding=utf8 --relative --embed --destination $(file).pdf $(slides)

clean:
	rm -f *.html *.pdf figures/*.dot.svg
