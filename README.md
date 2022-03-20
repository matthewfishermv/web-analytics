# WebAnalytics

Website analytics data analysis, machine learning, and visualization tools for Google Analytics.

## Getting Started

### Prerequisites

To get started using these tools, you will need to ensure you have done the following:

- Create a Google Analytics 4 account with tracking enabled on your website.
- Create a Google service account and OAuth credentials. See this guide: https://www.rstudio.com/blog/google-analytics-part1/.
- Download the project and unzip it.
- Save your service account key (JSON format) in the project: `/.secrets/google-client-credentials.json`.
- Save your OAuth credentials (JSON format) in the project: `/.secrets/google-oauth-credentials.json`.
- Save your service account email address (TXT format) in the project: `/.secrets/google-client-email.txt`.

### Running Analyses

Once you are done with the prerequisites, you can start using the utilities by doing the following:

1. Unzip the source code (if zipped).
2. Navigate to the project root folder.
3. Open the `WebAnalytics.Rproj` project.
4. Open the `WebAnalytics.R` file.
5. Highlight portions of the script to run.

## Folder Folder Structure

```
/           Project root folder. Contains R project and start script WebAnalytics.R.
/.secrets   Credentials folder. Secrets are stored here, so they are not commited to source control.
/src        Project source files. Contains scripts with different functionality.
```
