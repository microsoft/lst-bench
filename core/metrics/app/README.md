<!--
{% comment %}
Copyright (c) Microsoft Corporation.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
{% endcomment %}
-->

# LST-Bench: Dashboard

**Dashboard:** [https://lst-bench.azurewebsites.net/](https://lst-bench.azurewebsites.net/)

The LST-Bench dashboard is powered by [Streamlit](https://github.com/streamlit/streamlit) and deployed to Azure App Service through GitHub actions. 
You can find the deployment workflow [here](/.github/workflows/webapp-deploy.yaml). 
The dashboard provides insights derived from metrics collected from LST-Bench, including execution time and degradation rate. 

## Evaluation
The results displayed in the dashboard are specific to the versions and configurations we tested. 
Their performance is subject to change and improvement through further tuning and future developments.
Thus, the primary aim of sharing them is not to assert that one LST or engine is superior (in terms of speed, cost, etc.) to another. 
Instead, it is to showcase LST-Bench's capability in quantifying significant trade-offs across various combinations of engines and LSTs. 
Further details about the runs and setups are available [here](/core/run).

## Adding a New Result
To include data from a new system, duplicate one of the directories in the [run folder](/core/run) and modify the necessary files within. 
For a deeper understanding of the directory structure, consult the [README file](/core/run/README.md). 
The LST-Bench dashboard web app automatically retrieves results from the .duckdb files within those folders and displays them on the dashboard.

Alternatively, you can provide your own paths to search for results via commandline arguments, see below.

## Dashboard Development
To run the LST-Bench dashboard locally and test your changes, follow these steps:

### 1. Set up Python version
Ensure you have Python version 3.11 installed on your system. If not, you can download and install it from the official Python website.

### 2. Create and Start Virtual Environment
To isolate the dependencies of the LST-Bench dashboard, it's recommended to use a virtual environment. You can create one by running the following command in your terminal:

```bash
python -m venv venv
```

Once the virtual environment is created, activate it by executing:

```bash
source venv/bin/activate
```

### 3. Install Dependencies
Install the necessary packages specified in the requirements.txt using pip:

```bash
pip install -r requirements.txt
```

### 4. Execute Streamlit App
With the dependencies installed, you can now start the Streamlit app by running the following command:

```bash
python -m streamlit run main.py
python -m streamlit run main.py -- --result_dirs DIR1 DIR2 ...
```

This command will launch the LST-Bench dashboard locally in your browser.
