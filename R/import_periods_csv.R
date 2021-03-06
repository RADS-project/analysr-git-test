#' import_periods_csv
#'
#' Import periods from a CSV file
#'
#' @return The periods data frame resulted from the merge of imported data
#' and already imported data
#'
#' @param csv_path A path to the csv file.
#' @param stat_unit A string containing the stat_unit label.
#' @param begin A string containing the begin date label.
#' @param end A string containing the end date label.
#' @param tag A string containing the tag label.
#' @param optional_data A vector containing label to import in descriptions
#' table.
#' @param date_format_func A function to format date with (not required).
#' Default: `lubridate::parse_date_time(x, date_format_reg)`
#' @param date_format_reg A expression to format date with (not required).
#' Default: `"ymd-HMS"`
#'
#' @export
import_periods_csv <-
  function(csv_path,
            stat_unit = "stat_unit",
            begin = "begin",
            end = "end",
            tag = "tag",
            optional_data,
            date_format_func =
                  (function(x) lubridate::parse_date_time(x, date_format_reg)),
            date_format_reg = "ymd-HMS") {
    quiet_read_csv <- purrr::quietly(readr::read_csv)

    result <- quiet_read_csv(file = csv_path,
                             col_types = readr::cols(begin = "c", end = "c")
                             )$result
    result <- as.data.frame(result)

    n <- nrow(result)
    hash <- get_hash(n)

    if (!missing(optional_data)) {
      fill_descriptions(hash, optional_data, result, n)
    }

    result <- result[c(stat_unit, begin, end, tag)]
    # we could use dplyr to extract colums https://bit.ly/32lGkNR
    colnames(result) <- c("stat_unit", "begin", "end", "tag")

    add_stat_units(result$stat_unit)

    result$begin <- date_format_func(result$begin)
    result$end <- date_format_func(result$end)

    result <- cbind(
      hash,
      result
    )

    analysr_env$periods <- rbind(analysr_env$periods, result)
    result
  }
