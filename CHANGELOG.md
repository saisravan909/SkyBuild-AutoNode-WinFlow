# Changelog

All notable changes to the **SkyBuild: AutoNode WinFlow** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-03-02
### Added
- **Jira Assets Integration:** Support for automatic status updates in Jira Assets post-provisioning.
- **Enhanced Logging:** Detailed PowerShell transcript logging for better troubleshooting.
- **Security Policy:** Added `SECURITY.md` for vulnerability reporting.

### Changed
- **Parameter Validation:** Improved JSON payload parsing in `Invoke-WinFlow.ps1`.
- **Documentation:** Expanded the `GETTING_STARTED.md` with step-by-step setup instructions.

---

## [1.0.1] - 2026-02-25
### Fixed
- Resolved a bug where the script would fail if the Jira Issue Key was not provided in the payload.
- Fixed a pathing issue for local Hyper-V module imports.

---

## [1.0.0] - 2026-02-23
### Added
- Initial release of the SkyBuild Engine.
- Core PowerShell orchestration script (`Invoke-WinFlow.ps1`).
- Basic Jira Automation webhook template.
- Social preview branding and repository logo.
