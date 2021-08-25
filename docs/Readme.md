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
    -   [Distill](#distill)
    -   [Renv](#renv)
-   [Schritt für Schritt Anleitung](#schritt-für-schritt-anleitung)
    -   [R, RStudio und Git
        installieren](#r-rstudio-und-git-installieren)
    -   [Git konfigurieren](#git-konfigurieren)
    -   [Repo Klonen](#repo-klonen)
    -   [Notwendige Packages
        installieren](#notwendige-packages-installieren)
    -   [Inhalte editieren](#inhalte-editieren)
-   [Dependencies](#dependencies)

## Allgemeines

### Distill

Im Kurs Research Methods verwenden wir seit einigen Jahren RMarkdown um
die R Unterlagen für die Studenten bereit zu stellen. Bis und mit HS2020
haben wir dafür [`bookdown`](https://bookdown.org/yihui/blogdown/)
verwendet, im HS2021 wollen wir zu
[`distill`](https://rstudio.github.io/distill/) wechseln. Grund für
diesen Wechsel ist folgender: Mit Bookdown müssen bei Änderungen jeweils
*alle* .Rmd-Files neu kompiliert werden, was unter umständen sehr lange
dauern kann. Mit `distill` ist jedes .Rmd File wie ein eigenes kleines
Projekt und kann eigenständig kompiliert werden.

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

## Schritt für Schritt Anleitung

### R, RStudio und Git installieren

*(wer dies bereits gemacht hat, kann diesen Schritt überspringen)*

Wer Lokal auf seinem eingenen PC arbeiten will, muss eine aktuell
version von R, RStudio und Git installieren. Siehe dazu folgende
Anleitungen:

-   [Install or upgrade R and
    RStudio](https://happygitwithr.com/install-r-rstudio.html)
-   [Install Git](https://happygitwithr.com/install-git.html)

### Git konfigurieren

*(wer dies bereits gemacht hat, kann diesen Schritt überspringen)*

Nach der Installation muss git konfiguriert werden. Siehe dazu folgende
Kapitel:

-   [Introduce yourself to
    Git](https://happygitwithr.com/hello-git.html)
-   [Cache credentials for
    HTTPS](https://happygitwithr.com/credential-caching.html)

### Repo Klonen

Um die ganzen \*.Rmd Files lokal bearbeiten zu können, muss das
Repository geklont werden. Mit RStudio ist dies sehr einfach, siehe dazu
nachstehende Anleitung. Als Repo-URL folgendes einfügen:
`https://github.zhaw.ch/ModulResearchMethods/Unterrichtsunterlagen_HS20.git`

-   [New RStudio Project via git
    clone](https://happygitwithr.com/new-github-first.html#new-rstudio-project-via-git)

### Notwendige Packages installieren

Wie bereits erwähnt, verwenden wir im Projekt `renv`.

-   Installiert dieses Package mit `install.packages("renv")`
-   Installiert alle notwendigen Packages mit `renv::restore()`

### Inhalte editieren

Um Inhalte zu editieren, öffnet ihr das entsprechende .Rmd file in einem
der Ordner \_infovis, \_prepro, \_rauman, \_statistik,
\_statistik-konsolidierung. Ihr könnt dies wie ein reguläres,
eigenständiges .Rmd File handhaben. Alle Pfade im Dokument sind
*relativ* zum .Rmd File zu verstehen: **Das Working directory ist der
Folder des entsprechenden Rmd Files!!**. D.h. ihr müsst sicherstellen,
dass die "knit Di

![](knit-dir.png)

Um das Rmd File zu kompilieren

## Dependencies

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## 
    ## Attaching package: 'jsonlite'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     flatten

| Package           | Version    |
|:------------------|:-----------|
| AER               | 1.2-9      |
| AICcmodavg        | 2.3-1      |
| AlgDesign         | 1.2.0      |
| Amelia            | 1.8.0      |
| DBI               | 1.1.1      |
| DT                | 0.18       |
| DataEditR         | 0.1.3      |
| FNN               | 1.1.3      |
| FSA               | 0.9.1      |
| FactoMineR        | 2.4        |
| Formula           | 1.2-4      |
| GGally            | 2.1.2      |
| Hmisc             | 4.5-0      |
| KernSmooth        | 2.23-20    |
| LearnBayes        | 2.15.1     |
| MASS              | 7.3-54     |
| Matrix            | 1.3-4      |
| MatrixModels      | 0.5-0      |
| MuMIn             | 1.43.17    |
| R.cache           | 0.15.0     |
| R.methodsS3       | 1.8.1      |
| R.oo              | 1.24.0     |
| R.utils           | 2.10.1     |
| R6                | 2.5.1      |
| RColorBrewer      | 1.1-2      |
| RNeXML            | 2.4.5      |
| Rcpp              | 1.0.7      |
| RcppArmadillo     | 0.10.6.0.0 |
| RcppEigen         | 0.3.3.9.1  |
| Rtsne             | 0.15       |
| SparseM           | 1.81       |
| TH.data           | 1.0-10     |
| TMB               | 1.7.20     |
| VGAM              | 1.1-5      |
| XML               | 3.99-0.7   |
| abind             | 1.4-5      |
| ade4              | 1.7-17     |
| adegenet          | 2.1.4      |
| adegraphics       | 1.0-15     |
| adephylo          | 1.1-11     |
| adespatial        | 0.3-14     |
| agricolae         | 1.3-5      |
| ape               | 5.5        |
| askpass           | 1.1        |
| assertthat        | 0.2.1      |
| backports         | 1.2.1      |
| base64enc         | 0.1-3      |
| betareg           | 3.1-4      |
| biscale           | 0.2.0      |
| bit               | 4.0.4      |
| bit64             | 4.0.5      |
| blob              | 1.2.2      |
| bookdown          | 0.23       |
| boot              | 1.3-28     |
| brio              | 1.1.2      |
| broom             | 0.7.9      |
| bslib             | 0.2.5.1    |
| cachem            | 1.0.6      |
| callr             | 3.7.0      |
| car               | 3.0-11     |
| carData           | 3.0-4      |
| cellranger        | 1.1.0      |
| checkmate         | 2.0.0      |
| class             | 7.3-19     |
| classInt          | 0.4-3      |
| cli               | 3.0.1      |
| clipr             | 0.7.1      |
| cluster           | 2.1.2      |
| cocorresp         | 0.4-3      |
| coda              | 0.19-4     |
| codetools         | 0.2-18     |
| colorspace        | 2.0-2      |
| colourpicker      | 1.1.0      |
| combinat          | 0.0-8      |
| commonmark        | 1.7        |
| conquer           | 1.0.2      |
| cowplot           | 1.1.1      |
| cpp11             | 0.3.1      |
| crayon            | 1.4.1      |
| crosstalk         | 1.1.1      |
| curl              | 4.3.2      |
| data.table        | 1.14.0     |
| dave              | 2.0        |
| dbplyr            | 2.1.1      |
| deldir            | 0.2-10     |
| dichromat         | 2.0-0      |
| diffr             | 0.1        |
| digest            | 0.6.27     |
| distill           | 1.2.4      |
| downlit           | 0.2.1      |
| dplyr             | 1.0.7      |
| dtplyr            | 1.1.0      |
| dunn.test         | 1.3.5      |
| e1071             | 1.7-8      |
| ellipse           | 0.4.2      |
| ellipsis          | 0.3.2      |
| evaluate          | 0.14       |
| expm              | 0.999-6    |
| fansi             | 0.5.0      |
| farver            | 2.1.0      |
| fasterize         | 1.0.3      |
| fastmap           | 1.1.0      |
| flashClust        | 1.01-2     |
| flexmix           | 2.3-17     |
| forcats           | 0.5.1      |
| foreign           | 0.8-81     |
| fs                | 1.5.0      |
| gargle            | 1.2.0      |
| gclus             | 1.3.2      |
| gdata             | 2.18.0     |
| generics          | 0.1.0      |
| geojsonsf         | 2.0.1      |
| geometries        | 0.2.0      |
| geosphere         | 1.5-10     |
| ggExtra           | 0.9        |
| ggfortify         | 0.4.12     |
| ggplot2           | 3.3.5      |
| ggrepel           | 0.9.1      |
| glmmML            | 1.1.1      |
| glue              | 1.4.2      |
| gmodels           | 2.18.1     |
| googledrive       | 2.0.0      |
| googlesheets4     | 1.0.0      |
| gridExtra         | 2.3        |
| gstat             | 2.0-7      |
| gtable            | 0.3.0      |
| gtools            | 3.9.2      |
| haven             | 2.4.3      |
| here              | 1.0.1      |
| hier.part         | 1.0-6      |
| highr             | 0.9        |
| hms               | 1.1.0      |
| htmlTable         | 2.2.1      |
| htmltools         | 0.5.1.1    |
| htmlwidgets       | 1.5.3      |
| httpuv            | 1.6.2      |
| httr              | 1.4.2      |
| ids               | 1.0.1      |
| igraph            | 1.2.6      |
| intervals         | 0.15.2     |
| isoband           | 0.2.5      |
| janitor           | 2.1.0      |
| jpeg              | 0.1-9      |
| jquerylib         | 0.1.4      |
| jsonify           | 1.2.1      |
| jsonlite          | 1.7.2      |
| jtools            | 2.1.3      |
| klaR              | 0.6-15     |
| knitr             | 1.33       |
| labdsv            | 2.0-1      |
| labeling          | 0.4.2      |
| labelled          | 2.8.0      |
| languageR         | 1.5.0      |
| later             | 1.3.0      |
| lattice           | 0.20-44    |
| latticeExtra      | 0.6-29     |
| lazyeval          | 0.2.2      |
| leafem            | 0.1.6      |
| leaflet           | 2.0.4.1    |
| leaflet.providers | 1.9.0      |
| leafsync          | 0.1.0      |
| leaps             | 3.1        |
| lifecycle         | 1.0.0      |
| lme4              | 1.1-27.1   |
| lmerTest          | 3.1-3      |
| lmodel2           | 1.7-3      |
| lmtest            | 0.9-38     |
| lubridate         | 1.7.10     |
| lwgeom            | 0.2-7      |
| magrittr          | 2.0.1      |
| maptools          | 1.1-1      |
| markdown          | 1.1        |
| matrixStats       | 0.60.1     |
| memoise           | 2.0.0      |
| mgcv              | 1.8-36     |
| mime              | 0.11       |
| miniUI            | 0.1.1.1    |
| minqa             | 1.2.4      |
| mnormt            | 2.0.2      |
| modelr            | 0.1.8      |
| modeltools        | 0.2-23     |
| move              | 4.0.6      |
| multcomp          | 1.4-17     |
| multcompView      | 0.1-8      |
| munsell           | 0.5.0      |
| mvtnorm           | 1.1-2      |
| nlme              | 3.1-152    |
| nloptr            | 1.2.2.2    |
| nlstools          | 1.0-2      |
| nnet              | 7.3-16     |
| numDeriv          | 2016.8-1.1 |
| openssl           | 1.4.4      |
| openxlsx          | 4.2.4      |
| packrat           | 0.7.0      |
| pander            | 0.6.4      |
| pbkrtest          | 0.5.1      |
| permute           | 0.9-5      |
| phylobase         | 0.8.10     |
| pillar            | 1.6.2      |
| pixmap            | 0.4-12     |
| pkgconfig         | 2.0.3      |
| plotly            | 4.9.4.1    |
| plotrix           | 3.8-1      |
| plyr              | 1.8.6      |
| png               | 0.1-7      |
| polspline         | 1.1.19     |
| prettyunits       | 1.1.1      |
| processx          | 3.5.2      |
| progress          | 1.2.2      |
| promises          | 1.2.0.1    |
| proxy             | 0.4-26     |
| ps                | 1.6.0      |
| pscl              | 1.5.5      |
| psych             | 2.1.6      |
| purrr             | 0.3.4      |
| quantreg          | 5.86       |
| questionr         | 0.7.4      |
| rapidjsonr        | 1.2.0      |
| rappdirs          | 0.3.3      |
| raster            | 3.4-13     |
| readr             | 2.0.1      |
| readxl            | 1.3.1      |
| rematch           | 1.0.1      |
| rematch2          | 2.1.2      |
| renv              | 0.14.0     |
| reprex            | 2.0.1      |
| reshape           | 0.8.8      |
| reshape2          | 1.4.4      |
| rgdal             | 1.5-23     |
| rgl               | 0.107.14   |
| rhandsontable     | 0.3.8      |
| rio               | 0.5.27     |
| rlang             | 0.4.11     |
| rmarkdown         | 2.10       |
| rms               | 6.2-0      |
| rncl              | 0.8.4      |
| rpart             | 4.1-15     |
| rprojroot         | 2.0.2      |
| rsconnect         | 0.8.24     |
| rstudioapi        | 0.13       |
| rvest             | 1.0.1      |
| s2                | 1.0.6      |
| sandwich          | 3.0-1      |
| sass              | 0.4.0      |
| scales            | 1.1.1      |
| scatterplot3d     | 0.3-41     |
| sciplot           | 1.2-0      |
| segmented         | 1.3-4      |
| selectr           | 0.4-2      |
| seqinr            | 4.2-8      |
| sf                | 1.0-2      |
| sfheaders         | 0.4.0      |
| shiny             | 1.6.0      |
| shinyBS           | 0.61       |
| shinyWidgets      | 0.6.0      |
| shinyjs           | 2.0.0      |
| shinythemes       | 1.2.0      |
| snakecase         | 0.11.0     |
| sourcetools       | 0.1.7      |
| sp                | 1.4-5      |
| spData            | 0.3.10     |
| spacetime         | 1.2-5      |
| spdep             | 1.1-8      |
| stars             | 0.5-3      |
| stringi           | 1.7.3      |
| stringr           | 1.4.0      |
| styler            | 1.5.1      |
| survival          | 3.2-13     |
| sys               | 3.4        |
| tibble            | 3.1.3      |
| tidyr             | 1.1.3      |
| tidyselect        | 1.1.1      |
| tidyverse         | 1.3.1      |
| tinytex           | 0.33       |
| tmap              | 3.3-2      |
| tmaptools         | 3.1-1      |
| tmvnsim           | 1.0-2      |
| tree              | 1.0-41     |
| tzdb              | 0.1.2      |
| units             | 0.7-2      |
| unmarked          | 1.1.1      |
| utf8              | 1.2.2      |
| uuid              | 0.1-4      |
| vctrs             | 0.3.8      |
| vegan             | 2.5-7      |
| vegan3d           | 1.1-2      |
| viridis           | 0.6.1      |
| viridisLite       | 0.4.0      |
| vroom             | 1.5.4      |
| webshot           | 0.5.2      |
| wesanderson       | 0.3.6      |
| whisker           | 0.4        |
| widgetframe       | 0.3.1      |
| withr             | 2.4.2      |
| wk                | 0.5.0      |
| xfun              | 0.25       |
| xml2              | 1.3.2      |
| xtable            | 1.8-4      |
| xts               | 0.12.1     |
| yaml              | 2.2.1      |
| zip               | 2.2.0      |
| zoo               | 1.8-9      |

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
