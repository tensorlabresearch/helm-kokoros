# helm-kokoros

Helm chart and CUDA image pipeline for Kokoros in the `tensorlabresearch` organization.

## What this repo publishes

- OCI chart (primary): `oci://ghcr.io/tensorlabresearch/charts/kokoros`
- GitHub Pages chart repo (mirror): `https://tensorlabresearch.github.io/helm-kokoros`
- Container image: `ghcr.io/tensorlabresearch/kokoros`

## Install

### From OCI (recommended)

```bash
helm install kokoros oci://ghcr.io/tensorlabresearch/charts/kokoros \
  --version 0.1.0
```

### From GitHub Pages index

```bash
helm repo add tensorlab-kokoros https://tensorlabresearch.github.io/helm-kokoros
helm repo update
helm install kokoros tensorlab-kokoros/kokoros --version 0.1.0
```

## Release model

- Push a semver Git tag like `v0.1.0` to build/publish the CUDA image to GHCR.
- Merge chart changes to `main` with bumped `charts/kokoros/Chart.yaml` version.
- `chart-release.yml` will lint/template, publish index/releases to `gh-pages`, and push changed chart packages to GHCR OCI.

## Notes

- Default chart values assume CUDA and request `nvidia.com/gpu: 1`.
- Model files are preloaded via init container to a persistent models volume.
- Checksums are supported and enforced when provided.
