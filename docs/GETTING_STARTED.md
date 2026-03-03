#  Getting Started with SkyBuild: AutoNode WinFlow

Welcome to the SkyBuild framework. This guide will walk you through setting up the connection between **Jira Service Management (JSM)** and your **Windows Infrastructure**.

---

##  Prerequisites
Before you begin, ensure you have the following:
* **Jira Service Management (Cloud or Data Center):** Admin access to create Assets and Automation rules.
* **Orchestration Server:** A Windows host with PowerShell 5.1+ and network access to your hypervisor (Hyper-V/VMware/Azure).
* **Atlassian API Token:** For the script to communicate back to Jira.

---

##  Step 1: Configure Jira Assets (AutoNode)
SkyBuild relies on Jira Assets as the single source of truth.

1. **Create Object Schema:** Navigate to Assets and create a new schema named `SkyBuild`.
2. **Define Object Types:** Create the following hierarchy:
   * **Virtual Machine:** Attributes: `Hostname` (Key), `CPU`, `RAM`, `Status`.
   * **OS Image:** Attributes: `ImageName`, `Version`, `Path`.
3. **Link Objects:** Add an attribute to `Virtual Machine` of type "Referenced Object" pointing to `OS Image`.



---

##  Step 2: Set Up Jira Automation
This "brain" triggers the WinFlow engine when a request is approved.

1. **Trigger:** `Issue transitioned` to "Approved".
2. **Action:** `Send web request` (Webhook).
3. **Webhook URL:** The listener URL of your orchestration server.
4. **HTTP Header:** `Authorization: Basic <Base64_Encoded_Credentials>`.
5. **Custom Payload (JSON):**
```json
{
  "issue_key": "{{issue.key}}",
  "hostname": "{{issue.fields.Hostname}}",
  "cpu": "{{issue.fields.CPU}}",
  "ram": "{{issue.fields.RAM}}",
  "os_image": "{{issue.fields.OS.Name}}"
}

---
## Step 3: Verify the Connection (Sandbox Test)

Before connecting your live Jira Cloud/Data Center instance, verify that your orchestration server can process SkyBuild payloads locally.

1. Open PowerShell in the root of the `SkyBuild-AutoNode-WinFlow` directory.
2. Run the following command to pipe the sample asset data into the engine:

```powershell
$SampleData = Get-Content ./examples/sample-webhook.json -Raw
./scripts/Invoke-WinFlow.ps1 -JsonPayload $SampleData
