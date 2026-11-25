# Synthetic Credit Card Fraud Detection Scorecard

A small, reproducible Python + SQL project that flags suspicious card transactions using two intuitive signals: **short time between transactions** and **an amount spike versus the account's recent behavior**. It uses synthetic data only—no real cardholder or American Express data.

## Why this project

This is a refreshed version of a personal project idea, rebuilt as a quick, explainable portfolio demo. It demonstrates attention to detail, risk-aware decision support, basic data analysis, and communicating limitations. Those skills can support an application for an operations/customer-service role, but this project is **not a direct simulation of collections work** and does not replace the role's customer communication, empathy, or compliance requirements.

## What it does

- Generates fake transaction data with account IDs, timestamps, amounts, and synthetic fraud labels.
- Calculates the time since the previous transaction and amount relative to a trailing account baseline.
- Applies a transparent rule: rapid transactions plus an amount spike are flagged for review.
- Trains a logistic-regression scorecard and reports ROC-AUC, Gini, and KS on a held-out test set.
- Includes a MySQL 8 query showing how the time-gap and trailing-average features can be calculated in SQL.

## Run it

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
jupyter notebook notebooks/fraud_scorecard.ipynb
```

Run the notebook cells from top to bottom. It generates its own reproducible synthetic dataset; no external data download is required.

## Scorecard metrics

- **ROC-AUC** measures ranking quality across possible thresholds.
- **Gini** is calculated as `2 * ROC-AUC - 1`.
- **KS** is the maximum separation between the cumulative score distributions of positive and negative examples.

Metrics depend on the randomly generated synthetic data and are not evidence of real-world performance. A flagged transaction is only a review signal—not a conclusion that fraud occurred. Any real deployment would require validated data, privacy and regulatory review, fairness assessment, monitoring, and human oversight.

## Project structure

```text
credit-card-fraud-scorecard/
├── notebooks/
│   └── fraud_scorecard.ipynb
├── sql/
│   └── feature_queries.sql
├── requirements.txt
└── README.md
```

## Suggested interview summary

> I rebuilt a synthetic transaction-risk scorecard that combines transaction velocity and account-relative amount spikes. I engineered the features in Python, showed the equivalent SQL window-function approach, and evaluated a logistic-regression model with ROC-AUC, Gini, and KS. I kept the data synthetic and treated alerts as prompts for review rather than automatic decisions.

For an operations/customer-service interview, connect this project to careful evaluation, integrity, handling information responsibly, and making measured decisions—while also being clear that customer conversations require empathy and active listening beyond what a model can provide.
