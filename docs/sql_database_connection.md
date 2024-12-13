### **Connecting VS Code to a MySQL Workbench Database**

Follow these steps to connect VS Code to your MySQL Workbench database for executing SQL scripts.

---

### **1. Install Required Tools**

#### Install MySQL Server and Workbench
- Ensure that MySQL Server and MySQL Workbench are already installed and running on your machine.

#### Install VS Code Extensions
1. Open **Visual Studio Code**.
2. Go to the Extensions Marketplace (`Ctrl+Shift+X` or `Cmd+Shift+X`).
3. Search for and install the following:
   - **"SQLTools"**: A powerful extension for database management.
   - **"SQLTools MySQL/MariaDB Driver"**: The driver required to connect SQLTools to MySQL.

---

### **2. Configure MySQL Workbench**

1. **Open MySQL Workbench**.
2. **Create or Identify a Connection**:
   - If you already have a connection set up:
     - Note the connection details such as host (`localhost`), port (`3306`), username (e.g., `root`), and the database name.
   - If you don't have a connection set up:
     - Click **"New Connection"**.
     - Provide the connection name, hostname (`localhost`), and port (`3306`).
     - Set your username (e.g., `root`) and password.
     - Test the connection and click **OK**.
3. Ensure the MySQL Server is running.

---

### **3. Configure SQLTools in VS Code**

1. **Open SQLTools Settings**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open the Command Palette.
   - Search for and select `SQLTools: Add New Connection`.

2. **Set Up a New MySQL Connection**:
   - When prompted, select **MySQL/MariaDB** as the database type.
   - Fill in the following details:
     - **Connection Name**: Give your connection a meaningful name (e.g., "MySQL Workbench DB").
     - **Server/Host**: `localhost` (if MySQL is running locally).
     - **Port**: `3306` (default MySQL port).
     - **User**: The username for your MySQL server (e.g., `root`).
     - **Password**: The password you use to access your MySQL server.
     - **Database**: The specific database you want to connect to (e.g., `contracts`).
   - Save the connection settings.

3. **Test the Connection**:
   - After saving, SQLTools will prompt you to test the connection.
   - If the connection is successful, you’re ready to execute SQL scripts from VS Code.

---

### **4. Run SQL Scripts in VS Code**

1. **Open a SQL Script**:
   - Navigate to the `scripts/` folder in VS Code and open the `.sql` file you want to run.

2. **Execute Queries**:
   - Right-click inside the file and select **"Run Query"** or press the shortcut (`Ctrl+Enter` or `Cmd+Enter`).
   - If prompted, select your configured connection.

3. **View Results**:
   - Query results will be displayed in a panel at the bottom of VS Code.
   - Errors, if any, will also appear here for troubleshooting.