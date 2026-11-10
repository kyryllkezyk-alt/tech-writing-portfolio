# Runbook: translation job queue is stuck

**Alert:** `JobQueueStalled` — no job has left `queued` for 15 minutes while the queue depth is
greater than zero.

**Severity:** SEV-2. Customers can upload files but not start translations.

**Owner:** Platform on-call.

## 1. Confirm the alert (2 minutes)

```bash
lingua-ops queue status --env prod
```

| You see | Go to |
| --- | --- |
| `workers: 0 healthy` | [Step 2: Workers down](#2-workers-down) |
| Workers healthy, `oldest_job` older than 15 min | [Step 3: Poison job](#3-poison-job) |
| Queue depth is 0 | False alarm. Resolve the alert and file a monitoring bug |

## 2. Workers down

1. Check recent deploys:

    ```bash
    lingua-ops deploys list --service job-worker --since 2h
    ```

2. **If a deploy happened in the last two hours,** roll it back:

    ```bash
    lingua-ops deploys rollback --service job-worker
    ```

    Wait three minutes, then rerun `queue status`. If workers are healthy, go to
    [Step 4](#4-verify-recovery).

3. **If there was no recent deploy,** check the machine translation provider status page. If the
   provider is down, workers fail their health check by design.

    Enable failover to the secondary provider:

    ```bash
    lingua-ops flags set mt.provider=secondary --env prod
    ```

4. If workers are still down, escalate to the Platform lead. Don't restart the cluster without
   them.

## 3. Poison job

A single malformed job can crash every worker that picks it up.

1. Find the oldest job:

    ```bash
    lingua-ops queue peek --limit 1
    ```

2. Check whether workers are restarting on it:

    ```bash
    lingua-ops logs job-worker --since 15m | grep <job_id>
    ```

3. If the same job ID appears in repeated crash traces, quarantine it:

    ```bash
    lingua-ops queue quarantine <job_id> --reason "poison job, incident <id>"
    ```

    Quarantined jobs are kept, not deleted.

## 4. Verify recovery

- [ ] `queue status` shows `oldest_job` under 2 minutes
- [ ] Queue depth is falling
- [ ] The alert has cleared

## 5. Afterward

- Post a summary in the incident channel: cause, action taken, time to recovery.
- If you quarantined a job, open a ticket for Support to contact the customer.
- If this runbook was wrong or incomplete, fix it in the same week.
