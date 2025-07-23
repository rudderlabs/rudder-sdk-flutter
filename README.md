# What is Rudder?

**Short answer:**
Rudder is an open-source Segment alternative written in Go, built for the enterprise.

**Long answer:**
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools.
Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre)
and provides a powerful transformation framework to process your event data on the fly.

Released under [MIT License](https://opensource.org/licenses/MIT)

This is the android package for Rudder Flutter SDK. Check Rudderstack Flutter SDK for details.

## Local development setup

We use [Melos](https://melos.invertase.dev/getting-started) monorepo tool.
You can see all available commands/scripts in melos.yaml file

Add you .env file as per the .env.sample with secrets used in unit tests.

To setup locally:

    dart pub global activate melos 6.3.3
    melos run flutter:upgrade
    melos run setup
    melos run build:sdk:all

To allow firebase plugin to work in the example you will need to add the relevant files that contain secrets.
Get firebase config files from a colleague or add your own at:

- packages/example/android/app/google-services.json
- packages/example/ios/Runner/GoogleService-Info.plist

In order to run locally the Android example you will need to either create an emulator with name Pixel_6_Pro_API_33 or
alter the name in the run:example:android command.

Optionally for auto formatting source code via relevant Melos command you will need to install:

- clang-format (can be installed via Brew on macOS).
- swiftformat (can be installed via Brew on macOS).
