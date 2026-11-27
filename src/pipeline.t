-- collab_pipeline - chapter 4 exercise 4.5.1 (pairs, Python language)
-- Node 1: raw_survey, reads data/survey.csv
-- Step 2 adds cleaned_survey, a pyn() node using src/cleaning.py

p = pipeline {

  raw_survey = node(
    command = read_csv("data/survey.csv"),
    runtime = T,
    serializer = ^ipc
  )

}

res = build_pipeline(p, verbose = 1)

if (is_error(res)) {
  print("PIPELINE BUILD FAILED")
  print(read_log(p.raw_survey))
  exit(1)
}

print(read_node(p.raw_survey))
