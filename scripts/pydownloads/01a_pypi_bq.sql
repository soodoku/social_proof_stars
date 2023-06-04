
/* Get daily downloads data for the last 30 days by installer_type for a python project */ 

SELECT
  CAST(timestamp AS DATE) AS timestamp_date,
  file.project AS file_project,
  details.installer.name AS installer_name,
  COUNT(*) AS downloads
FROM `bigquery-public-data.pypi.file_downloads`
WHERE
  file.project LIKE '%sms_log_handler%'
    AND timestamp BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
    AND CURRENT_TIMESTAMP()
GROUP BY
  timestamp_date, file_project, installer_name
ORDER BY
  timestamp_date DESC

/* Get daily downloads data for the last 30 days by installer_type for a list of python projects */ 

SELECT
  CAST(timestamp AS DATE) AS timestamp_date,
  file.project AS file_project,
  details.installer.name AS installer_name,
  COUNT(*) AS downloads
FROM `bigquery-public-data.pypi.file_downloads`
WHERE
  file.project IN ('indicate', 'tensorflow', 'piedomains') -- replace with output.csv
    AND timestamp BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
    AND CURRENT_TIMESTAMP()
GROUP BY
  timestamp_date, file_project, installer_name
ORDER BY
  timestamp_date DESC, file_project ASC

/* Get daily downloads data for the last 30 days by installer_type for all python projects. Useful for VAR/PanelOLS. This is already 600 MB. */ 

SELECT
  CAST(timestamp AS DATE) AS timestamp_date,
  file.project AS file_project,
  details.installer.name AS installer_name,
  COUNT(*) AS downloads
FROM `bigquery-public-data.pypi.file_downloads`
WHERE
  timestamp BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
    AND CURRENT_TIMESTAMP()
GROUP BY
  timestamp_date, file_project, installer_name
ORDER BY
  timestamp_date DESC