[![CI-iOS](https://github.com/finebel/EssentialFeed/actions/workflows/CI-iOS.yml/badge.svg)](https://github.com/finebel/EssentialFeed/actions/workflows/CI-iOS.yml) [![CI-macOS](https://github.com/finebel/EssentialFeed/actions/workflows/CI-macOS.yml/badge.svg)](https://github.com/finebel/EssentialFeed/actions/workflows/CI-macOS.yml) [![Deploy](https://github.com/finebel/EssentialFeed/actions/workflows/deploy.yml/badge.svg)](https://github.com/finebel/EssentialFeed/actions/workflows/deploy.yml)

# EssentialFeed
Project following the iOS Lead Essentials curriculum.

## Branches
This repository contains two branches:  
1. `main`: State after finishing the iOS Lead Essentials curriculum. See [the original repo](https://github.com/essentialdevelopercom/essential-feed-case-study) for more information.
2. `main-tuist` (created from `main`): In this branch I adopted [Tuist](https://docs.tuist.io/) and explored various configuration options.
    - Defining workspaces, projects, targets and custom schemes
    - Configure manual code signing
    - Using testplans
    - Working with different types of resources (Core Data models, localized strings, storyboards, xcassets)
    - Sharing code between different Tuist manifests
    - Using Tuist with CI/CD (GitHub Actions)