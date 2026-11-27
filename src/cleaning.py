"""Pure cleaning helpers for the collab_pipeline survey data.

No T-specific code, no global state and no in-place mutation: the data frame
is the only input and a new data frame is the only output, so the function can
be sourced, unit-tested and re-run in isolation (ch. 3 / ch. 4).

Contract for `clean_survey_scores(df)` -- the oracle Developer B tests against:

1. `group` is normalised to a stripped, lower-case label
   (" Alpha " -> "alpha", "Beta" -> "beta", " Gamma" -> "gamma").
2. `score` is coerced to a number; the -999 sentinel means "not answered",
   so those readings become missing and their rows are dropped
   (respondent_id column 5 and 7).
3. `respondent_id` is never invented: a row with a missing id is kept as is.
4. The result is re-indexed 0..n-1 so row positions are stable for tests.
"""

import pandas as pd

SENTINEL_SCORE = -999


def clean_survey_scores(df):
    """Normalise group labels and drop sentinel (-999) score readings."""
    cleaned = df.copy()
    cleaned["group"] = cleaned["group"].astype("string").str.strip().str.lower()
    cleaned["score"] = pd.to_numeric(cleaned["score"], errors="coerce")
    cleaned = cleaned.loc[cleaned["score"] != SENTINEL_SCORE]
    cleaned = cleaned.dropna(subset=["score"])
    return cleaned.reset_index(drop=True)
