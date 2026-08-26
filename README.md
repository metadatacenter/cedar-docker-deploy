# CEDAR Docker Deployment

[![CI](https://github.com/metadatacenter/cedar-docker-deploy/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/metadatacenter/cedar-docker-deploy/actions/workflows/ci.yml)

Start with the published documentation:

- [Docker Install](https://metadatacenter.readthedocs.io/en/latest/install-docker/overview/)
  is the complete installation and operating guide.
- [Docker Development](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/docker/)
  explains Docker mode and the normal `cedarcli` workflow.
- [Hybrid Development](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/hybrid/)
  explains how native frontend servers run against the Docker backend.

This repository contains the Compose topology used by those workflows. It does not build images and
is not a second deployment manual.

## Compose Projects

| Directory | Responsibility |
| --- | --- |
| `cedar-infrastructure/` | Databases, search, authentication, Redis, and the public nginx router |
| `cedar-microservices/` | The fifteen Java services |
| `cedar-frontend/` | The seven containerized frontend applications |
| `cedar-admin/` | Optional administration tools |

The core projects share the external `cedarnet` network and named volumes prepared by cedarcli.
Their Compose files contain runtime topology only: image construction belongs to
`cedar-docker-build`, and persistent installation values come from the selected CEDAR profile.

For normal operation, use cedarcli so mode ownership, dependency order, image-train selection,
preflight checks, and readiness gates are applied consistently. Direct `docker compose` commands
are useful for inspecting or repairing an individual project, but they bypass those aggregate
safeguards.
