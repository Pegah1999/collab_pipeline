-- ============================================================================
-- collab_pipeline — Chapter 4, exercise 4.5.1 (pairs, Python)
--
--   raw_survey     (T) : read data/survey.csv
--   cleaned_survey (Python) : src/cleaning.py -> clean_survey_scores()
--                             wired by Developer A in Step 2
--   flagged_survey (Python) : src/cleaning.py -> flag_outliers()
--                             wired in Exercise 2
--
-- Run with: t run src/pipeline.t
-- ============================================================================

p = pipeline {

  -- --------------------------------------------------------------------------
  -- 1. Ingest raw data
  -- --------------------------------------------------------------------------
  -- IPC is declared explicitly so downstream Python nodes can deserialize it
  -- with deserializer = ^ipc.
  raw_survey = node(
    command = read_csv("data/survey.csv"),
    runtime = T,
    serializer = ^ipc
  )

  -- --------------------------------------------------------------------------
  -- 2. Cleaning step — added in Step 2 (Developer A)
  -- --------------------------------------------------------------------------
  -- cleaned_survey = pyn(
  --   command = <{
  --     cleaned_survey = clean_survey_scores(raw_survey)
  --     cleaned_survey
  --   }>,
  --   functions = ["src/cleaning.py"],
  --   deserializer = ^ipc,
  --   serializer = ^ipc
  -- )

}

-- ============================================================================
-- Build
-- ============================================================================
res = build_pipeline(p, verbose = 1)

if (is_error(res)) {
  print("PIPELINE BUILD FAILED")
  print(read_log(p.raw_survey))
  exit(1)
}

print("raw_survey")
print(read_node(p.raw_survey))
