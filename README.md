# Switch TV

A native Nintendo Switch homebrew launcher prototype.

## Current milestone
- Native `.nro` application
- D-pad / stick menu navigation
- A to select, B to exit
- Placeholder sections for Films, YouTube, VK Video, VK Music and Settings

Media services are not connected in this prototype. Their availability, authentication,
video decoding and network behaviour must be tested separately on the target console.

## Build
The GitHub Actions workflow in `.github/workflows/build.yml` builds the project with
the official devkitPro Nintendo Switch toolchain container and publishes `switch-tv.nro`
as a downloadable workflow artifact.

## Install
Copy `switch-tv.nro` to the Switch SD card, for example:
`/switch/switch-tv/switch-tv.nro`

Launch it from Homebrew Menu.
