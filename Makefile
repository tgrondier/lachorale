.PHONY: *
.DEFAULT_GOAL:=help


download-legacy: ## Telecharge le site lachorale.ch
	wget --recursive -N --page-requisites --html-extension --convert-links --domains lachorale.ch --no-parent https://lachorale.ch/
	wget https://lachorale.ch/ -O lachorale.ch/index.html



texte-intro: ## synchronise le texte d'intro
	xmllint --html --xpath '//html/body/div[@id="texte-intro"]' lachorale.ch/index.html 2>/dev/null | pandoc -f "html" -t "markdown" -t gfm-raw_html -o content/repetitions.md

texte-eve: ## synchronise le texte d'evenemens
	xmllint --html --xpath '//html/body/div[@id="texte-eve"]' lachorale.ch/index.html 2>/dev/null | pandoc -f "html" -t "markdown" -t gfm-raw_html | sed -e 's/\*\*Toutes nos dates\*\*/### Toutes nos dates/' -e 's/\\\*/*/g' > content/concerts.md

chansonnier:
	cp -r lachorale.ch/site/chansonnier/ static

sons:
	cp -r lachorale.ch/site/sons/ static

partitions:
	cp -r lachorale.ch/site/partitions/ static

flyers:
	cp -r lachorale.ch/site/flyers/ static


static: chansonnier sons partitions flyers ## met a jour les fichiers statiques du site

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)