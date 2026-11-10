
# Script para analizar y comparar resultados de resiliencia

if (-not (Test-Path "availability-baseline.txt") -or -not (Test-Path "resilience-sample.txt")) {
    Write-Host "Error: Archivos no encontrados." -ForegroundColor Red
    Write-Host "Verifica que existan availability-baseline.txt y resilience-sample.txt"
    exit 1
}

Write-Host ""
Write-Host "========== ANALISIS DE RESILIENCIA ==========" -ForegroundColor Cyan

# LABORATORIO 1.1
Write-Host "`nLINEA BASE (Lab 1.1)" -ForegroundColor Yellow

$baseline = @(Get-Content availability-baseline.txt)
$total_1_1 = $baseline.Count
$success_1_1 = ($baseline | Where-Object { $_ -like '*"status":"SUCCESS"*' }).Count
$errors_1_1 = $total_1_1 - $success_1_1

$avail_1_1 = if ($total_1_1 -gt 0) {
    [math]::Round($success_1_1 / $total_1_1, 4)
} else { 0 }

Write-Host "Total solicitudes: $total_1_1"
Write-Host "SUCCESS: $success_1_1"
Write-Host "Errores: $errors_1_1"
Write-Host "Disponibilidad: $avail_1_1"

# LABORATORIO 1.2
Write-Host "`nCON PATRONES DE RESILIENCIA (Lab 1.2)" -ForegroundColor Yellow

$resilience = @(Get-Content resilience-sample.txt)
$total_1_2 = $resilience.Count

$success_1_2 = ($resilience | Where-Object { $_ -like '*"status":"SUCCESS"*' }).Count
$degraded_1_2 = ($resilience | Where-Object { $_ -like '*"status":"DEGRADED_CACHE"*' }).Count

$total_respuestas = $success_1_2 + $degraded_1_2

$avail_1_2 = if ($total_1_2 -gt 0) {
    [math]::Round($total_respuestas / $total_1_2, 4)
} else { 0 }

Write-Host "Total solicitudes: $total_1_2"
Write-Host "SUCCESS: $success_1_2"
Write-Host "DEGRADED_CACHE: $degraded_1_2"
Write-Host "Errores HTTP 500: $($total_1_2 - $total_respuestas)"
Write-Host "Disponibilidad: $avail_1_2"

# COMPARACION
Write-Host "`n========== COMPARACION ==========" -ForegroundColor Green

$mejora = [math]::Round(($avail_1_2 - $avail_1_1) * 100, 2)

Write-Host "Disponibilidad inicial: $avail_1_1"
Write-Host "Disponibilidad con resiliencia: $avail_1_2"
Write-Host "Mejora obtenida: $mejora %"
Write-Host "Respuestas salvadas por Fallback: $degraded_1_2"

Write-Host "`n========== CONCLUSION ==========" -ForegroundColor Green

if ($avail_1_2 -gt 0.99) {
    Write-Host "IMPLEMENTACION EXITOSA" -ForegroundColor Green
    Write-Host "Disponibilidad alcanzada: aproximadamente 100%"
} else {
    Write-Host "Revisa la implementacion de los patrones." -ForegroundColor Yellow
}
