
validate_data_names <- function(data, opts) {
    if (any(opts$template_config$valid_names %notin% names(data))){
        invalid_names <- names(data)[names(data) %notin% opts$template_config$valid_names]
        missing_valid_names <- opts$template_config$valid_names[opts$template_config$valid_names %notin% names(data)]

        if (length(invalid_names) < length(missing_valid_names)) stop("The data object is missing the following names: ", paste(missing_valid_names))

        for(mvn in missing_valid_names){
            message("Renaming: ", invalid_names[1], " => ", mvn)
            names(data)[which(names(data) == invalid_names[1])] <- mvn
            invalid_names <- invalid_names[-1]
        }
    }

    data
}