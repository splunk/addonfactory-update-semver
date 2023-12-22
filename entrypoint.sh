#!/bin/sh
set -x

cd "${GITHUB_WORKSPACE}" || exit

# Set up variables.
TAG="${INPUT_TAG:-${GITHUB_REF#refs/tags/}}" # v1.2.3
MINOR="${TAG%.*}"                            # v1.2
MAJOR="${MINOR%.*}"                          # v1
MAJOR_VERSION_TAG_ONLY=${INPUT_MAJOR_VERSION_TAG_ONLY:-}
MINOR_VERSION_TAG_ONLY=${INPUT_MINOR_VERSION_TAG_ONLY:-}

if [ "${GITHUB_REF}" = "${TAG}" ]; then
  echo "This workflow is not triggered by tag push: GITHUB_REF=${GITHUB_REF}"
  exit 1
fi

MESSAGE="${INPUT_MESSAGE:-Release ${TAG}}"

# Set up Git.
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Update MAJOR/MINOR tag based on MINOR_VERSION_TAG_ONLY and MAJOR_VERSION_TAG_ONLY parametersif [ "${MINOR_VERSION_TAG_ONLY}" = "true" ] && [ "${MAJOR_VERSION_TAG_ONLY}" = "true" ]; then echo "Error: Both MINOR_VERSION_TAG_ONLY and MAJOR_VERSION_TAG_ONLY cannot be true." exit 1 fi if [ "${MINOR_VERSION_TAG_ONLY}" = "true" ]; then git tag -fa "${MINOR}" -m "${MESSAGE}" elif [ "${MAJOR_VERSION_TAG_ONLY}" = "true" ]; then git tag -fa "${MAJOR}" -m "${MESSAGE}" else git tag -fa "${MINOR}" -m "${MESSAGE}" git tag -fa "${MAJOR}" -m "${MESSAGE}" fi
if [ "${MINOR_VERSION_TAG_ONLY}" = "true" ] && [ "${MAJOR_VERSION_TAG_ONLY}" = "true" ]; then
  echo "Error: Both MINOR_VERSION_TAG_ONLY and MAJOR_VERSION_TAG_ONLY cannot be true."
  exit 1
fi

if [ "${MINOR_VERSION_TAG_ONLY}" = "true" ]; then
  git tag -fa "${MINOR}" -m "${MESSAGE}"
elif [ "${MAJOR_VERSION_TAG_ONLY}" = "true" ]; then
  git tag -fa "${MAJOR}" -m "${MESSAGE}"
else
  git tag -fa "${MINOR}" -m "${MESSAGE}"
  git tag -fa "${MAJOR}" -m "${MESSAGE}"
fi

# Set up remote URL for checkout@v1 action.
if [ -n "${INPUT_GITHUB_TOKEN}" ]; then
  git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
fi

# Push based on MINOR_VERSION_TAG_ONLY and MAJOR_VERSION_TAG_ONLY parameters
if [ "${MINOR_VERSION_TAG_ONLY}" = "true" ]; then
  git push --force origin "${MINOR}"
else
  [ "${MAJOR_VERSION_TAG_ONLY}" = "true" ] || git push --force origin "${MINOR}"
  git push --force origin "${MAJOR}"
fi
