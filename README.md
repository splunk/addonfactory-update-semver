# GitHub Action: Tag Release

This GitHub Action automates the tagging and release process based on version tags. It provides flexibility to create either MINOR or MAJOR version tags, or both, depending on the workflow configuration.

For example this action will update v1 and v1.2 tag when released v1.2.3.

## Inputs

- `git_committer_name`: Committer name for semver changes. Defaults 
- `git_committer_email`: Committer email address for semver changes.
- `gpg_private_key`: GPG private key matching committer email.
- `passphrase`: Passphrase for GPG private key.

- `message` (optional): Tag message. Defaults to "Release {TAG}" if not provided.
- `major_version_tag_only` (optional): If set to `true` only major version tags will be created.
- `minor_version_tag_only` (optional): If set to `true` only minor version tags will be created.

## Example usage

```yaml
name: Update Semver
on:
  push:
    tags:
      - 'v*'
jobs:
  update-semver:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: splunk/addonfactory-update-semver@v1
        env:
          GITHUB_TOKEN: ${{ secrets.<token> }}
        with:
          git_committer_name: ${{ secrets.<git_committer_name> }}
          git_committer_email: ${{ secrets.<git_committer_email> }}
          gpg_private_key: ${{ secrets.<gpg_private_key> }}
          passphrase: ${{ secrets.<passphrase> }}
```

###### Additional credits to [github.com/haya14busa](https://github.com/haya14busa/action-update-semver)
