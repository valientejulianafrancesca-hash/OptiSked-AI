# OptiSked AI — Machine Learning Recommendation Component

## Purpose

OptiSked AI combines a deterministic scheduling constraint engine with a machine-learning ranker. The rule engine protects hard scheduling requirements. The ML component ranks only the candidates that already satisfy those requirements.

## Model

**Algorithm:** Scikit-learn `RandomForestClassifier`

**Learning target:** historical-pattern membership.

- Positive examples: published schedule records already stored by the system.
- Negative examples: nearby day/time/room alternatives that were not historically used.

The model predicts how closely a feasible candidate resembles the institution's historical scheduling patterns.

## Features

The ML feature set includes:

- day of week
- program
- year level
- section
- teacher
- room
- room type
- start time
- duration
- teacher preferred-day match
- teacher availability match
- frequency of the day in historical schedules
- frequency of the room in historical schedules
- frequency of the start time
- teacher-day frequency
- teacher-start-time frequency
- program-day frequency

Categorical features are vectorized with scikit-learn's `DictVectorizer`.

## Recommendation Flow

```text
Program Head submits schedule
        |
        v
Hard constraint validation
        |
        +--> teacher conflict
        +--> room conflict
        +--> section conflict
        +--> preferred-day conflict
        +--> availability conflict
        +--> approved-leave conflict
        |
        v
Generate feasible candidates
        |
        v
Random Forest ML scoring
        |
        v
Sort by suitability score
        |
        v
Show top recommendations
        |
        v
Program Head selects Apply Fix
        |
        v
Run hard constraints again
        |
        v
Save only if still conflict-free
```

## Why this is appropriate for the project

The model is intentionally small and explainable. It runs from the schedule history already stored by OptiSked and does not require a GPU or a third-party AI API. It is also retrained from the current published-schedule dataset whenever the AI recommendation function is used, so newly verified schedules can influence later rankings.

The model does not override mandatory constraints. A high ML score can never make an invalid schedule acceptable.

## Cold-start behavior

A newly installed system can have little historical data. The rule-based conflict engine continues to work even when the ML model cannot be trained. Once published schedule history is present and scikit-learn is installed, the recommendation layer becomes active.

## Important interpretation

This component should be described as **machine-learning-based historical pattern ranking** rather than as a prediction of teacher satisfaction or an autonomous timetable generator. The system's final schedule remains under Program Head review.
