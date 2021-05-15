CREATE TABLE IF NOT EXISTS log_events (
    event_id uuid DEFAULT gen_random_uuid(),
    src_hostname text,
    src_ip text,
    /* please include a message */
    msg json not null,
    /* extra fields are optional */
    fields json,
    /* if not specified assumes info level */
    log_level text,
    log_date date not null,
    PRIMARY KEY (event_id, log_date)
) PARTITION BY RANGE (log_date);