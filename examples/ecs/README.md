This example deploys Kosli reporter to track what is running in a specific AWS ECS service within a cluster. Assume your Kosli organisation name is `my_org`, Kosli environment name is `staging`, the ECS service `my-service` is running in the `my_ecs_cluster`. To report what is running in an entire AWS ECS cluster just omit the `kosli_command_optional_parameters` variable.