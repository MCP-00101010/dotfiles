$ErrorActionPreference = "Stop"

Write-Host "chezmoi version:" -ForegroundColor Cyan
chezmoi --version

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Initialize this directory as the local dotfiles repo if you have not already."
Write-Host "2. Add your GitHub dotfiles remote as origin."
Write-Host "3. Run chezmoi init --apply against that repo when you are ready."
