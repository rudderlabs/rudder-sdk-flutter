<p align="center">
  <a href="https://rudderstack.com/">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://cdn.rudderlabs.com/brand/logo_watermark_dark.png">
      <img alt="RudderStack" width="512" src="https://cdn.rudderlabs.com/brand/logo_watermark_light.png">
    </picture>
  </a>
</p>

# What is Rudder?

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/rudderlabs/rudder-sdk-flutter)

**Short answer:**
Rudder is an open-source Segment alternative written in Go, built for the enterprise.

**Long answer:**
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools.
Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre)
and provides a powerful transformation framework to process your event data on the fly.

Released under [MIT License](https://opensource.org/licenses/MIT)

This is the android package for Rudder Flutter SDK. Check Rudderstack Flutter SDK for details.

## Local development setup

For release instructions, see [RELEASING.md](RELEASING.md).

We use [Melos](https://melos.invertase.dev/getting-started) monorepo tool.
You can see all available commands/scripts in melos.yaml file

To setup locally:

    dart pub global activate melos 6.3.3
    melos run flutter:upgrade
    melos run setup
    melos run build:sdk:all

Optionally for auto formatting source code via relevant Melos command you will need to install:

- clang-format (can be installed via Brew on macOS).
- swiftformat (can be installed via Brew on macOS).
