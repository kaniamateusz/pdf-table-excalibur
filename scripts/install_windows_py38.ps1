Write-Host "Creating Python 3.8 virtual environment..."

py -3.8 -m venv venv_py38
.\venv_py38\Scripts\Activate.ps1

Write-Host "Upgrading pip..."
python -m pip install --upgrade pip setuptools wheel

Write-Host "Installing dependencies..."
python -m pip install `
  -r requirements.txt `
  -c constraints.txt

Write-Host "Installation complete."
