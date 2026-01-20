# Migration from Poetry to UV

This project has been migrated from Poetry to UV for faster dependency management and installation.

## What Changed

- `pyproject.toml` now uses standard PEP 621 format instead of Poetry-specific format
- Build backend changed from `poetry-core` to `hatchling`
- `poetry.lock` replaced with `uv.lock`
- All CI/CD workflows updated to use UV
- Dockerfile updated to use UV


### Installation

## Using Docker
```bash
# Build image
docker build -t sherlock/sherlock:latest .

# Run Image
docker run --rm sherlock/sherlock:latest [any_username]
```

## For Developers

### Prerequisites

Install UV:
```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Or with pip
pip install uv
```

### Common Commands

| Poetry Command | UV Equivalent |
|---------------|---------------|
| `poetry install` | `uv sync` |
| `poetry install --with dev` | `uv sync --extra dev` |
| `poetry add <package>` | `uv add <package>` |
| `poetry add --group dev <package>` | `uv add --dev <package>` |
| `poetry remove <package>` | `uv remove <package>` |
| `poetry run <command>` | `uv run <command>` |
| `poetry shell` | `source .venv/bin/activate` (or `.venv\Scripts\activate` on Windows) |
| `poetry lock` | `uv lock` |
| `poetry build` | `uv build` |
| `poetry publish` | `uv publish` |

### Setting Up Development Environment

1. Clone the repository
2. Install dependencies:
   ```bash
   uv sync --extra dev
   ```
3. Run tests:
   ```bash
   uv run pytest
   ```
4. Run linting:
   ```bash
   uv run ruff check
   ```

### Using Tox

Tox now uses `tox-uv` plugin for faster virtual environment creation:

### Activate venv to avoid any system issues
```bash
   .\.venv\Scripts\activate 
```


```bash
# Install tox with UV support
uv pip install tox tox-uv

# Run tests
tox

# Run linting
tox -e lint

# Run specific Python version
tox -e py312
```

### Benefits of UV

- **Faster**: 10-100x faster than pip/poetry for dependency resolution and installation
- **Reliable**: Uses the same dependency resolver as pip, but with better error messages
- **Standard**: Uses standard `pyproject.toml` format (PEP 621)
- **Compatible**: Works with existing tools and workflows
- **Lockfile**: `uv.lock` provides reproducible installations

## Troubleshooting

### "Cannot find uv.lock"

Run `uv lock` to generate the lockfile:
```bash
uv lock
```

### "Module not found" errors

Sync your environment:
```bash
uv sync --extra dev
```

### Need to use Poetry?

While we've migrated to UV, you can still use Poetry if needed by converting the `pyproject.toml` back. However, UV is recommended for better performance.

## More Information

- [UV Documentation](https://docs.astral.sh/uv/)
- [PEP 621 - Storing project metadata in pyproject.toml](https://peps.python.org/pep-0621/)



