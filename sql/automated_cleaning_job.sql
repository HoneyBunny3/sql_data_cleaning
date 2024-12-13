/*
PL/SQL Script: automated_cleaning_job.sql
-------------------------------------------
Purpose:
This script automates the execution of the `clean_and_transform_contracts` procedure to clean and enhance data in the `contracts` table.

Features:
1. Error handling for the automated cleaning process.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log execution status and errors.
3. Validates successful execution by logging a summary message.

Execution Notes:
- Ensure the `clean_and_transform_contracts` procedure is defined and tested before running this script.
- Use `DBMS_OUTPUT.PUT_LINE` for feedback during execution.
- Set up as part of a scheduled job for regular execution if needed.
*/

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

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `automated_cleaning_job.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script manually or as part of a scheduled job.
5. Review the logs for success or error messages.

Optional Enhancements:
-------------------------------------------
1. Schedule this script as a recurring job:
   - Use Oracle's DBMS_SCHEDULER to automate the job:
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

2. Log Results to an Audit Table:
   - Create a table to store job execution logs:
     CREATE TABLE cleaning_job_log (
         log_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
         status VARCHAR2(50),
         start_time TIMESTAMP,
         end_time TIMESTAMP,
         duration INTERVAL DAY TO SECOND,
         error_message VARCHAR2(4000)
     );

   - Insert log records after execution:
     INSERT INTO cleaning_job_log (status, start_time, end_time, duration, error_message)
     VALUES ('SUCCESS', v_start_time, v_end_time, v_end_time - v_start_time, NULL);
   - Use exception handling to log errors.

3. Add Email Notifications:
   - Integrate Oracle UTL_MAIL or UTL_SMTP to send success or error notifications.
     Example:
     BEGIN
         UTL_MAIL.SEND(sender => 'system@example.com',
                       recipients => 'admin@example.com',
                       subject => 'Automated Cleaning Job Status',
                       message => 'The cleaning job completed successfully.');
     END;
*/