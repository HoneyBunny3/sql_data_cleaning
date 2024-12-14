/*=============================================================================================
   PL/SQL Script: automated_cleaning_job.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   Automates the execution of the `clean_and_transform_contracts` procedure to clean and enhance 
   data in the `contracts` table, ensuring data quality and integrity.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Implements error handling for robust execution and detailed feedback.
   ➜ Logs execution status and errors using `DBMS_OUTPUT.PUT_LINE`.
   ➜ Validates successful execution with a summary message for transparency.
   ➜ Supports integration as a scheduled job for regular data cleaning.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `automated_cleaning_job.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script manually or integrate it into a scheduled job.
   5️⃣ Review logs for success or error messages in the output console.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Schedule This Script as a Recurring Job:
       Use Oracle's `DBMS_SCHEDULER` to automate the job:
       
       BEGIN
           DBMS_SCHEDULER.CREATE_JOB (
               job_name        => 'cleaning_job',
               job_type        => 'PLSQL_BLOCK',
               job_action      => 'BEGIN CALL clean_and_transform_contracts(); END;',
               start_date      => SYSTIMESTAMP,
               repeat_interval => 'FREQ=DAILY; BYHOUR=2',
               enabled         => TRUE
           );
           DBMS_OUTPUT.PUT_LINE('Scheduled cleaning job created successfully.');
       END;
       

   ➤ Log Results to an Audit Table:
       -- Create a log table for tracking execution:
       
       CREATE TABLE cleaning_job_log (
           log_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
           status VARCHAR2(50),
           start_time TIMESTAMP,
           end_time TIMESTAMP,
           duration INTERVAL DAY TO SECOND,
           error_message VARCHAR2(4000)
       );
       
       -- Insert log records after execution:
       
       INSERT INTO cleaning_job_log (status, start_time, end_time, duration, error_message)
       VALUES ('SUCCESS', v_start_time, v_end_time, v_end_time - v_start_time, NULL);
       

   ➤ Add Email Notifications:
       -- Use Oracle `UTL_MAIL` or `UTL_SMTP` to send success or error notifications:
       
       BEGIN
           UTL_MAIL.SEND(sender => 'system@example.com',
                         recipients => 'admin@example.com',
                         subject => 'Automated Cleaning Job Status',
                         message => 'The cleaning job completed successfully.');
       END;
       

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `clean_and_transform_contracts` procedure is defined and thoroughly tested.
   ⚙ Verify database permissions to allow job scheduling and log table creation.
   ⚙ Set up email configurations if email notifications are required.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The cleaning job starts here. Automate, streamline, and enhance your data quality effortlessly. 
Ensure prerequisites are met before execution. Let the cleaning begin!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
BEGIN
    -- Step 1: Log the start time of the process
    v_start_time := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Automated cleaning job started at: ' || TO_CHAR(v_start_time, 'YYYY-MM-DD HH24:MI:SS'));

    -- Step 2: Call the cleaning and transformation procedure
    BEGIN
        CALL clean_and_transform_contracts();
        DBMS_OUTPUT.PUT_LINE('Procedure clean_and_transform_contracts executed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error executing clean_and_transform_contracts: ' || SQLERRM);
            RAISE;
    END;

    -- Step 3: Log the completion time
    v_end_time := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Automated cleaning job completed at: ' || TO_CHAR(v_end_time, 'YYYY-MM-DD HH24:MI:SS'));

    -- Step 4: Calculate the duration of the process
    DBMS_OUTPUT.PUT_LINE('Total duration: ' || TO_CHAR(v_end_time - v_start_time) || ' seconds.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during the automated cleaning job: ' || SQLERRM);
END;
/