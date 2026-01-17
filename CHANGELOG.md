# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-01-17

### Fixed

- Fixed VPN status endpoint from `/connections/status` to `/connection/status`
- Fixed VPN status response handling to properly parse Array response
- Fixed VM active endpoint from `/vm/active` to `/machine/active`
- Fixed config file YAML parsing to handle non-Hash responses gracefully
- Changed "Machine" label to "Challenge" in status output

## [0.1.0] - 2025-01-17

### Added

- Initial release
- Machine management (list, profile, play, stop, own)
- VM management (spawn, terminate, reset, extend)
- User profiles and activity
- Challenge management
- VPN and lab information
- Support for the updated base URI (`labs.hackthebox.com`)
