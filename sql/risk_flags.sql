-- Operational Risk & Escalation Signals

SELECT
    a.center_location,
    a.visa_type,
    COUNT(a.application_id) AS total_cases,
    SUM(CASE WHEN s.rework_required = 'Y' THEN 1 ELSE 0 END) AS rework_cases,
    SUM(CASE WHEN s.escalation_flag = 'Y' THEN 1 ELSE 0 END) AS escalations,
    ROUND(
        100.0 * SUM(CASE WHEN s.escalation_flag = 'Y' THEN 1 ELSE 0 END) / COUNT(a.application_id),
        2
    ) AS escalation_rate_pct,
    SUM(CASE WHEN s.quality_flag = 'Red' THEN 1 ELSE 0 END) AS high_risk_cases
FROM applications a
JOIN sla_events s
    ON a.application_id = s.application_id
GROUP BY a.center_location, a.visa_type
HAVING COUNT(a.application_id) >= 5
ORDER BY escalation_rate_pct DESC;
