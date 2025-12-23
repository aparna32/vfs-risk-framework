-- SLA Compliance & Turnaround Metrics

SELECT
    a.center_location,
    a.visa_type,
    COUNT(a.application_id) AS total_applications,
    SUM(CASE WHEN s.sla_breached = 'Y' THEN 1 ELSE 0 END) AS breached_applications,
    ROUND(
        100.0 * SUM(CASE WHEN s.sla_breached = 'N' THEN 1 ELSE 0 END) / COUNT(a.application_id),
        2
    ) AS sla_compliance_pct,
    ROUND(
        AVG(
            DATE_PART('day', a.decision_date::date - a.submission_date::date)
        ),
        1
    ) AS avg_turnaround_days
FROM applications a
LEFT JOIN sla_events s
    ON a.application_id = s.application_id
WHERE a.current_status = 'Decided'
GROUP BY a.center_location, a.visa_type
ORDER BY sla_compliance_pct ASC;
