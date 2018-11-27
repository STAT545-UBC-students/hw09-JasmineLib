all: report.html

clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html lettercount.tsv lettercount.png

.PHONY analysis1: 
	lettercount.png

report.html: report.rmd histogram.png lettercount.png
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

lettercount.png: lettercount.tsv
	Rscript -e 'library(tidyverse);ggplot(data = read.delim("$<"), aes(letter, lettercount)) + geom_bar(stat = "identity"); ggsave("$@")'
	rm Rplots.pdf
	
histogram.tsv: histogram.r words.txt
	Rscript $<

lettercount.tsv: lettercount.R words.txt
	Rscript $<

words.txt: /usr/share/dict/words
	cp $< $@
	


# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'

