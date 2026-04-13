# ==============================================================================
# Nom du script  : nom-du-script.ps1
# Auteur         : Younes Ziani
# Date           : 2026-04-13
# Version        : 1.0
# Description    : [Ce que fait le script en une phrase]
# Usage          : .\nom-du-script.ps1
# Prérequis      : PowerShell 5.1+ / Windows 10+
# ==============================================================================

# ── CONFIGURATION ──────────────────────────────────────────────────────────────
$Variable1 = "valeur"

# ── FONCTIONS ──────────────────────────────────────────────────────────────────
function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] [$Type] $Message"
    Write-Host $logLine -ForegroundColor $(if ($Type -eq "ERROR") { "Red" } elseif ($Type -eq "OK") { "Green" } else { "Cyan" })
}

# ── SCRIPT PRINCIPAL ───────────────────────────────────────────────────────────
Write-Log "Démarrage du script..."

try {
    # Ton code ici

    Write-Log "Script terminé avec succès." "OK"
}
catch {
    Write-Log "Erreur : $_" "ERROR"
    exit 1
}
