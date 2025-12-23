-- Staff Workload & Efficiency Analysis

SELECT
    center_location,
    role,
    staff_id,
    week_start,
    applications_handled,
    avg_processing_days,
    errors_flagged,
    CASE
        WHEN applications_handled >= 65 THEN 'Overloaded'
        WHEN applications_handled BETWEEN 45 AND 64 THEN 'Optimal'
        ELSE 'Underutilized'
    END AS workload_flag
FROM staff_workload
ORDER BY center_location, week_start, applications_handled DESC;
