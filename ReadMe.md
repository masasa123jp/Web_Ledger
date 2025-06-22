```md
# Web Ledger Manager – User Manual

Web Ledger Manager is a comprehensive web application designed to manage various types of ledgers—including budget, order, and server management ledgers—in a centralized and customizable environment. Built with Python (Flask) for the backend and Vue.js for the frontend, this system provides robust features such as inline editing, column filtering, Excel importation, AI-driven analytics, multilingual support, detailed audit histories, and user management.

This manual includes detailed instructions for installing the required dependencies, setting up the environment, running the application, and using its various features.

---

## Table of Contents

- [Introduction](#introduction)
- [Key Features](#key-features)
- [Installation and Setup](#installation-and-setup)
  - [Prerequisites](#prerequisites)
  - [Installation Steps](#installation-steps)
- [Usage Guide](#usage-guide)
  - [User Login and Dashboard](#user-login-and-dashboard)
  - [Ledger Management](#ledger-management)
  - [Inline Editing & Filtering](#inline-editing--filtering)
  - [Excel Import](#excel-import)
  - [AI Analysis](#ai-analysis)
  - [User Management](#user-management)
  - [Version History & Audit Logs](#version-history--audit-logs)
- [Running in Production](#running-in-production)
- [Additional Considerations](#additional-considerations)
- [Support](#support)
- [License](#license)

---

## Introduction

The Web Ledger Manager is designed to streamline the operation of ledger-based record keeping within organizations. Whether you are tracking budgets, orders, or server management information, this application ensures that your data is centralized, searchable, and ready for analysis. Developed using Agile Scrum practices, it is continuously enhanced through multiple sprints to deliver new functionalities and improve user experience.

---

## Key Features

- **User Experience Customization**
  - Personalizable dashboard layouts and themes.
  - Dedicated screens for managing ledger master items.
  - Role-specific options for adding or editing ledgers.

- **Dynamic Filtering & Inline Editing**
  - Real-time, column-level filtering with partial match searches.
  - Easy in-table editing (excluding non-editable fields like ID).

- **Comprehensive Audit and History Tracking**
  - Records every update detail with user names, timestamps, and field changes.
  - History dashboard/modal to review previous changes.

- **Multilingual Support**
  - Switch easily between Japanese and English for UI labels, ledger item names, and button texts.

- **Advanced Reporting & AI Integration**
  - Customizable analytics dashboard with export options.
  - Integration with AI services (such as OpenAI) for data analysis and anomaly detection.

- **Excel Import Functionality**
  - Import ledger data from Excel files with duplicate detection.
  - Automatic ledger type selection during import.

- **User Management**
  - Secure login/logout functionality.
  - Administration tools for adding, editing, or deleting user accounts with role-based access.

- **Performance Optimization**
  - Optimized SQL queries and indexes for handling large datasets effectively.

---

/project_root
├─ChatChainConfig.json
├─gunicorn.sh
├─main.py
├─manual.md
├─meta.txt
├─PhaseConfig.json
├─requirements.txt
├─RoleConfig.json
├─Sprint6_Module_Structure.txt
├─WebLedger.prompt
│
├─ai_integration
│      ai_analysis_controller.py
│      ai_integration.py
│
├─anomaly_detection
│      anomaly_detection.py
│      anomaly_visualization.js
│
├─app
│  ├─ai_agent.py
│  ├─db.py
│  ├─excel_importer.py
│  ├─ledger_column_manager.py
│  ├─ledger_manager.py
│  ├─ledger_master_manager.py
│  ├─routes.py
│  ├─user_management.py
│  ├─__init__.py
│  │
│  ├─static
│  │  ├─css
│  │  │      style.css
│  │  │
│  │  ├─js
│  │  │  ai_app.js
│  │  │  anomaly_visualization.js
│  │  │  app.js
│  │  │  pivot.js
│  │  │
│  │  └─sample_files
│  │      budget_ledger_sample.xlsx
│  │      order_ledger_sample.xlsx
│  │      server_ledger_sample.xlsx
│  │
│  └─templates
│          ai_integration.html
│          anomaly_detection.html
│          index.html
│          ledger_master.html
│          manual.html
│          ml_prediction.html
│          performance.html
│          pivot.html
│          report_dashboard.html
│          user_management.html
│          version_history.html
│
├─csv
│  ledger_column_master.csv
│  ledger_master.csv
│  ledger_records.csv
│
├─ml_prediction
│  ml_model_manager.py
│  ml_prediction.py
│
├─performance_optimization
│  async_task_controller.py
│  async_task_manager.py
│  cache_manager.py
│  query_optimizer.py
│  response_time_logger.py
│
└─report_dashboard
    export_utils.py
    report_controller.py
    report_generator.py

---

## Installation and Setup

### Prerequisites

- **Python 3.x** – The application backend is built with Flask.
- **Node.js and npm** – (Optional) For managing any additional frontend dependencies.
- **PostgreSQL** – Used as the main database.

### Installation Steps

1. **Clone the Repository**

   Open your terminal and run:

   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```

2. **Set Up a Virtual Environment**

   Create and activate a virtual environment:

   ```bash
   python -m venv venv
   source venv/bin/activate   # On Linux or macOS
   venv\Scripts\activate      # On Windows
   ```

3. **Install Python Dependencies**

   Install all required packages via pip:

   ```bash
   pip install -r requirements.txt
   ```

4. **Initialize the Database**

   When the application starts, it initializes the PostgreSQL database and creates the necessary tables automatically. To manually initialize or reset the database, run:

   ```bash
   python db_initializer.py
   ```

5. **Launch the Application**

   For development mode, use Flask’s built-in server:

   ```bash
   python main.py
   ```

   For production deployment, use Gunicorn:

   ```bash
   gunicorn --bind 0.0.0.0:8000 run:app
   ```

---

## Usage Guide

### User Login and Dashboard

- **Accessing the App:**  
  Open your web browser and navigate to:  
  `http://localhost:8000/`

- **Logging In:**  
  On the login screen, enter your credentials (for example, use username `admin` and password `admin` for the administrator account).  
  Upon successful authentication, you will be directed to the main dashboard.

- **Dashboard Overview:**  
  The dashboard provides a drop-down for selecting ledger types, buttons for running AI analysis, importing Excel files, and quick access to user management and version history.

### Ledger Management

- **Selecting Ledger Types:**  
  Choose from Budget, Order, or Server Management ledgers using the provided drop-down menu on the dashboard.

- **Viewing Records:**  
  Each ledger screen displays a table with ledger records. You can scroll horizontally if there are many columns—the first few columns (like ID and ledger type) remain fixed for clarity.

- **Adding a New Ledger:**  
  Click the "新規追加" (New Entry) button to open the ledger form, complete the required fields (such as theme name, fiscal year, budget details, etc.), and click "保存" (Save).

### Inline Editing & Filtering

- **Inline Editing:**  
  Click on any editable cell (except for non-editable fields like the ledger ID) to modify its value. Once edited, confirm changes by pressing Enter or clicking away from the input.

- **Filtering Records:**  
  Each column header has a filter input. Enter search text for partial matches; the ledger table will update dynamically to show only matching records.

### Excel Import

- **Import Process:**  
  On the dashboard, locate the Excel file input control. Select an Excel file that includes the required fields (e.g., for Budget Ledger, columns such as `theme_name`, `fiscal_year`, `budget_type`, etc. are needed).

- **Post-Import Feedback:**  
  After uploading, the application will process the file—skipping incomplete or duplicate entries—and display a message with the number of successfully imported records.

### AI Analysis

- **Running AI Analysis:**  
  Click the "AI解析" (Run AI Analysis) button on the dashboard to have the built-in AI agent analyze the current ledger data (for example, summing up the `budget_amount` values).
  
- **Results Display:**  
  The AI analysis output, including total records, total and average amounts, and recommendations, is presented in an easily readable format below the ledger table.

### User Management

- **Accessing User Management:**  
  Click the "ユーザー管理" (User Management) button (usually accessible via the dashboard’s navigation bar).  
  This opens a dedicated page for managing users.

- **Managing Users:**  
  From this page, administrators can add new users, edit existing user profiles, or delete user accounts. All passwords are securely hashed, and roles (e.g., `admin`, `user`) define access rights.

### Version History & Audit Logs

- **Viewing Version History:**  
  Click the "バージョン履歴" (Version History) link to see a list of application versions, sprint information, and update details.
  
- **Audit Logs:**  
  The system automatically records ledger updates (user, time, and changes) into an audit log and history table. This information can be viewed through a dedicated history modal or dashboard feature.

---

## Running in Production

For a production environment, it is recommended to use Gunicorn in combination with a reverse proxy (like Nginx). For example:

```bash
gunicorn --bind 0.0.0.0:8000 run:app
```

Remember to set a secure `SECRET_KEY` environment variable rather than using the default.

---

## Additional Considerations

- **Localization:**  
  The interface allows switching languages between Japanese and English using the "言語切替" (Language Switch) button.

- **Customization Rights:**  
  Users with admin or manager roles have additional privileges, such as adding new ledger types or editing ledger item definitions directly from the Ledger Master Management Screen.

- **Future Enhancements:**  
  Planned improvements include advanced AI analysis capabilities, predictive machine learning modules, and further UI/UX refinements to enhance efficiency and ease of use.

---

## Support

XXXXXX

---

## License

This software is provided "as-is" without any such warranty. Please refer to the LICENSE file included in the repository for further details on usage rights and limitations.

---

Happy ledger managing!
```
