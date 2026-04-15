# ==============================================================================
# Nom du script  : inventaire-systeme.ps1
# Auteur         : Younes Ziani
# Date           : 2026-04-14
# Version        : 1.0
# Description    : Génère un rapport d'inventaire matériel et système complet
# Usage          : .\inventaire-systeme.ps1
# Prérequis      : PowerShell 5.1+ / Windows 10+
# ==============================================================================

# ── CONFIGURATION ──────────────────────────────────────────────────────────────
# Dossier où le rapport sera sauvegardé
$DossierRapport = "$env:USERPROFILE\Desktop"
$DateFichier    = Get-Date -Format "yyyyMMdd_HHmm"
$FichierRapport = "$DossierRapport\inventaire_$DateFichier.txt"

# ── FONCTIONS ──────────────────────────────────────────────────────────────────
function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ligne = "[$timestamp] [$Type] $Message"
    Write-Host $ligne -ForegroundColor $(
        if ($Type -eq "ERROR") { "Red" }
        elseif ($Type -eq "OK") { "Green" }
        else { "Cyan" }
    )
}

function Write-Rapport {
    param([string]$Texte)
    # Affiche dans le terminal ET écrit dans le fichier
    Write-Host $Texte
    Add-Content -Path $FichierRapport -Value $Texte
}

# ── SCRIPT PRINCIPAL ───────────────────────────────────────────────────────────
Write-Log "Démarrage de l'inventaire système..."

try {
    # Récupération des infos système
    $OS       = Get-CimInstance Win32_OperatingSystem
    $CPU      = Get-CimInstance Win32_Processor
    $RAM      = Get-CimInstance Win32_PhysicalMemory
    $Disques  = Get-PSDrive -PSProvider FileSystem
    $Réseau   = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" }

    # Calcul RAM totale en Go
    $RAMTotaleGB = [math]::Round(($RAM | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)

    # Construction du rapport
    $Separateur = "=" * 60

    Write-Rapport $Separateur
    Write-Rapport "         RAPPORT D'INVENTAIRE SYSTÈME"
    Write-Rapport "         Généré le : $(Get-Date -Format 'dd/MM/yyyy à HH:mm')"
    Write-Rapport $Separateur

    Write-Rapport ""
    Write-Rapport ">>> SYSTÈME D'EXPLOITATION"
    Write-Rapport "    Nom         : $($OS.Caption)"
    Write-Rapport "    Version     : $($OS.Version)"
    Write-Rapport "    Architecture: $($OS.OSArchitecture)"
    Write-Rapport "    Hostname    : $($OS.CSName)"

    Write-Rapport ""
    Write-Rapport ">>> PROCESSEUR"
    Write-Rapport "    Modèle      : $($CPU.Name)"
    Write-Rapport "    Coeurs      : $($CPU.NumberOfCores)"
    Write-Rapport "    Threads     : $($CPU.NumberOfLogicalProcessors)"

    Write-Rapport ""
    Write-Rapport ">>> MÉMOIRE RAM"
    Write-Rapport "    Total       : $RAMTotaleGB Go"

    Write-Rapport ""
    Write-Rapport ">>> DISQUES"
    foreach ($Disque in $Disques) {
        $Libre  = [math]::Round($Disque.Free / 1GB, 2)
        $Total  = [math]::Round(($Disque.Used + $Disque.Free) / 1GB, 2)
        $Utilise = [math]::Round($Disque.Used / 1GB, 2)
        Write-Rapport "    Disque $($Disque.Name): | Total: $Total Go | Utilisé: $Utilise Go | Libre: $Libre Go"
    }

    Write-Rapport ""
    Write-Rapport ">>> RÉSEAU (IPv4)"
    foreach ($IP in $Réseau) {
        Write-Rapport "    Interface   : $($IP.InterfaceAlias)"
        Write-Rapport "    Adresse IP  : $($IP.IPAddress)"
        Write-Rapport "    Masque      : /$($IP.PrefixLength)"
    }

    Write-Rapport ""
    Write-Rapport $Separateur
    Write-Rapport "    Rapport sauvegardé : $FichierRapport"
    Write-Rapport $Separateur

    Write-Log "Inventaire terminé. Rapport disponible sur le Bureau." "OK"
}
catch {
    Write-Log "Erreur : $_" "ERROR"
    exit 1
}