# Security Policy

## Supported Versions

We actively provide security updates for the following versions of SkyBuild:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅ Yes             |
| < 1.0   | ❌ No              |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

As this project handles infrastructure orchestration and interacts with Jira Assets, we take security very seriously. If you discover a potential security misconfiguration or a vulnerability in the `Invoke-WinFlow.ps1` script, please report it privately.

### How to Report
1. **Direct Message:** Contact the maintainer, **Sai Sravan Cherukuri**, via [LinkedIn](https://www.linkedin.com/in/sai-sravan-cherukuri-irs/).
2. **Email:** [Insert your professional email here]

Please include:
* A description of the vulnerability.
* Steps to reproduce the issue.
* Any potential impact on Jira or Windows environments.

### Our Response Process
* **Acknowledgment:** Within 48 hours.
* **Triage:** We will investigate and confirm the issue.
* **Fix:** A patch will be released, and you will be credited for the discovery (unless you prefer to remain anonymous).

## Best Practices for Users
To keep your SkyBuild environment secure, we strongly recommend:
* **Never** hardcode credentials in the scripts.
* Use **Atlassian API Tokens** instead of passwords.
* Restrict the execution host's network access to only necessary hypervisors and Jira URLs.
