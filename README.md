# Docker Vendoring Script for Air-Gapped Environments

This script serves as an example of a Docker vendoring pattern, particularly useful for air-gapped (or disconnected) environments. It's designed to build and optionally push a Docker container for AWS Fluent Bit to an Amazon Elastic Container Registry (ECR). The script automates the fetching of the latest tag for the AWS Fluent Bit container from Docker Hub, builds an image with this tag and the current Git SHA, and can push this image to a specified AWS ECR repository.

## Prerequisites

- Docker: Required for building Docker images.
- AWS CLI: Needed for interactions with AWS ECR.
- jq: A command-line JSON processor, used for parsing API responses.
- Git: For determining the current Git SHA.

## Usage in Air-Gapped Environments

In air-gapped environments, where direct access to public Docker registries is not possible, this script can be used in a networked environment to pull the latest images and then transfer them to the air-gapped environment for deployment.

### Commands

To build the container image locally:

```bash
./build.sh
```

To build the container image and push to AWS ECR:

```bash
./build.sh push-to-ecr
```

## Configuration

Set the following variable before running the script:

- `my_ecr_account`: Your AWS ECR account number.

## Note on customisation for your particular environment e.g. `config.conf`

The `build_image` function in the script expects a `config/config.conf` file to be present in the same directory as the script. This configuration file is copied into the Docker image during the build process. Ensure that `config.conf` is correctly configured for your use case before running the script.

## Script Functions

- `get_latest_tag()`: Fetches the latest AWS Fluent Bit container tag from Docker Hub.
- `build_image()`: Builds the Docker image with the fetched tag and current Git SHA.
- `login_to_ecr()`: Handles AWS ECR login.
- `check_container_existence()`: Checks if the container with a specific tag exists in ECR.
- `docker_push()`: Pushes the Docker image to AWS ECR.
- `main()`: Orchestrates the build and push process.

## Error Handling

The script includes basic error handling for critical operations, ensuring robustness in automation workflows.

## Contributions

Contributions are welcome. Ensure that any changes maintain existing functionality and adhere to coding standards.

## License

MIT License

Copyright (c) 2023 Martin Jackson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

*Note*: This script is provided as an example and may require modifications to fit specific requirements in your air-gapped environment.
