# to compare data frames:
# https://community.rstudio.com/t/all-equal-on-tibbles-ignores-attributes/4299/2

test_that("import events CSV  works", {
  # reset env
  setup_new_env()

  import_events_csv("./csv/import_events_csv/before-advanced.csv",
                     "PERSON",
                     "TIMESTAMP",
                     "TITLE")

  quiet_read_csv <- purrr::quietly(readr::read_csv)
  excepted <-
    as.data.frame(quiet_read_csv(
      file = "./csv/import_events_csv/after.csv")$result
    )
  # to check dataframes without hash
  expect_equal(
    dplyr::all_equal(analysr_env$events[c("stat_unit", "date", "tag")],
                     excepted), TRUE)

  # check if hash column exist in dataframe
  expect_equal("hash" %in% colnames(analysr_env$events), TRUE)

  # check if hash is first column
  expect_equal("hash", colnames(analysr_env$events)[1])

  # check if current hash has changed in env
  expect_equal(analysr_env$current_hash, 2)
})

test_that("import events CSV works when import twice", {
  # reset env
  setup_new_env()

  # import twice
  import_events_csv("./csv/import_events_csv/before.csv",
                     "PERSON",
                     "TIMESTAMP",
                     "TITLE")
  import_events_csv("./csv/import_events_csv/before.csv",
                     "PERSON",
                     "TIMESTAMP",
                     "TITLE")

  quiet_read_csv <- purrr::quietly(readr::read_csv)
  excepted <-
    as.data.frame(quiet_read_csv(
      file = "./csv/import_events_csv/after2.csv"
    )$result)

  # to check dataframes without hash
  expect_equal(
    dplyr::all_equal(analysr_env$events[c("stat_unit", "date", "tag")],
                     excepted), TRUE)

  # check if hash column exist in dataframe colnames
  expect_equal("hash" %in% colnames(analysr_env$events), TRUE)
  # check if hash is first column
  expect_equal("hash", colnames(analysr_env$events)[1])
})