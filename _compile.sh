#/bin/bash

cd "$(dirname "$0")"
cd src
txt2po -P i18n-adoc.adoc i18n-adoc.pot
msgmerge -U i18n-adoc-ru.po i18n-adoc.pot

cd "$(dirname "$0")"
rm target -rf
mkdir target
cp src/. target -rf

cd "$(dirname "$0")"
cd target
msgfmt --statistics i18n-adoc-ru.po |& grep 'fuzzy\|untranslated' | tee -a log.txt
docker run -v $(pwd):/docs --rm -w /docs jdkato/vale i18n-adoc.adoc | grep '[1-9][0-9]* error\|[1-9][0-9]* warning' |  tee -a log.txt
po2txt -t i18n-adoc.adoc i18n-adoc-ru.po i18n-adoc-ru.adoc

../_output_files.sh i18n-adoc.adoc
../_output_files.sh i18n-adoc-ru.adoc

mkdir out
cp {*.odt,*.pdf,*.docx,*.md,*.html,*.png,*.jpeg,*.jpg} out

if [ -s log.txt ]; then
  exit 1
else
  echo Success!
fi
