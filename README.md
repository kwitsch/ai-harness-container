# ai-harness-container

Multiple independently-versioned Docker images, one per directory under `images/`.

## Adding or updating an image

```
images/<ImageName>/Dockerfile
images/<ImageName>/VERSION      # plain semver, e.g. "1.2.3"
```

Bump `VERSION` and merge to `main`: the changed image is automatically built and
pushed to `ghcr.io/<owner>/<imagename>:<version>`, and a `<ImageName>-<version>`
git tag is created. Images whose `VERSION` didn't change are left alone.

See `CLAUDE.md` for full details.
