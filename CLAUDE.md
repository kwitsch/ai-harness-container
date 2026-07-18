# ai-harness-container

Home for multiple independently-versioned Docker images.

## Layout

Each image lives in its own directory under `images/`:

```
images/<ImageName>/Dockerfile
images/<ImageName>/VERSION
```

`VERSION` holds a single semver string (e.g. `1.2.3`) — no `v` prefix, no other content.

## Release flow

1. On a branch, edit `images/<ImageName>/Dockerfile` as needed and bump `images/<ImageName>/VERSION` to the new version.
2. Merge to `main`.
3. `.github/workflows/build-and-tag.yml` detects which images' `VERSION` changed, builds only those from their own directory as build context, and pushes `ghcr.io/<owner>/<imagename>:<version>` (lowercased).
4. On a successful push, the workflow creates and pushes the git tag `<ImageName>-<version>` (original folder casing) at the merge commit.

An image whose `VERSION` file didn't change in a given merge is left untouched — no rebuild, no new tag.

## Dependencies

`.github/dependabot.yml` watches every `images/*` directory for base-image updates (`docker` ecosystem) and keeps the workflow's own actions up to date (`github-actions` ecosystem).
