# packer-azure-methods

This repository contains Packer configurations and scripts for building Azure images.

## Project Structure

- `devops-agent.pkr.hcl`: Packer configuration file for building Azure DevOps agent images
- `ansible/`: Contains Ansible playbooks and roles used during image building
- `scripts/`: Contains helper scripts for various image building tasks

## Prerequisites

- Packer installed on your system
- Azure CLI installed and authenticated
- Azure subscription with appropriate permissions

## Usage

1. Clone this repository
2. Configure your Azure credentials
3. Run Packer build:
   ```bash
   packer build devops-agent.pkr.hcl
   ```

## License

This project is licensed under the terms of the LICENSE file.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.