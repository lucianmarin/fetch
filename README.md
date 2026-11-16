# fetch

A minimal, decentralized package manager for the **Stricta** programming language—written in Stricta and using GitHub repositories and Git tags/SHAs directly as its storage and versioning layer (zero central registry).

---

## Usage

```bash
# Build fetch (bootstraps stricta compiler + strlib via git into .stricta/pkgs/lucianmarin/)
make
make test

# Initialize a project manifest (package.lmon)
./fetch init myapp

# Add a GitHub dependency (owner/repo[@version])
./fetch add lucianmarin/stricta-json@1.0.0 as json

# Install dependencies from package.lmon into .pkgs/
./fetch install

# Update dependencies to latest matching GitHub tags
./fetch update

# List installed dependencies
./fetch list

# Build entry point with .pkgs on Stricta's module path
./fetch build main.str -o myapp
```

---

## Manifest (`package.lmon`)

```lmon
name: "myapp"
version: "0.1.0"
entry: "main.str"
deps:
    strlib: "lucianmarin/strlib"
    json: "lucianmarin/stricta-json@1.0.0"
```

- **Strict version**: `"owner/repo@1.2.3"` (or semver range `^1.2.0` / `~1.2.0` / commit SHA).
- **Latest**: omit `@version` (`"owner/repo"`) to install the latest tag or `HEAD`.
- Cached clones live in `~/.stricta/cache` (`STRICTA_CACHE` overrides), and all dependencies are materialized once into project-local `.pkgs/<full/path>-<version>/` (e.g. `.pkgs/lucianmarin/stricta-json-1.0.0/`) with no nested `.pkgs/` directories; `fetch build` resolves `package.lmon` graphs into `-M` module-map flags for `stricta`.
