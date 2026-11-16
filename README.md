# fetch

A minimal, decentralized package manager for the **Stricta** programming language—written in Stricta and using GitHub repositories and Git tags/SHAs directly as its storage and versioning layer (zero central registry).

---

## Usage

```bash
# Build, test, and install fetch (bootstraps stricta + strlib into .pkgs/)
make
make test
make install PREFIX=~/.local

# Initialize a project manifest (package.lmon)
fetch init myapp

# Add GitHub dependencies (owner/repo[@version] [as alias])
fetch add lucianmarin/strlib
fetch add lucianmarin/stricta-json@1.0.0 as json

# Install dependencies from package.lmon into .pkgs/
fetch install

# Update dependencies to latest matching tags / HEAD
fetch update

# List installed dependencies
fetch list

# Build entry point (resolves package.lmon aliases to .pkgs/<full/path>-<version>/)
fetch build main.str -o myapp
```

---

## Manifest (`package.lmon`) & Imports

```lmon
name: "myapp"
version: "0.1.0"
entry: "main.str"
deps:
    strlib: "lucianmarin/strlib"
    json: "lucianmarin/stricta-json@1.0.0"
```

Import dependencies in `main.str` using the alias keys declared in `package.lmon`:

```python
from strlib import os, sys
import json
```

- **Strict version**: `"owner/repo@1.2.3"` (or semver range `^1.2.0` / `~1.2.0` / commit SHA).
- **Latest**: omit `@version` (`"owner/repo"`) to install the latest tag or `HEAD`.
- Cached clones live in `~/.stricta/cache` (`STRICTA_CACHE` overrides), and all dependencies are materialized once into project-local `.pkgs/<full/path>-<version>/` (e.g. `.pkgs/lucianmarin/strlib-0.1.0/`) with no nested `.pkgs/` directories; `fetch build` resolves `package.lmon` graphs into `-M` module-map flags for `stricta`.
