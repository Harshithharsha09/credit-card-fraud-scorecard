-- MySQL 8 example: transaction velocity + amount spike features.
-- Assumed table: transactions(transaction_id, account_id, transaction_time, amount)
-- Keep this as a review queue rule, not an automatic fraud decision.

WITH ordered AS (
    SELECT
        transaction_id,
        account_id,
        transaction_time,
        amount,
        LAG(transaction_time) OVER (
            PARTITION BY account_id ORDER BY transaction_time, transaction_id
        ) AS previous_transaction_time,
        AVG(amount) OVER (
            PARTITION BY account_id
            ORDER BY transaction_time, transaction_id
            ROWS BETWEEN 30 PRECEDING AND 1 PRECEDING
        ) AS prior_30_txn_avg_amount
    FROM transactions
), features AS (
    SELECT
        *,
        TIMESTAMPDIFF(
            SECOND, previous_transaction_time, transaction_time
        ) AS seconds_since_previous,
        amount / NULLIF(prior_30_txn_avg_amount, 0) AS amount_to_baseline_ratio
    FROM ordered
)
SELECT
    transaction_id,
    account_id,
    transaction_time,
    amount,
    seconds_since_previous,
    prior_30_txn_avg_amount,
    amount_to_baseline_ratio,
    CASE
        WHEN seconds_since_previous BETWEEN 0 AND 600
         AND amount_to_baseline_ratio >= 3.0
        THEN 1 ELSE 0
    END AS flag_for_review
FROM features
ORDER BY transaction_time, transaction_id;

-- The first transaction per account has no prior transaction/baseline and will
-- have NULL features. Production implementations should define a warm-up and
-- fallback baseline policy, test late/out-of-order events, and tune thresholds
-- with domain experts and representative, appropriately governed data.
