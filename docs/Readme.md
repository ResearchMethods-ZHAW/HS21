Anleitung für Admins
================

<!--radix_placeholder_navigation_in_header-->
<meta name="distill:offset" content=""/>

<script type="application/javascript">

  window.headroom_prevent_pin = false;

  window.document.addEventListener("DOMContentLoaded", function (event) {

    // initialize headroom for banner
    var header = $('header').get(0);
    var headerHeight = header.offsetHeight;
    var headroom = new Headroom(header, {
      tolerance: 5,
      onPin : function() {
        if (window.headroom_prevent_pin) {
          window.headroom_prevent_pin = false;
          headroom.unpin();
        }
      }
    });
    headroom.init();
    if(window.location.hash)
      headroom.unpin();
    $(header).addClass('headroom--transition');

    // offset scroll location for banner on hash change
    // (see: https://github.com/WickyNilliams/headroom.js/issues/38)
    window.addEventListener("hashchange", function(event) {
      window.scrollTo(0, window.pageYOffset - (headerHeight + 25));
    });

    // responsive menu
    $('.distill-site-header').each(function(i, val) {
      var topnav = $(this);
      var toggle = topnav.find('.nav-toggle');
      toggle.on('click', function() {
        topnav.toggleClass('responsive');
      });
    });

    // nav dropdowns
    $('.nav-dropbtn').click(function(e) {
      $(this).next('.nav-dropdown-content').toggleClass('nav-dropdown-active');
      $(this).parent().siblings('.nav-dropdown')
         .children('.nav-dropdown-content').removeClass('nav-dropdown-active');
    });
    $("body").click(function(e){
      $('.nav-dropdown-content').removeClass('nav-dropdown-active');
    });
    $(".nav-dropdown").click(function(e){
      e.stopPropagation();
    });
  });
</script>

<style type="text/css">

/* Theme (user-documented overrideables for nav appearance) */

.distill-site-nav {
  color: rgba(255, 255, 255, 0.8);
  background-color: #0F2E3D;
  font-size: 15px;
  font-weight: 300;
}

.distill-site-nav a {
  color: inherit;
  text-decoration: none;
}

.distill-site-nav a:hover {
  color: white;
}

@media print {
  .distill-site-nav {
    display: none;
  }
}

.distill-site-header {

}

.distill-site-footer {

}


/* Site Header */

.distill-site-header {
  width: 100%;
  box-sizing: border-box;
  z-index: 3;
}

.distill-site-header .nav-left {
  display: inline-block;
  margin-left: 8px;
}

@media screen and (max-width: 768px) {
  .distill-site-header .nav-left {
    margin-left: 0;
  }
}


.distill-site-header .nav-right {
  float: right;
  margin-right: 8px;
}

.distill-site-header a,
.distill-site-header .title {
  display: inline-block;
  text-align: center;
  padding: 14px 10px 14px 10px;
}

.distill-site-header .title {
  font-size: 18px;
  min-width: 150px;
}

.distill-site-header .logo {
  padding: 0;
}

.distill-site-header .logo img {
  display: none;
  max-height: 20px;
  width: auto;
  margin-bottom: -4px;
}

.distill-site-header .nav-image img {
  max-height: 18px;
  width: auto;
  display: inline-block;
  margin-bottom: -3px;
}



@media screen and (min-width: 1000px) {
  .distill-site-header .logo img {
    display: inline-block;
  }
  .distill-site-header .nav-left {
    margin-left: 20px;
  }
  .distill-site-header .nav-right {
    margin-right: 20px;
  }
  .distill-site-header .title {
    padding-left: 12px;
  }
}


.distill-site-header .nav-toggle {
  display: none;
}

.nav-dropdown {
  display: inline-block;
  position: relative;
}

.nav-dropdown .nav-dropbtn {
  border: none;
  outline: none;
  color: rgba(255, 255, 255, 0.8);
  padding: 16px 10px;
  background-color: transparent;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  margin: 0;
  margin-top: 1px;
  z-index: 2;
}

.nav-dropdown-content {
  display: none;
  position: absolute;
  background-color: white;
  min-width: 200px;
  border: 1px solid rgba(0,0,0,0.15);
  border-radius: 4px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.1);
  z-index: 1;
  margin-top: 2px;
  white-space: nowrap;
  padding-top: 4px;
  padding-bottom: 4px;
}

.nav-dropdown-content hr {
  margin-top: 4px;
  margin-bottom: 4px;
  border: none;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

.nav-dropdown-active {
  display: block;
}

.nav-dropdown-content a, .nav-dropdown-content .nav-dropdown-header {
  color: black;
  padding: 6px 24px;
  text-decoration: none;
  display: block;
  text-align: left;
}

.nav-dropdown-content .nav-dropdown-header {
  display: block;
  padding: 5px 24px;
  padding-bottom: 0;
  text-transform: uppercase;
  font-size: 14px;
  color: #999999;
  white-space: nowrap;
}

.nav-dropdown:hover .nav-dropbtn {
  color: white;
}

.nav-dropdown-content a:hover {
  background-color: #ddd;
  color: black;
}

.nav-right .nav-dropdown-content {
  margin-left: -45%;
  right: 0;
}

@media screen and (max-width: 768px) {
  .distill-site-header a, .distill-site-header .nav-dropdown  {display: none;}
  .distill-site-header a.nav-toggle {
    float: right;
    display: block;
  }
  .distill-site-header .title {
    margin-left: 0;
  }
  .distill-site-header .nav-right {
    margin-right: 0;
  }
  .distill-site-header {
    overflow: hidden;
  }
  .nav-right .nav-dropdown-content {
    margin-left: 0;
  }
}


@media screen and (max-width: 768px) {
  .distill-site-header.responsive {position: relative; min-height: 500px; }
  .distill-site-header.responsive a.nav-toggle {
    position: absolute;
    right: 0;
    top: 0;
  }
  .distill-site-header.responsive a,
  .distill-site-header.responsive .nav-dropdown {
    display: block;
    text-align: left;
  }
  .distill-site-header.responsive .nav-left,
  .distill-site-header.responsive .nav-right {
    width: 100%;
  }
  .distill-site-header.responsive .nav-dropdown {float: none;}
  .distill-site-header.responsive .nav-dropdown-content {position: relative;}
  .distill-site-header.responsive .nav-dropdown .nav-dropbtn {
    display: block;
    width: 100%;
    text-align: left;
  }
}

/* Site Footer */

.distill-site-footer {
  width: 100%;
  overflow: hidden;
  box-sizing: border-box;
  z-index: 3;
  margin-top: 30px;
  padding-top: 30px;
  padding-bottom: 30px;
  text-align: center;
}

/* Headroom */

d-title {
  padding-top: 6rem;
}

@media print {
  d-title {
    padding-top: 4rem;
  }
}

.headroom {
  z-index: 1000;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
}

.headroom--transition {
  transition: all .4s ease-in-out;
}

.headroom--unpinned {
  top: -100px;
}

.headroom--pinned {
  top: 0;
}

/* adjust viewport for navbar height */
/* helps vertically center bootstrap (non-distill) content */
.min-vh-100 {
  min-height: calc(100vh - 100px) !important;
}

</style>

<script src="site_libs/jquery-1.11.3/jquery.min.js"></script>
<link href="site_libs/font-awesome-5.1.0/css/all.css" rel="stylesheet"/>
<link href="site_libs/font-awesome-5.1.0/css/v4-shims.css" rel="stylesheet"/>
<script src="site_libs/headroom-0.9.4/headroom.min.js"></script>
<script src="site_libs/autocomplete-0.37.1/autocomplete.min.js"></script>
<script src="site_libs/fuse-6.4.1/fuse.min.js"></script>

<script type="application/javascript">

function getMeta(metaName) {
  var metas = document.getElementsByTagName('meta');
  for (let i = 0; i < metas.length; i++) {
    if (metas[i].getAttribute('name') === metaName) {
      return metas[i].getAttribute('content');
    }
  }
  return '';
}

function offsetURL(url) {
  var offset = getMeta('distill:offset');
  return offset ? offset + '/' + url : url;
}

function createFuseIndex() {

  // create fuse index
  var options = {
    keys: [
      { name: 'title', weight: 20 },
      { name: 'categories', weight: 15 },
      { name: 'description', weight: 10 },
      { name: 'contents', weight: 5 },
    ],
    ignoreLocation: true,
    threshold: 0
  };
  var fuse = new window.Fuse([], options);

  // fetch the main search.json
  return fetch(offsetURL('search.json'))
    .then(function(response) {
      if (response.status == 200) {
        return response.json().then(function(json) {
          // index main articles
          json.articles.forEach(function(article) {
            fuse.add(article);
          });
          // download collections and index their articles
          return Promise.all(json.collections.map(function(collection) {
            return fetch(offsetURL(collection)).then(function(response) {
              if (response.status === 200) {
                return response.json().then(function(articles) {
                  articles.forEach(function(article) {
                    fuse.add(article);
                  });
                })
              } else {
                return Promise.reject(
                  new Error('Unexpected status from search index request: ' +
                            response.status)
                );
              }
            });
          })).then(function() {
            return fuse;
          });
        });

      } else {
        return Promise.reject(
          new Error('Unexpected status from search index request: ' +
                      response.status)
        );
      }
    });
}

window.document.addEventListener("DOMContentLoaded", function (event) {

  // get search element (bail if we don't have one)
  var searchEl = window.document.getElementById('distill-search');
  if (!searchEl)
    return;

  createFuseIndex()
    .then(function(fuse) {

      // make search box visible
      searchEl.classList.remove('hidden');

      // initialize autocomplete
      var options = {
        autoselect: true,
        hint: false,
        minLength: 2,
      };
      window.autocomplete(searchEl, options, [{
        source: function(query, callback) {
          const searchOptions = {
            isCaseSensitive: false,
            shouldSort: true,
            minMatchCharLength: 2,
            limit: 10,
          };
          var results = fuse.search(query, searchOptions);
          callback(results
            .map(function(result) { return result.item; })
          );
        },
        templates: {
          suggestion: function(suggestion) {
            var img = suggestion.preview && Object.keys(suggestion.preview).length > 0
              ? `<img src="${offsetURL(suggestion.preview)}"</img>`
              : '';
            var html = `
              <div class="search-item">
                <h3>${suggestion.title}</h3>
                <div class="search-item-description">
                  ${suggestion.description || ''}
                </div>
                <div class="search-item-preview">
                  ${img}
                </div>
              </div>
            `;
            return html;
          }
        }
      }]).on('autocomplete:selected', function(event, suggestion) {
        window.location.href = offsetURL(suggestion.path);
      });
      // remove inline display style on autocompleter (we want to
      // manage responsive display via css)
      $('.algolia-autocomplete').css("display", "");
    })
    .catch(function(error) {
      console.log(error);
    });

});

</script>

<style type="text/css">

.nav-search {
  font-size: x-small;
}

/* Algolioa Autocomplete */

.algolia-autocomplete {
  display: inline-block;
  margin-left: 10px;
  vertical-align: sub;
  background-color: white;
  color: black;
  padding: 6px;
  padding-top: 8px;
  padding-bottom: 0;
  border-radius: 6px;
  border: 1px #0F2E3D solid;
  width: 180px;
}


@media screen and (max-width: 768px) {
  .distill-site-nav .algolia-autocomplete {
    display: none;
    visibility: hidden;
  }
  .distill-site-nav.responsive .algolia-autocomplete {
    display: inline-block;
    visibility: visible;
  }
  .distill-site-nav.responsive .algolia-autocomplete .aa-dropdown-menu {
    margin-left: 0;
    width: 400px;
    max-height: 400px;
  }
}

.algolia-autocomplete .aa-input, .algolia-autocomplete .aa-hint {
  width: 90%;
  outline: none;
  border: none;
}

.algolia-autocomplete .aa-hint {
  color: #999;
}
.algolia-autocomplete .aa-dropdown-menu {
  width: 550px;
  max-height: 70vh;
  overflow-x: visible;
  overflow-y: scroll;
  padding: 5px;
  margin-top: 3px;
  margin-left: -150px;
  background-color: #fff;
  border-radius: 5px;
  border: 1px solid #999;
  border-top: none;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion {
  cursor: pointer;
  padding: 5px 4px;
  border-bottom: 1px solid #eee;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion:last-of-type {
  border-bottom: none;
  margin-bottom: 2px;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item {
  overflow: hidden;
  font-size: 0.8em;
  line-height: 1.4em;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item h3 {
  font-size: 1rem;
  margin-block-start: 0;
  margin-block-end: 5px;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item-description {
  display: inline-block;
  overflow: hidden;
  height: 2.8em;
  width: 80%;
  margin-right: 4%;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item-preview {
  display: inline-block;
  width: 15%;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item-preview img {
  height: 3em;
  width: auto;
  display: none;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion .search-item-preview img[src] {
  display: initial;
}

.algolia-autocomplete .aa-dropdown-menu .aa-suggestion.aa-cursor {
  background-color: #eee;
}
.algolia-autocomplete .aa-dropdown-menu .aa-suggestion em {
  font-weight: bold;
  font-style: normal;
}

</style>


<!--/radix_placeholder_navigation_in_header-->

<!--radix_placeholder_site_in_header-->
<style type="text/css">

/* without this padding, the text added to a listings page is to high */

body.layout-listing p {
  padding-top: 50px
}


.sourceCode, d-article pre{
    background-color: #f7f7f7;
}



/* stylign the footer (_footer.html) */
.footer div{
  text-align: justify;
}

.footer img{
  max-height: 200px; 
  float: right;
}

/* hides the publish date from the listing, so we can specify the order via that date */
.publishedDate {
    visibility: hidden;
}
</style>
<!--/radix_placeholder_site_in_header-->


<style type="text/css">
body {
  padding-top: 60px;
}
</style>

<!--radix_placeholder_navigation_before_body-->
<header class="header header--fixed" role="banner">
<nav class="distill-site-nav distill-site-header">
<div class="nav-left">
<span class="logo">
<img src="zhaw_sw_neg.png"/>
</span>
<a href="index.html" class="title">Modul Research Methods</a>
<input id="distill-search" class="nav-search hidden" type="text" placeholder="Search..."/>
</div>
<div class="nav-right">
<a href="index.html">Home</a>
<div class="nav-dropdown">
<button class="nav-dropbtn">
Preprocessing
 
<span class="down-arrow">&#x25BE;</span>
</button>
<div class="nav-dropdown-content">
<a href="PrePro_abstract.html">Abstract</a>
<hr/>
<a href="PrePro.html#category:PrePro1">PrePro1</a>
<a href="PrePro.html#category:PrePro2">PrePro2</a>
</div>
</div>
<div class="nav-dropdown">
<button class="nav-dropbtn">
InforVis
 
<span class="down-arrow">&#x25BE;</span>
</button>
<div class="nav-dropdown-content">
<a href="InfoVis_abstract.html">Abstract</a>
<hr/>
<a href="InfoVis.html#category:InfoVis1">InfoVis1</a>
<a href="InfoVis.html#category:InfoVis2">InfoVis2</a>
</div>
</div>
<div class="nav-dropdown">
<button class="nav-dropbtn">
Statistik
 
<span class="down-arrow">&#x25BE;</span>
</button>
<div class="nav-dropdown-content">
<a href="Statistik_abstract.html">Abstract</a>
<hr/>
<span class="nav-dropdown-header">Statistik 1 - 4</span>
<a href="Statistik.html#category:Statistik1">Statistik1</a>
<a href="Statistik.html#category:Statistik2">Statistik2</a>
<a href="Statistik.html#category:Statistik3">Statistik3</a>
<a href="Statistik.html#category:Statistik4">Statistik4</a>
<hr/>
<span class="nav-dropdown-header">Statistik 5 - 8</span>
<a href="Statistik.html#category:Statistik5">Statistik5</a>
<a href="Statistik.html#category:Statistik6">Statistik6</a>
<a href="Statistik.html#category:Statistik7">Statistik7</a>
<a href="Statistik.html#category:Statistik8">Statistik8</a>
</div>
</div>
<div class="nav-dropdown">
<button class="nav-dropbtn">
Statistik Konsolidierung
 
<span class="down-arrow">&#x25BE;</span>
</button>
<div class="nav-dropdown-content">
<a href="Statistik-Konsolidierung_abstract.html">Abstract</a>
<hr/>
<span class="nav-dropdown-header">Statistik Konsolidierung 1 - 4</span>
<a href="Statistik-Konsolidierung.html#category:Statistik_Konsolidierung1">Statistik_Konsolidierung1</a>
<a href="Statistik-Konsolidierung.html#category:Statistik_Konsolidierung2">Statistik_Konsolidierung2</a>
<a href="Statistik-Konsolidierung.html#category:Statistik_Konsolidierung3">Statistik_Konsolidierung3</a>
<a href="Statistik-Konsolidierung.html#category:Statistik_Konsolidierung4">Statistik_Konsolidierung4</a>
</div>
</div>
<div class="nav-dropdown">
<button class="nav-dropbtn">
Räumliche Analyse
 
<span class="down-arrow">&#x25BE;</span>
</button>
<div class="nav-dropdown-content">
<a href="RaumAn_abstract.html">Abstract</a>
<hr/>
<a href="RaumAn.html#category:RaumAn1">RaumAn1</a>
<a href="RaumAn.html#category:RaumAn2">RaumAn2</a>
<a href="RaumAn.html#category:RaumAn3">RaumAn3</a>
</div>
</div>
<a href="javascript:void(0);" class="nav-toggle">&#9776;</a>
</div>
</nav>
</header>
<!--/radix_placeholder_navigation_before_body-->

<!--radix_placeholder_site_before_body-->
<!--/radix_placeholder_site_before_body-->

-   [Allgemeines](#allgemeines)
-   [Anleitung: Software Aufsetzen](#anleitung-software-aufsetzen)
-   [Anleitung: Projekt aufsetzen](#anleitung-projekt-aufsetzen)
-   [Anleitung: Inhalte Editieren und
    veröffentlichen](#anleitung-inhalte-editieren-und-veröffentlichen)
-   [Anleitung: Listings editieren und
    veröffentlichen](#anleitung-listings-editieren-und-veröffentlichen)

## Allgemeines

### Distill

Im Kurs Research Methods verwenden wir seit einigen Jahren RMarkdown um
die R Unterlagen für die Studenten bereit zu stellen. Bis und mit HS2020
haben wir dafür [`bookdown`](https://bookdown.org/yihui/blogdown/)
verwendet, im HS2021 wollen wir zu
[`distill`](https://rstudio.github.io/distill/) wechseln.

-   Vorteil: Mit Bookdown müssen bei Änderungen jeweils *alle*
    .Rmd-Files neu kompiliert werden, was unter umständen sehr lange
    dauern kann. Mit `distill` ist jedes .Rmd File wie ein eigenes
    kleines Projekt und kann eigenständig kompiliert werden.
-   Nachteile:
    -   Werden files in mehreren .Rmd Files benutzt müssen diese für
        jedes .Rmd file abgespeichert werden
    -   ein PDF wird nicht ohne weiteres generiert

### Renv

Im Unterricht werden sehr viele RPackages verwendet. Um sicher zu
stellen, das wir alle mit der gleichen Version dieser Packages arbeiten
verwenden wir das RPackage [`renv`](https://rstudio.github.io/renv/).
Das arbeiten mit `renv` bringt folgende Änderungen mit sich:

-   Packages werden alle im Projektfolder installiert (`renv/library`)
    statt wie üblich in `C:/Users/xyz/Documents/R/win-library/3.6` bzw.
    `C:/Program Files/R/R-3.6.1/library`
    -   Dies wird durch `.Rprofile` sichergestellt (`.Rprofile` wird
        automatisch beim Laden des Projektes ausgeführt)
    -   Der Folder `renv/library` wird *nicht* via github geteilt (dies
        wird mit `renv/.gitignore` sichergestellt)
-   Die Liste der Packages wird in `renv.lock` festgehalten (mit dem
    Befehl `renv::snapshot()`, mehr dazu später)
-   Die Packages werden mit `renv::restore()` lokal installiert

## Anleitung: Software Aufsetzen

### R, RStudio und Git installieren

*(wer dies bereits gemacht hat, kann diesen Schritt überspringen)*

Wer Lokal auf seinem eingenen PC arbeiten will, muss eine aktuell
version von R, RStudio und Git installieren. Siehe dazu folgende
Anleitungen:

-   [Install or upgrade R and
    RStudio](https://happygitwithr.com/install-r-rstudio.html)
-   [Install Git](https://happygitwithr.com/install-git.html)

### RStudio Konfigurieren

Ich empfehle folgende Konfiguration in RStudio
(`Global Options -> R Markdown`):

-   Show document outline by default: checked *(Stellt ein
    Inhaltsverzeichnis rechts von .Rmd files dar)*
-   Soft-wrap R Markdown files: checken *(macht autmatische
    Zeilenumbrüche bei .Rmd files)*
-   Show in document outline: Sections Only *(zeigt nur “Sections” im
    Inhaltsverzeichnis)*
-   Show output preview in: Window *(beim kopilieren von Rmd Files wird
    im Anschluss ein Popup mit dem Resultat dargestellt)*
-   Show equation an impage previews: In a popup
-   Evaluate chunks in directory: Document

### Git konfigurieren

*(wer dies bereits gemacht hat, kann diesen Schritt überspringen)*

Nach der Installation muss git konfiguriert werden. Siehe dazu folgende
Kapitel:

-   [Introduce yourself to
    Git](https://happygitwithr.com/hello-git.html)
-   [Cache credentials for
    HTTPS](https://happygitwithr.com/credential-caching.html)

## Anleitung: Projekt aufsetzen

### Repo Klonen

Um die ganzen \*.Rmd Files lokal bearbeiten zu können, muss das
Repository geklont werden. Mit RStudio ist dies sehr einfach, siehe dazu
nachstehende Anleitung. Als Repo-URL folgendes einfügen:
`https://github.zhaw.ch/ModulResearchMethods/Unterrichtsunterlagen_HS20.git`

-   [New RStudio Project via git
    clone](https://happygitwithr.com/new-github-first.html#new-rstudio-project-via-git)

### “Upstream” setzen

Um das Github repo als standart “upstream” zu setzen muss man im
Terminal nachstehenden Befehl eingeben. Danach RStudio neu starten und
das entsprechende Projekt laden. Nun sollte im “Git” fenster der “Push”
button nicht mehr inaktiv sein.

    git branch -u origin/main

### Notwendige Packages installieren

Wie bereits erwähnt, verwenden wir im Projekt `renv`.

-   Installiert dieses Package mit `install.packages("renv")`
-   Installiert alle notwendigen Packages mit `renv::restore()`

## Anleitung: Inhalte Editieren und veröffentlichen

Eine `distill` Webseite besteht aus einzelnen .Rmd Files, pro Rmd-File
exisitert ein eigener Ordner im Projekt. Diese Rmd fiels werden beim
Kompilieren (`knìt`) in .html-Files konvertiert. Um daraus eine
zusammenhängende Website zu machen ist das File `_site.yml`
verantwortlich. Die Einstiegsseite wird in `index.Rmd` definiert.

### Rmd Editieren

Um Inhalte zu editieren, öffnet ihr das entsprechende .Rmd file in einem
der Ordner \_infovis, \_prepro, \_rauman, \_statistik,
\_statistik-konsolidierung. Ihr könnt dies wie ein reguläres,
eigenständiges .Rmd File handhaben. Alle Pfade im Dokument sind
*relativ* zum .Rmd File zu verstehen: **Das Working directory ist der
Folder des entsprechenden Rmd Files!!**.

### Rmd Kompilieren

Um das Rmd in Html zu konvertieren (“Kompilieren”) klickt ihr auf “Knit”
oder nutzt die Tastenkombination `Ctr + Shift + K`.

### Änderungen veröffentlichen

Um die Änderungen zu veröffentlichen (für die Studenten sichtbar zu
machen) müsst ihr diese via git auf das Repository “pushen”. Vorher aber
müsst ihr die Änderungen `stage`-en und `commit`-en. Ich empfehle, dass
ihr zumindest zu beginn mit dem RStudio “Git” Fenster arbeitet.

-   `stage`: Setzen eines Häckchens bei “Staged”
-   `commit`: Klick auf den Button “commit”
-   `push`: Click auf den button “Push”

*Achtung*: Um Änderungen, die ihr am .Rmd gemacht habt, sichtbar zu
machen müsst ihr das .Rmd File zuerst kompilieren!

## Anleitung: Listings editieren und veröffentlichen

*(dieser Teil ist eher Advanced und nicht für alle Interessant)*

`distill` verfügt über die Möglichkeit, sogenannte “Collections” zu
machen. Eine *collection* ist eine Sammlung von .Rmd files zu einem
bestimmten Thema, für welche automatisch eine Übersichtsseite (sog.
“Listing”) erstellt wird.

Um eine *collection* zu erstellen:

1.  neuer Ordner mit entsprechendem Namen und vorangestelltem Underscore
    (`_`) im Projektordner erstellen (z.b. \_infovis)

2.  neues Rmd-File mit einem passenden Namen im Projektordner erstellen
    (z.B. `infoVis.Rmd`)

3.  das neue Rmd File mit einem Rmd-YAML Header verstehen mit mindestens
    folgendem Inhalt: `title` und `listing` (siehe unten)

         ---
         title: "InfoVis"      # <- Egal
         listing: infovis      # <- ordnername der collection ohne Underscore
         ---

4.  die Listing in `_site.yml` zugänglich machen:

         navbar:
           right:
             - text: "InfoVis1"     # <- Egal
               href: InfoVis.html   # <- Name des Rmd files mit der Endung .html

<!--radix_placeholder_site_after_body-->
<!--/radix_placeholder_site_after_body-->

<!--radix_placeholder_navigation_after_body-->
<div class="distill-site-nav distill-site-footer">
<div class = "footer">
  <img src="zhaw_lsfm_iunr_weiss.png" alt="ZHAW LSFM Logo"></img>
  
  <p>These Materials are created by variouse authors for the Course Research Methods and are licensed under Creative Commons Attribution 4.0 International License.</p> 
  
  <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png"></img></a>

</div>
</div>
<!--/radix_placeholder_navigation_after_body-->
