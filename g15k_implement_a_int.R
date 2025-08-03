# g15k_implement_a_int.R

# Load necessary libraries
library(plumber)
library(jsonlite)
library(httr)

# Define API Simulator Configuration
api_config <- list(
  port = 8080,
  host = "localhost",
  endpoints = list(
    "/users" = list(
      method = "GET",
      response = list(
        status_code = 200,
        body = jsonlite::toJSON(list(
          users = list(
            list(id = 1, name = "John Doe", email = "john@example.com"),
            list(id = 2, name = "Jane Doe", email = "jane@example.com")
          )
        ))
      )
    ),
    "/users/{id}" = list(
      method = "GET",
      response = list(
        status_code = 200,
        body = jsonlite::toJSON(list(
          user = list(id = 1, name = "John Doe", email = "john@example.com")
        ))
      )
    ),
    "/orders" = list(
      method = "POST",
      response = list(
        status_code = 201,
        body = jsonlite::toJSON(list(
          order = list(id = 1, user_id = 1, total = 100.0)
        ))
      )
    )
  )
)

# Create API Simulator
api <- plumb("api_simulator.r")
api$run(port = api_config$port, host = api_config$host)

# Define API Endpoints
api$GET("/users", function(req, res) {
  res$status_code <- api_config$endpoints[["/users"]][["response"]][["status_code"]]
  res$body <- api_config$endpoints[["/users"]][["response"]][["body"]]
  res$ headers <- c(`Content-Type` = "application/json")
})

api$GET("/users/{id}", function(req, res, id) {
  res$status_code <- api_config$endpoints[["/users/{id}"]][["response"]][["status_code"]]
  res$body <- api_config$endpoints[["/users/{id}"]][["response"]][["body"]]
  res$ headers <- c(`Content-Type` = "application/json")
})

api$POST("/orders", function(req, res, body) {
  res$status_code <- api_config$endpoints[["/orders"]][["response"]][["status_code"]]
  res$body <- api_config$endpoints[["/orders"]][["response"]][["body"]]
  res$ headers <- c(`Content-Type` = "application/json")
})

# Start API Simulator
api