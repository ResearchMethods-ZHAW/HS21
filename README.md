
## Instructions on how to work on this repo:

### Step 1 (once a year): Initialize the new reposoritory

Before the semester starts, make a copy of last years repo within the Organisation "ModulResearchMethods":

- On the website (github.zhaw.ch): create a new repo in the Organisation "ModulResearchMethods" (don't initialize a readme)


- On your harddrive
  - with the commandline interface:
    - `git init` in a local, empty directory
    - `git remote add lastyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXX.git` (last year's repo)
    - `git remote add thisyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXY.git` (this year's repo)
    - `git pull lastyear master`
    - `git push thisyear master`
  - with the RStudio Git-GUI:
    - tbd

### Step 2 (once a year): Fork the repo to your own account

On github: click on the "fork" button to get a copy of the repo on your own user account
On your harddrive:

- with the commandline interface:
  - `git init` in a local, empty directory
  - `git remote add myfork git@github.zhaw.ch:username/Unterrichtsunterlagen_HSXY.git`
  - `git pull myfork master`
- with the RStudio Git-GUI:
  - tbd


### Step 3 (throughout the semester): Make locoal changes to your repo

- Work on your files as you would normally. 
- Make commits from time to time.
  - with the commandline interface:
    - `git add -A` (stages all changes)
    - `git commit -m "the changes you made"` (commits all changes)
-  Push them to **your copy of the repo** (`myfork`) from time to time
  - with the commandline interface: `git push myfork master`
  - with the RStudio Git-GUI: tbd
  
### Step 4 (periodically): Send the changes to the main document

Once you have changes that should be included in the main document, you have to send a "pull request" so that the maintainer of the repo pulls your changes. This is done on github.zhaw.ch

Not that if you now repeat Step 3, these changes will be added to your pull request automatically.

### Step 5 (periodically): Pull the latest changes from the main document

If other people have worked on the document, it is important that you allways have the latest version (to avoid conflicts).

In your local git-repo:

- with the commandline interface:
- `git remote add thisyear git@github.zhaw.ch:ModulResearchMethods/Unterrichtsunterlagen_HSXY.git `
- `git pull thisyear master`

- with the RStudio Git-GUI:
  - tbd

### Repeat steps 3 to 5 while you are working on the document.


