
Das Modul „Research Methods“ vermittelt vertiefte Methodenkompetenzen für praxisorientiertes und angewandtes wissenschaftliches Arbeiten im Fachbereich „Umwelt und Natürliche Ressourcen“ auf MSc-Niveau. Die Studierenden erarbeiten sich vertiefte Methodenkompetenzen für die analytische Betrachtung der Zusammenhänge im Gesamtsystem „Umwelt und Natürliche Ressourcen“. Die Studierenden erlernen die methodischen Kompetenzen, auf denen die nachfolgenden Module im MSc Programm UNR aufbauen. Das Modul vermittelt einerseits allgemeine, fächerübergreifende methodische Kompetenzen (z.B. Wissenschaftstheorie, computer-gestützte Datenverar-beitung und Statistik).

Auf dieser Plattform (RStudio Connect) werden die Unterlagen für die R-Übungsteile bereitgestellt. Es werden sukzessive sowohl Demo-Files, Aufgabenstellungen und Lösungen veröffentlicht.



## How to work on this repo:

### Step 1: Initialize the new reposoritory

When the semster starts, make a clone of last years repo:

- On the website (github.zhaw.ch): creata a new repo in the Organisation "ModulResearchMethods" (don't initialize a readme)


- On your harddrive
  - with the commandline interface:
    - `git init` in a local, empty directory
    - `git remote add lastyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXX.git` (last year's repo)
    - `git remote add thisyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXY.git` (this year's repo)
    - `git pull lastyear master`
    - `git push thisyear master`
  - with the RStudio Git-GUI:
    - tbd

### Step 2: Fork the repo to your own account

On github: click on the "fork" button to get a copy of the repo on your own user account
On your harddrive:

- with the commandline interface:
  - `git init` in a local, empty directory
  - `git remote add myfork git@github.zhaw.ch:username/Unterrichtsunterlagen_HSXY.git`
  - `git pull myfork master`
- with the RStudio Git-GUI:
  - tbd


### Step 3: Make locoal changes to your repo

- Work on your files as you would normally. 
- Make commits from time to time.
  - with the commandline interface:
    - `git add -A` (stages all changes)
    - `git commit -m "the changes you made"` (commits all changes)
-  Push them to **your copy of the repo** (`myfork`) from time to time
  - with the commandline interface: `git push myfork master`
  - with the RStudio Git-GUI: t.b.d.
  
### Step 4: Send the changes to the main document

Once you have changes that should be included in the main document, you have to send a "pull request" so that the maintainer of the repo pulls your changes. This is done on github.zhaw.ch


### Step 5: Pull the latest changes from the main document

If other people have worked on the document, it is important that you allways have the latest version (to avoid conflicts).

In your local git-repo:

- with the commandline interface:
- `git remote add thisyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXY.git `
- `git pull thisyear master`

- with the RStudio Git-GUI:
  - tbd

### Repeat steps 4 and 5 while you are working on the document.


