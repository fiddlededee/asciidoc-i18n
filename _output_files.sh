#/bin/bash

echo output $1 backends
docker run --rm -v $(pwd):/documents/  curs/asciidoctor-od a-od $1 docx template.fodt
docker run --rm -v $(pwd):/documents/  curs/asciidoctor-od a-od $1 odt template.fodt
docker run --rm -v $(pwd):/documents/  curs/asciidoctor-od a-od $1 pdf template.fodt
docker run --rm -v $(pwd):/documents/  curs/asciidoctor-od asciidoctor $1 -r asciidoctor-diagram
docker run --rm -v $(pwd):/documents/ curs/asciidoctor-od asciidoctor $1 -b docbook -v 2>> log.txt
docker run --rm -v $(pwd):/data/ pandoc/core -f docbook -t markdown -s ${1%.adoc}.xml -o ${1%.adoc}.md --wrap=none --atx-headers
# Makrdown and Markdown are different languages
sed  -i 's/{[#][a-zа-я_]*}//g' ${1%.adoc}.md
sed  -i 's/---/—/g' ${1%.adoc}.md
sed  -i 's/^$/\<cut\/\>\n/g' ${1%.adoc}.md