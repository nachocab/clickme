context("Heatmap data")

test_that("format_heatmap_data", {
    params <- list(data = data.frame(x = 1:10, y = 11:20))
    heatmap <- Heatmap$new(params)
    formatted_data <- heatmap$format_heatmap_data(params$data, colnames(params$data))
    expect_equal(no_whitespace(to_json(formatted_data)), no_whitespace('[ {"col_values": [ {"row_values": [{"cell_value": 1}, {"cell_value": 11}] },
                                                                                           {"row_values": [{"cell_value": 2}, {"cell_value": 12}] },
                                                                                           {"row_values": [{"cell_value": 3}, {"cell_value": 13}] },
                                                                                           {"row_values": [{"cell_value": 4}, {"cell_value": 14}] },
                                                                                           {"row_values": [{"cell_value": 5}, {"cell_value": 15}] },
                                                                                           {"row_values": [{"cell_value": 6}, {"cell_value": 16}] },
                                                                                           {"row_values": [{"cell_value": 7}, {"cell_value": 17}] },
                                                                                           {"row_values": [{"cell_value": 8}, {"cell_value": 18}] },
                                                                                           {"row_values": [{"cell_value": 9}, {"cell_value": 19}] },
                                                                                           {"row_values": [{"cell_value": 10}, {"cell_value": 20}] }],
                                                                           "col_names": [ "x", "y" ] }
                                                                        ]'), info = "neither col_groups nor row_groups")

    col_groups <- factor(c("x","x","y","y"), levels= c("y", "x"))
    params <- list(data = data.frame(x1 = 1:3, x2 = 4:6, y1 = 7:9, y2 = 10:12), col_groups = col_groups)
    heatmap <- Heatmap$new(params)
    formatted_data <- heatmap$format_heatmap_data(params$data, colnames(params$data))
    expect_equal(no_whitespace(to_json(formatted_data)), no_whitespace('[ {"col_values": [ {"row_values": [{"cell_value": 7},{"cell_value": 10}] },
                                                                                           {"row_values": [{"cell_value": 8},{"cell_value": 11}] },
                                                                                           {"row_values": [{"cell_value": 9},{"cell_value": 12}] }],
                                                                           "col_names": ["y1","y2"],
                                                                           "col_group_name": "y" },

                                                                          {"col_values": [ {"row_values": [{"cell_value": 1},{"cell_value": 4}] },
                                                                                           {"row_values": [{"cell_value": 2},{"cell_value": 5}] },
                                                                                           {"row_values": [{"cell_value": 3},{"cell_value": 6}] }],
                                                                           "col_names": ["x1","x2"],
                                                                           "col_group_name": "x" }
                                                                        ]'), info = "only col_groups")

    row_groups <- c("a","a","b","b")
    params <- list(data = data.frame(x = 1:4, y = 5:8), row_groups = row_groups)
    heatmap <- Heatmap$new(params)
    formatted_data <- heatmap$format_heatmap_data(params$data, colnames(params$data))
    expect_equal(no_whitespace(to_json(formatted_data)), no_whitespace('[ {"col_values": [ {"row_values": [{"cell_value": 1},{"cell_value": 5}] },
                                                                                           {"row_values": [{"cell_value": 2},{"cell_value": 6}] },
                                                                                           {"row_values": [{"cell_value": 3},{"cell_value": 7}] },
                                                                                           {"row_values": [{"cell_value": 4},{"cell_value": 8}] }],
                                                                           "col_names": ["x","y"],
                                                                           "row_group_names": ["a","a","b","b"]}
                                                                        ]'), info = "only row_groups")

    row_groups <- c("a","a","b","b")
    col_groups <- factor(c("x","x","y","y"), levels= c("y", "x"))
    params <- list(data = data.frame(x1 = 1:4, x2 = 5:8, y1 = 9:12, y2 = 13:16), row_groups = row_groups, col_groups = col_groups)
    heatmap <- Heatmap$new(params)
    formatted_data <- heatmap$format_heatmap_data(params$data, colnames(params$data))
    expect_equal(no_whitespace(to_json(formatted_data)), no_whitespace('[ {"col_values": [ {"row_values": [{"cell_value": 9},{"cell_value": 13}] },
                                                                                           {"row_values": [{"cell_value": 10},{"cell_value": 14}] },
                                                                                           {"row_values": [{"cell_value": 11},{"cell_value": 15}] },
                                                                                           {"row_values": [{"cell_value": 12},{"cell_value": 16}] }],
                                                                           "col_names": ["y1","y2"],
                                                                           "col_group_name": "y",
                                                                           "row_group_names": ["a","a","b","b"]},

                                                                          {"col_values": [ {"row_values": [{"cell_value": 1},{"cell_value": 5}] },
                                                                                           {"row_values": [{"cell_value": 2},{"cell_value": 6}] },
                                                                                           {"row_values": [{"cell_value": 3},{"cell_value": 7}] },
                                                                                           {"row_values": [{"cell_value": 4},{"cell_value": 8}] }],
                                                                           "col_names": ["x1","x2"],
                                                                           "col_group_name": "x",
                                                                           "row_group_names": ["a","a","b","b"]}
                                                                        ]'), info = "row_groups and col_groups")
})


context("Heatmap sanity")

test_that("template is generated", {
    clickme(heatmap, mat(nrow = 10, ncol = 5))
})
