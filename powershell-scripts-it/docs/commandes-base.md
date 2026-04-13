# Commandes PowerShell essentielles — Jour 1

## Navigation
```powershell
Set-Location C:\Dossier      # cd vers un dossier
Get-Location                 # affiche le dossier actuel
Get-ChildItem                # liste les fichiers (= ls)
```

## Système
```powershell
Get-Process                  # liste les processus en cours
Get-Service                  # liste les services Windows
Get-ComputerInfo             # infos complètes de la machine
Get-PSDrive                  # infos sur les disques
```

## Fichiers
```powershell
Copy-Item source dest        # copier un fichier/dossier
Move-Item source dest        # déplacer
Remove-Item fichier          # supprimer
New-Item -ItemType File      # créer un fichier
New-Item -ItemType Directory # créer un dossier
```

## Utilisateurs locaux
```powershell
Get-LocalUser                # liste les users locaux
New-LocalUser                # créer un user
Remove-LocalUser             # supprimer un user
Add-LocalGroupMember         # ajouter à un groupe
```

## Output et logs
```powershell
Write-Host "texte"           # affiche du texte
Write-Host "ok" -ForegroundColor Green
Out-File -FilePath log.txt   # exporte vers un fichier
Export-Csv -Path data.csv    # exporte vers CSV
```

## Variables et date
```powershell
$maVariable = "valeur"
Get-Date                     # date et heure actuelles
Get-Date -Format "yyyyMMdd"  # format personnalisé
```

## Gestion d'erreurs
```powershell
try {
    # code risqué
} catch {
    Write-Host "Erreur : $_"
}
```

## Git depuis PowerShell
```powershell
git init
git add .
git commit -m "message"
git push
```
