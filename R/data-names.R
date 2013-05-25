map_data_names <- function(opts){
    if (is.null(names(opts$name_mappings))) {
        names(opts$name_mappings) <- rep("", length(opts$name_mappings))
    }

    if (any(names(opts$name_mappings) == "")) {
        missing_names <- opts$name_mappings[names(opts$name_mappings) == ""]
        stop("Every element in name_mappings must be of the form: invalid_name = \"valid_name\"
             \nElements missing names: ", paste(missing_names, collapse = ", "))
    }

    old_names <- names(opts$data)
    invalid_names <- names(opts$name_mappings)
    if (any(invalid_names %notin% old_names)) {
        fake_invalid_names <- invalid_names[invalid_names %notin% old_names]
        if (length(fake_invalid_names) == 1){
            stop("The name \"", paste(fake_invalid_names, collapse = ", "),"\" doesn't appear in your input data")
        } else {
            stop("The names \"", paste(fake_invalid_names, collapse = ", "),"\" don't appear in your input data")
        }
    }

    valid_names <- sapply(opts$name_mappings, "[[", 1)
    all_data_names <- unlist(opts$template_config$data_names)
    if (any(valid_names %notin% all_data_names)){
        unknown_valid_names <- valid_names[valid_names %notin% all_data_names]
        if (length(unknown_valid_names) == 1){
            stop("The name \"", paste(unknown_valid_names, collapse = ", "),"\" is not specified as a valid data_name in the template_config.yml file of the ", opts$name$ractive, " ractive")
        } else {
            stop("The names \"", paste(unknown_valid_names, collapse = ", "),"\" are not specified as valid data_names in the template_config.yml file of the ", opts$name$ractive, " ractive")
        }
    }

    sapply(invalid_names, function(invalid_name){
        message("Renaming ", invalid_name, " => ", valid_names[invalid_name])
    })

    names(opts$data)[match(invalid_names, old_names)] <- valid_names
    opts$data
}

validate_data_names <- function(opts){
    required_names <- opts$template_config$data_names$required
    missing_required_names <- required_names[required_names %notin% names(opts$data)]

    if (!is.null(required_names) && length(missing_required_names) > 0) {
        candidate_names <- names(opts$data)[names(opts$data) %notin% required_names]
        message <- paste0("Your input data is missing the following required data_names: ", paste(missing_required_names, collapse = ", "))
        if (length(candidate_names) == 0){
            stop(message)
        } else {
            stop(message, "\nYou can tell Clickme what name to use through the name_mappings argument:\nExample: clickme(..., name_mappings = c(", candidate_names[1], " = \"", missing_required_names[1], "\"))" )
        }
    }

}
