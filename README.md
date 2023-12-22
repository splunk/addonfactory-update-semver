# GitHub Action: Tag Release

This GitHub Action automates the tagging and release process based on version tags. It provides flexibility to create either MINOR or MAJOR version tags, or both, depending on the workflow configuration.

For example this action will update v1 and v1.2 tag when released v1.2.3.


## Inputs

- `message` (optional): Tag message. Defaults to "Release {TAG}" if not provided.
- `major_version_tag_only` (optional): If set to `true` only major version tags will be created.
- `minor_version_tag_only` (optional): If set to `true` only minor version tags will be created.

## Example usage

```yaml
name: Update Semver
on:
  push:
    branches-ignore:
      - '**'
    tags:
      - 'v*.*.*'
jobs:
  update-semver:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: splunk/addonfactory-update-semver@v1
        with:
          major_version_tag_only: true 
```

###### Additional credits to [github.com/haya14busa](github.com/haya14busa/action-update-semver)