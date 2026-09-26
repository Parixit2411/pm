# Scripts

Start and stop the local Dockerized app.

## Files

- `start.sh` / `stop.sh` — macOS and Linux
- `start.ps1` / `stop.ps1` — Windows PowerShell
- `start.bat` / `stop.bat` — Windows cmd wrappers around the PowerShell scripts

## Usage

From the project root:

```bash
./scripts/start.sh
./scripts/stop.sh
```

```powershell
.\scripts\start.ps1
.\scripts\stop.ps1
```

Requires Docker and a root `.env` file. App listens on http://localhost:8000.
