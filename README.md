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
  --version 0.1.1
```

### From GitHub Pages index

```bash
helm repo add tensorlab-kokoros https://tensorlabresearch.github.io/helm-kokoros
helm repo update
helm install kokoros tensorlab-kokoros/kokoros --version 0.1.1
```

## Quickstart Values

Create a values override that selects a bundle and preloads extra assets:

```yaml
gpu:
  enabled: true
  count: 1
  resourceKey: nvidia.com/gpu

kokoros:
  activeBundle: default

modelPreload:
  enabled: true
  continueOnError: false
  items:
    - id: alt-voices
      url: https://example.com/models/voices-custom.bin
      filename: voices-custom.bin
      targetSubdir: data
      sha256: ""
```

Install with:

```bash
helm install kokoros oci://ghcr.io/tensorlabresearch/charts/kokoros \
  --version 0.1.1 \
  -f values-preload.yaml
```

## Argo CD Examples

- Pages chart repo app: `examples/argocd/pages-application.yaml`
- OCI chart repo app:
  - repository secret: `examples/argocd/oci-repository-secret.yaml`
  - application: `examples/argocd/oci-application.yaml`

## Release model

- Push a semver Git tag like `v0.1.0` to build/publish the CUDA image to GHCR.
- Merge chart changes to `main` with bumped `charts/kokoros/Chart.yaml` version.
- `chart-release.yml` will lint/template, publish index/releases to `gh-pages`, and push changed chart packages to GHCR OCI.

## Notes

- Default chart values assume CUDA and request `nvidia.com/gpu: 1`.
- Model files are preloaded via init container to a persistent models volume.
- Checksums are supported and enforced when provided.
- If OCI pulls return `403`, set GHCR package visibility to public for `kokoros` and `charts/kokoros` in the `tensorlabresearch` org packages settings.
