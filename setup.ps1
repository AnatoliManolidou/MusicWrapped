# Music Wrapped - Quick Setup Script
# Run this script to set up the application

Write-Host "=== Music Wrapped - Setup Script ===" -ForegroundColor Green
Write-Host ""

# Check if Python is installed
Write-Host "Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version
    Write-Host "OK Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found. Please install Python 3.8 or higher." -ForegroundColor Red
    exit 1
}

# Check if MySQL is running
Write-Host "`nChecking MySQL service..." -ForegroundColor Yellow
$mysqlService = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue
if ($mysqlService -and $mysqlService.Status -eq "Running") {
    Write-Host "OK MySQL is running" -ForegroundColor Green
} else {
    Write-Host "✗ MySQL is not running. Please start MySQL service." -ForegroundColor Red
    Write-Host "  You can start it with: Start-Service MySQL80 (or your MySQL service name)" -ForegroundColor Yellow
    exit 1
}

# Create virtual environment if it doesn't exist
if (-not (Test-Path "venv")) {
    Write-Host "`nCreating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "OK Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "`nOK Virtual environment already exists" -ForegroundColor Green
}

# Activate virtual environment
Write-Host "`nActivating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"
Write-Host "OK Virtual environment activated" -ForegroundColor Green

# Install dependencies
Write-Host "`nInstalling dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt
Write-Host "OK Dependencies installed" -ForegroundColor Green

# Configuration reminder
Write-Host "`n=== IMPORTANT: Database Configuration ===" -ForegroundColor Cyan
Write-Host "Create a .env file with your MySQL credentials:" -ForegroundColor Yellow
Write-Host "  1. Copy .env.example to .env" -ForegroundColor White
Write-Host "  2. Edit .env and set DB_PASSWORD to your MySQL password" -ForegroundColor White
Write-Host ""
Write-Host "Example commands:" -ForegroundColor Yellow
Write-Host "  Copy-Item .env.example .env" -ForegroundColor White
Write-Host "  notepad .env" -ForegroundColor White
Write-Host ""

# Database setup reminder
Write-Host "=== Database Setup ===" -ForegroundColor Cyan
Write-Host "Import the database using the SQL files in the database folder:" -ForegroundColor Yellow
Write-Host "  mysql -u root -p < database\dbdump.sql" -ForegroundColor White
Write-Host "  mysql -u root -p < database\users.sql" -ForegroundColor White
Write-Host "  mysql -u root -p < database\add_user_roles.sql" -ForegroundColor White
Write-Host "  mysql -u root -p < database\database_additions.sql" -ForegroundColor White
Write-Host ""

Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host "To run the application:" -ForegroundColor Yellow
Write-Host "  1. Create and configure .env file with your database password" -ForegroundColor White
Write-Host "  2. Run: python app.py" -ForegroundColor White
Write-Host "  3. Open browser: http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "Login credentials:" -ForegroundColor Yellow
Write-Host "  End User: vinylcollector / password123" -ForegroundColor White
Write-Host "  Content Manager: maria_bel / Maria_It3 " -ForegroundColor White
Write-Host ""

