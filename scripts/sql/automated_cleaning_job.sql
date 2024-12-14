/*=============================================================================================
   SQL Script: automated_cleaning_job.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   Automates the cleaning and enhancement of data in the `contracts` table by executing 
   predefined cleaning operations through a scheduled job, ensuring consistent data quality 
   and integrity.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Removes duplicate rows and handles null values in key columns.
   ➜ Defines and executes a procedure (`clean_and_transform_contracts`) for cleaning tasks.
   ➜ Automates regular execution using a scheduled event.
   ➜ Logs cleaning operations for traceability and auditing.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `automated_cleaning_job.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to:
       ➤ Create the `clean_and_transform_contracts` procedure.
       ➤ Schedule the cleaning procedure as a recurring event.
   4️⃣ Verify the event is created using:
       
       SHOW EVENTS WHERE Name = 'clean_and_transform_event';
       
   5️⃣ Check logs or audit tables to ensure cleaning tasks are executed as expected.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Cleaning Steps:
       Extend the procedure to handle specific cleaning needs, such as:
       - Text normalization
       - Validation of monetary fields

   ➤ Log Execution Results:
       -- Create a dedicated log table to record details of each cleaning operation:
       
       CREATE TABLE cleaning_job_log (
           log_id INT AUTO_INCREMENT PRIMARY KEY,
           status VARCHAR(50),
           executed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
           details TEXT
       );

   ➤ Integrate Email Notifications:
       Use a third-party tool or script to send success or error notifications after execution.

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Verify that the `contracts` table exists and contains data requiring cleaning.
   ⚙ Ensure the user has permissions to create procedures and events.
   ⚙ Backup the database as needed before executing cleaning operations.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The cleaning job starts here. Automate, streamline, and enhance your data quality effortlessly. 
Ensure prerequisites are met before execution. Let the cleaning begin!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Ensure the procedure exists
DELIMITER //

CREATE PROCEDURE clean_and_transform_contracts()
BEGIN
    -- Step 1: Remove duplicates
    DELETE FROM contracts
    WHERE ROWID NOT IN (
        SELECT MIN(ROWID)
        FROM contracts
        GROUP BY ROW_KEY
    );

    -- Step 2: Handle null values
    UPDATE contracts
    SET CONTRACT_SYNOPSIS = 'Not Available'
    WHERE CONTRACT_SYNOPSIS IS NULL;

    UPDATE contracts
    SET ALIAS_NM = 'No Alias'
    WHERE ALIAS_NM IS NULL;

    -- Additional cleaning steps can be added here
    -- Example: Monetary validation, text normalization, etc.

    -- Log the successful execution
    INSERT INTO audit_log (action, table_name, details)
    VALUES ('Automated Cleaning', 'contracts', 'Executed clean_and_transform_contracts procedure successfully.');
END //

DELIMITER ;

-- Step 2: Create a recurring event for automation
CREATE EVENT IF NOT EXISTS clean_and_transform_event
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    CALL clean_and_transform_contracts();

-- Step 3: Verify the event is scheduled
SHOW EVENTS
WHERE Name = 'clean_and_transform_event';