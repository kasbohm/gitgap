# gitgap
Sync git repositories between local repo and repo behind an airgapped server using git bundle. 
## Installation
### Pre-requisites
For use with TSD, you need a TSD import link set up with secret_challenge https://selfservice.tsd.usit.no/project/import-links.
Gitgap can be used on other airgapped servers, or syncing repos using sneaker-net. To do so, replace the code in git-export with whatever copy/move command you need. 
### Outside airgapped server
1. Add the gitgap repo to your project:

```bash
bash <(curl -s https://raw.githubusercontent.com/kasbohm/gitgap/master/setup.sh)
```
Alterantively do manual clone:  
```bash
git clone --depth=1 --branch=main https://github.com/kasbohm/gitgap.git && rm -rf gitgap/.git && sh gitgap/setup.sh
```
2. Enter details in config.env (see config.env.example)

3. Commit changes:
```bash
git add gitgap && git commit -m "Add gitgap"
```
3. Export repo to airgapped server:
```
git export
```

### Inside airgapped server
Clone repo from the bundle you just exported:
```bash
git clone <path-to-bundle>
cd <repo>
```

Enter details in config.env again (we don't commit this file), then run:  
```
bash gitgap/setup.sh
```


## Usage
### World -> TSD
1. In repo outside: ```git export```  
Git bundles all branhces and exports to TSD using import link.

 
2. Then in repo inside: ```git import```  
Pulls all branches from the bundle that has newer commits than the current repo.

### TSD -> WORLD
1. In repo on TSD: ```git export```  
Git bundles all brances and exports from TSD by moving the bundle to export folder TSD_EXPORTDIR.

2. Download bundle using https://data.tsd.usit.no andn place in WORLD_IMPORTDIR  
3. In repo outside: ```git import```  
Pulls all branches from the bundle that has newer commits than the current repo.
