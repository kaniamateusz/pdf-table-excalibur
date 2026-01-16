# Excalibur (Camelot) – Windows Setup with Python 3.8
Repository shows how to configure (on Windows) and use the excalibur library to extract data from pdf tables to text format files.

This project requires **Python 3.8** due to compatibility constraints between
Excalibur, Camelot, and PDF-related dependencies.  
Newer Python versions (e.g. 3.12 / 3.13) are **not compatible without patching**.

This README describes how to:
- keep a newer Python version (e.g. 3.13) as default
- install Python 3.8 side-by-side on Windows
- create a Python 3.8 virtual environment
- install compatible package versions
- configure Ghostscript
- run Excalibur successfully

---

### 1. Verify if Python 3.8 is installed

Open a **new Command Prompt** and run:
```
py -0
```

If Python 3.8 is installed go to step 3, if not run installation.

### 2. Install Python 3.8 (side-by-side)

Version 3.8.10 is the last Python 3.8 release and is recommended.
Download **Python 3.8.10 (64-bit)** from the official source:

https://www.python.org/downloads/release/python-3810/

#### Installation options (important):
- ✔ Add Python 3.8 to PATH
- ✔ Install launcher for all users
- ✔ Install pip
- ❌ Do NOT set Python 3.8 as the default

This keeps your system default Python (e.g. 3.13) unchanged.

---

### 2. Verify installed Python versions

Verify versions running `py -0`

Expected example output:
```
-V:3.13 *        Python 3.13 (64-bit)
-V:3.10          Python 3.10 (64-bit)
-V:3.8           Python 3.8 (64-bit)
 ```

---

### 3. Create Python 3.8 virtual environment

From the project directory create virtual environment for Python 3.8:
```
py -3.8 -m venv venv_py38
```

Activate it:
```
venv_py38\Scripts\activate
 ```

Verify:
```
python --version
```
And you should see `Python 3.8.10`

---

### 4. Upgrade packaging tools inside the venv

```
python -m pip install --upgrade pip setuptools wheel
```

---

### 5. Install compatible Python packages

Run with:
```
python -m pip install -r requirements.txt
```

---

### 6. Install Ghostscript (Windows)

Excalibur and Camelot require **Ghostscript** to render PDF pages.  
Installing the Python package `ghostscript` from PyPI is **not sufficient** — the system-level Ghostscript binary must be installed and available on `PATH`.

#### Download Ghostscript

Download the **64-bit Windows installer** from the official Ghostscript website:

https://www.ghostscript.com/releases/gsdnld.html

Choose the latest stable **GPL Ghostscript for Windows (64-bit)**.

The required executable is located in: `C:\Program Files\gs\gs10.xx.x\bin\gswin64c.exe`

#### Add Ghostscript to PATH (Critical Step)

Camelot detects Ghostscript **only via PATH**.  
If this step is skipped, Camelot will report that Ghostscript is not installed.

#### Steps:
1. Press **Win + R**, type `sysdm.cpl`, press Enter
2. Go to **Advanced** → **Environment Variables**
3. Under **System variables**, select `Path` → **Edit**
4. Click **New** and add: `C:\Program Files\gs\gs10.xx.x\bin`

#### Restart the Terminal

After modifying PATH:
- Close **all** Command Prompt / PowerShell windows
- Open a **new** terminal
- Activate your virtual environment again

#### Verify Ghostscript Installation

Run the following commands:

```
where gswin64c
gswin64c -version
```

---

### 2. Modify package

There are two needed changes in `project_root\venv_py38\lib\site-packages\camelot\core.py` file:

#### in the line 740:

Remove `encoding` input parameter from the pandas function `to_excel()`

Replace the code:
```
table.df.to_excel(writer, sheet_name=sheet_name, encoding="utf-8")
```

With correct code:
```
table.df.to_excel(writer, sheet_name=sheet_name)
```

#### in the line 741:

Replace pandas `save()` method with `ExcelWriter()`:

In newer pandas (≥ 1.2, and definitely ≥ 1.5 / 2.x): `ExcelWriter.save()` was removed and replaced with `context manager (with ExcelWriter(...) as writer:)`

Replace the code:
```
writer = pd.ExcelWriter(filepath)
for table in self._tables:
    sheet_name = f"page-{table.page}-table-{table.order}"
    table.df.to_excel(writer, sheet_name=sheet_name)
writer.save()
```

With correct code:
```
with pd.ExcelWriter(filepath, engine="openpyxl") as writer:
    for table in self._tables:
        sheet_name = f"page-{table.page}-table-{table.order}"
        table.df.to_excel(writer, sheet_name=sheet_name)
```

### 7. Initialize and start Excalibur database

```
excalibur initdb
excalibur webserver
```

Then type in browser: 
```
http://127.0.0.1:5000
```

And you can easily upload and extract tables from pdf's to the text format!

### 8. Steps to properly run web excalibur editor

<img width="1312" height="959" alt="Image" src="https://github.com/user-attachments/assets/bbd44ca2-84e8-4797-88f0-e5183ac5bf0f" />

---

## Troubleshooting (Windows)

This section documents **real issues encountered during setup** and their solutions.

---

### 1. Ghostscript is not installed (even though it is)

**Cause**
Ghostscript is installed, but its `bin` directory is **not on PATH**.  
Camelot does **not** search the registry or Program Files.

**Fix**
1. Locate Ghostscript binary:
```
 C:\Program Files\gs\gs10.xx.x\bin\gswin64c.exe
```
2. Add this directory to **System PATH**
3. Restart all terminals (!!)
4. Verify:
```
 where gswin64c
 gswin64c -version
```




