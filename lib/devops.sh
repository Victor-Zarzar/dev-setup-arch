#!/bin/bash

# ============================================
# DevOps Tools Installation Functions
# ============================================

install_prometheus() {
    print_section "Installing Prometheus"

    if command_exists prometheus; then
        print_info "Prometheus already installed ($(prometheus --version 2>&1 | head -n1))"
        return 0
    fi

    pacman_install "prometheus" "Prometheus"
}

install_terraform() {
    print_section "Installing Terraform"

    if command_exists terraform; then
        print_info "Terraform already installed ($(terraform version | head -n1))"
        return 0
    fi

    yay_install "terraform" "Terraform"
}

install_aws_cli() {
    print_section "Installing AWS CLI"

    if command_exists aws; then
        print_info "AWS CLI already installed ($(aws --version))"
        return 0
    fi

    yay_install "aws-cli-v2" "AWS CLI v2"
}

install_azure_cli() {
    print_section "Installing Azure CLI"

    if command_exists az; then
        print_info "Azure CLI already installed ($(az --version | head -n1))"
        return 0
    fi

    yay_install "azure-cli" "Azure CLI"
}

install_ansible() {
    print_section "Installing Ansible"

    if command_exists ansible; then
        print_info "Ansible already installed ($(ansible --version | head -n1))"
        return 0
    fi

    pacman_install "ansible" "Ansible"
}

install_kubectl() {
    print_section "Installing Kubernetes (kubectl)"

    if command_exists kubectl; then
        print_info "kubectl already installed ($(kubectl version --client 2>/dev/null))"
        return 0
    fi

    pacman_install "kubectl" "kubectl"
}

install_minikube() {
    print_section "Installing Minikube"

    if command_exists minikube; then
        print_info "Minikube already installed ($(minikube version --short 2>/dev/null))"
        return 0
    fi

    pacman_install "minikube" "Minikube"
}

install_eksctl() {
    print_section "Installing eksctl"

    if command_exists eksctl; then
        print_info "eksctl already installed ($(eksctl version))"
        return 0
    fi

    # eksctl moved from AUR (eksctl-bin, unmaintained) into the official
    # extra repo, so pacman handles it directly now.
    pacman_install "eksctl" "eksctl"
}

install_devops_tools() {
    print_section "Installing DevOps Tools"

    install_prometheus
    install_terraform
    install_aws_cli
    install_azure_cli
    install_ansible
    install_kubectl
    install_minikube
    install_eksctl

    log_action "DevOps tools installed (Prometheus, Terraform, AWS CLI, Azure CLI, Ansible, kubectl, Minikube, eksctl)"
}
