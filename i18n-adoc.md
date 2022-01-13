—
author: Nikolaj Potashnikov
date: 2022-01-11
subtitle: Gettext approach
title: Simple text markup internationalization (i18n)
—
<cut/>

![xrjzpblczowgylzxmvefrjjt4og](https://habrastorage.org/webt/xr/jz/pb/xrjzpblczowgylzxmvefrjjt4og.jpeg)
<cut/>

# Introduction 
<cut/>

[Перейти к русской версии](https://habr.com/ru/post/599775/)
<cut/>

Several years ago my colleague posted an [article](https://dzone.com/articles/presentation-as-code-why-i-abandoned-powerpoint) about making presentations in [Asciidoctor](https://asciidoctor.org/). Since then, we don't use any other approach.
<cut/>

Some time ago there have appeared a problem of translating presentations into several languages and have them synchronized. The solution appeared to be so simple and mature that I decided to describe it in this post.
<cut/>

This solution is syntax-unaware. This means, it doesn't matter whether we use Asciidoc, other light text markup or even mixed format (with my favourite Plantuml or any other diagrams, for example). The serious limitations of this approach are (1) the translator shouldn't break markup structure and (2) we can't directly apply machine translation to the original text.
<cut/>

The solution uses [Translation Toolkit](http://docs.translatehouse.org/projects/translate-toolkit/en/latest/) and standard [GNU Gettext tools](https://www.gnu.org/software/gettext/).
<cut/>

To make this solution clear this article has English and Russian versions. [Its repository](https://github.com/fiddlededee/asciidoc-i18n) contains some simple automation that synchronizes translation, creates printing version (pdf, docx, odt) and creates Markdown file for publishing to Habr.
<cut/>

In my recent article on testing documentation I didn't pay much attention to text linters, because the focus was on approaches, not exact tools. Still these tools are great. To fill the gap, I'll use [vale](https://github.com/errata-ai/vale) for this article.
<cut/>

# The idea 
<cut/>

Gettext assumes that key strings for translation are original messages.
<cut/>

Gettext uses files with `.po` extension (PO — [Portable Object](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html#PO-Files)) to keep both original and translated messages. A great number of editors allow to edit such files either in a single user or collaborative environments.
<cut/>

The idea of Translation Toolkit is to use blocks of adjacent lines as such strings.
<cut/>

Take this example:
<cut/>

    .Winter is
<cut/>

    * snow
    * frost
<cut/>

    * Christmas
    * New Year
<cut/>

It has three blocks of adjacent strings. Translation Toolkit will extract three key strings for translation and will put it to a file with the `.pot` extension (`.pot` stands for `.po` Template).
<cut/>

Putting or removing line breaks in this example you may make any number of strings from 1 to 5. This depends on convenience to the translator.
<cut/>

Using a `.pot` file as a template Gettext creates (updates) `.po` files for all required languages. Translators handle exactly these files. After that Translation Toolkit takes (1) a `.po` file with translation, (2) the original file and creates a final translated file.
<cut/>

# The Process 
<cut/>

The process consists of the following steps.
<cut/>

-   Initial steps to get initial translations in one or several languages.
<cut/>

-   Updating translation steps to synchronize translation with the modified original text.
<cut/>

The following diagrams assume that the original file is `i18n-adoc.adoc` and the translation goes to `i18n-adoc-ru.adoc`.
<cut/>

## Initial steps 
<cut/>

![Initial steps](https://habrastorage.org/webt/0u/rs/zp/0urszpwyr0va0baicqejdrhr7vq.png)
<cut/>

There is a vast number of editors for translating `.po` files. The following screenshot shows [Gtranslator](https://wiki.gnome.org/Apps/Gtranslator) interface. I prefer [Poedit](https://poedit.net/), although the way it replaces backtick with tick while applying machine translation is annoying.
<cut/>

![Translating in Gtranslator](https://habrastorage.org/webt/xe/yp/8q/xeyp8qzjmsdohjrmrccmoojupgo.png)
<cut/>

## Updating translation 
<cut/>

![Updating translation](https://habrastorage.org/webt/um/ff/n3/umffn3yakhg2w72zm4xwbos_rki.png)
<cut/>

# Some notes 
<cut/>

1.  In our documentation, we often reuse source i18n strings just to be sure that names of interface elements in documentation are equal to the same names in our application. We generate these i18n strings automatically in the following format:
<cut/>

        :main-menu-documents: Documents
        :main-menu-documents-my: My
        ...
<cut/>

    We include such a file in the Asciidoc document like `include i17n-{lang}.adoc[]`. Now there is no need to use attributes. Just translate `include i17n-en.adoc[]` to `include i17n-ru.adoc[]`.
<cut/>

2.  When `gettext` updates the `.po` files, it uses fuzzy search. If you slightly change the original text, you won't lose its translation. It will be just marked as flaky.
<cut/>

3.  It's easy to check whether translation file is up-to-date with a Gettext utility `msgfmt`.
<cut/>

        msgfmt --statistics i18n-adoc-ru.po
<cut/>

    It shows the number of translated strings, the number of strings that need checking and the number of untranslated strings.
<cut/>

# Conclusion 
<cut/>

-   Translation Toolkit and Gettext make the process of documentation internationalization quite efficient.
<cut/>

-   Simple text markups are not so simple. To take full advantage of it, one needs a certain level of skills. Try to give a translator the `.po` file. How many of them will be ready to make a translation? Or they'll ask you for text in a more traditional format like Microsoft Word.
<cut/>

-   Quality control: 58 translated messages, 0 errors, 0 warnings and 0 suggestions in 1 file.
