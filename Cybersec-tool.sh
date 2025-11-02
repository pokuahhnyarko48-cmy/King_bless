#!/bin/bash

# =============================================
# CyberSec Tool Interface for Termux
# Educational Use Only
# =============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           CYBERSEC TOOL INTERFACE           ║"
    echo "║           For Educational Use Only          ║"
    echo "║              Termux Version                ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo
}

# Check Internet Connection
check_internet() {
    echo -e "${YELLOW}[*] Checking internet connection...${NC}"
    
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo -e "${GREEN}[✓] Internet connection available${NC}"
        return 0
    else
        echo -e "${RED}[✗] No internet connection detected${NC}"
        echo -e "${YELLOW}[!] Please check your connection and try again${NC}"
        return 1
    fi
}

# Check and Install Root (sudo)
install_root() {
    echo -e "${YELLOW}[*] Checking root/sudo access...${NC}"
    
    if command -v sudo &> /dev/null; then
        echo -e "${GREEN}[✓] sudo is already installed${NC}"
        return 0
    else
        echo -e "${YELLOW}[!] sudo not found. Installing...${NC}"
        pkg update -y && pkg install -y tsu
        
        if command -v tsu &> /dev/null; then
            echo -e "${GREEN}[✓] tsu (Termux sudo) installed successfully${NC}"
            echo -e "${YELLOW}[!] Note: You may need to run 'tsu' manually for root access${NC}"
            return 0
        else
            echo -e "${RED}[✗] Failed to install root access tools${NC}"
            echo -e "${YELLOW}[!] Continuing with limited functionality${NC}"
            return 1
        fi
    fi
}

# Check Essential Tools
check_tools() {
    echo -e "${YELLOW}[*] Checking essential tools...${NC}"
    
    local tools=("python" "git" "curl" "nmap")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "${GREEN}[✓] $tool installed${NC}"
        else
            echo -e "${RED}[✗] $tool not found${NC}"
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}[!] Some tools are missing. Install them? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            pkg update -y
            for tool in "${missing_tools[@]}"; do
                echo -e "${YELLOW}[*] Installing $tool...${NC}"
                pkg install -y "$tool"
            done
        fi
    fi
}

# Main Menu
main_menu() {
    while true; do
        banner
        echo -e "${BLUE}=== MAIN MENU ===${NC}"
        echo -e "${GREEN}1. Network Scanning Tools"
        echo -e "2. Vulnerability Assessment"
        echo -e "3. Password Security Tools"
        echo -e "4. Information Gathering"
        echo -e "5. System Information"
        echo -e "6. Update Tools"
        echo -e "7. Install Additional Tools"
        echo -e "0. Exit${NC}"
        echo
        echo -e "${YELLOW}Select an option: ${NC}"
        read -r choice
        
        case $choice in
            1) network_menu ;;
            2) vulnerability_menu ;;
            3) password_menu ;;
            4) info_gathering_menu ;;
            5) system_info ;;
            6) update_tools ;;
            7) install_additional_tools ;;
            0) 
                echo -e "${GREEN}[+] Thank you for using CyberSec Tool Interface!${NC}"
                exit 0 
                ;;
            *) 
                echo -e "${RED}[!] Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Network Scanning Menu
network_menu() {
    while true; do
        banner
        echo -e "${BLUE}=== NETWORK SCANNING ===${NC}"
        echo -e "${GREEN}1. Quick Network Scan"
        echo -e "2. Port Scan Specific Target"
        echo -e "3. Service Version Detection"
        echo -e "4. OS Detection Scan"
        echo -e "5. Back to Main Menu${NC}"
        echo
        echo -e "${YELLOW}Select an option: ${NC}"
        read -r choice
        
        case $choice in
            1)
                echo -e "${YELLOW}[*] Performing quick network scan...${NC}"
                if command -v nmap &> /dev/null; then
                    nmap -sn 192.168.1.0/24
                else
                    echo -e "${RED}[!] nmap not installed. Install it first.${NC}"
                fi
                pause
                ;;
            2)
                echo -e "${YELLOW}Enter target IP or hostname: ${NC}"
                read -r target
                if command -v nmap &> /dev/null; then
                    nmap -p- "$target"
                else
                    echo -e "${RED}[!] nmap not installed. Install it first.${NC}"
                fi
                pause
                ;;
            3)
                echo -e "${YELLOW}Enter target IP or hostname: ${NC}"
                read -r target
                if command -v nmap &> /dev/null; then
                    nmap -sV "$target"
                else
                    echo -e "${RED}[!] nmap not installed. Install it first.${NC}"
                fi
                pause
                ;;
            4)
                echo -e "${YELLOW}Enter target IP or hostname: ${NC}"
                read -r target
                if command -v nmap &> /dev/null; then
                    nmap -O "$target"
                else
                    echo -e "${RED}[!] nmap not installed. Install it first.${NC}"
                fi
                pause
                ;;
            5) return ;;
            *) 
                echo -e "${RED}[!] Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Vulnerability Assessment Menu
vulnerability_menu() {
    banner
    echo -e "${BLUE}=== VULNERABILITY ASSESSMENT ===${NC}"
    echo -e "${YELLOW}[!] This feature requires additional tools${NC}"
    echo -e "${YELLOW}[!] Would you like to install vulnerability tools? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        install_vulnerability_tools
    fi
    pause
}

# Password Security Menu
password_menu() {
    banner
    echo -e "${BLUE}=== PASSWORD SECURITY ===${NC}"
    echo -e "${YELLOW}[!] Educational password analysis tools${NC}"
    echo
    echo -e "${GREEN}1. Password Strength Checker"
    echo -e "2. Hash Generator"
    echo -e "3. Back to Main Menu${NC}"
    echo
    echo -e "${YELLOW}Select an option: ${NC}"
    read -r choice
    
    case $choice in
        1) password_strength_checker ;;
        2) hash_generator ;;
        3) return ;;
        *) 
            echo -e "${RED}[!] Invalid option${NC}"
            sleep 2
            ;;
    esac
}

# Information Gathering Menu
info_gathering_menu() {
    banner
    echo -e "${BLUE}=== INFORMATION GATHERING ===${NC}"
    echo -e "${GREEN}1. WHOIS Lookup"
    echo -e "2. DNS Information"
    echo -e "3. Subdomain Enumeration"
    echo -e "4. Back to Main Menu${NC}"
    echo
    echo -e "${YELLOW}Select an option: ${NC}"
    read -r choice
    
    case $choice in
        1)
            echo -e "${YELLOW}Enter domain: ${NC}"
            read -r domain
            whois "$domain" 2>/dev/null || echo -e "${RED}[!] whois not available${NC}"
            pause
            ;;
        2)
            echo -e "${YELLOW}Enter domain: ${NC}"
            read -r domain
            dig "$domain" ANY 2>/dev/null || echo -e "${RED}[!] dig not available${NC}"
            pause
            ;;
        3)
            echo -e "${YELLOW}[!] Subdomain enumeration requires additional tools${NC}"
            pause
            ;;
        4) return ;;
        *) 
            echo -e "${RED}[!] Invalid option${NC}"
            sleep 2
            ;;
    esac
}

# System Information
system_info() {
    banner
    echo -e "${BLUE}=== SYSTEM INFORMATION ===${NC}"
    echo -e "${GREEN}Hostname: $(hostname)${NC}"
    echo -e "${GREEN}OS: $(uname -o)${NC}"
    echo -e "${GREEN}Kernel: $(uname -r)${NC}"
    echo -e "${GREEN}Architecture: $(uname -m)${NC}"
    echo
    echo -e "${YELLOW}Network Information:${NC}"
    ifconfig 2>/dev/null || ip address 2>/dev/null || echo -e "${RED}[!] Network tools not available${NC}"
    pause
}

# Update Tools
update_tools() {
    banner
    echo -e "${YELLOW}[*] Updating package repositories...${NC}"
    pkg update -y
    echo -e "${YELLOW}[*] Upgrading packages...${NC}"
    pkg upgrade -y
    echo -e "${GREEN}[✓] System updated successfully${NC}"
    pause
}

# Install Additional Tools
install_additional_tools() {
    banner
    echo -e "${BLUE}=== ADDITIONAL TOOLS ===${NC}"
    echo -e "${GREEN}1. Install All Basic Tools"
    echo -e "2. Install Metasploit Framework"
    echo -e "3. Install SQLMap"
    echo -e "4. Install Wireshark"
    echo -e "5. Back to Main Menu${NC}"
    echo
    echo -e "${YELLOW}Select an option: ${NC}"
    read -r choice
    
    case $choice in
        1)
            install_basic_tools
            ;;
        2)
            echo -e "${YELLOW}[!] Metasploit installation can be complex on Termux${NC}"
            echo -e "${YELLOW}[!] Consider using Termux proot-distro for better compatibility${NC}"
            pause
            ;;
        3)
            pkg install -y sqlmap
            ;;
        4)
            pkg install -y wireshark
            ;;
        5) return ;;
        *) 
            echo -e "${RED}[!] Invalid option${NC}"
            sleep 2
            ;;
    esac
}

# Install Basic Tools
install_basic_tools() {
    banner
    echo -e "${YELLOW}[*] Installing basic cybersecurity tools...${NC}"
    
    local basic_tools=("nmap" "python" "git" "curl" "wget" "whois" "dnsutils")
    
    for tool in "${basic_tools[@]}"; do
        echo -e "${YELLOW}[*] Installing $tool...${NC}"
        pkg install -y "$tool"
    done
    
    echo -e "${GREEN}[✓] Basic tools installation completed${NC}"
    pause
}

# Install Vulnerability Tools
install_vulnerability_tools() {
    echo -e "${YELLOW}[*] Installing vulnerability assessment tools...${NC}"
    pkg install -y nmap python git
    
    # Install Python security tools
    pip install --upgrade pip
    pip install requests beautifulsoup4
    
    echo -e "${GREEN}[✓] Vulnerability tools installed${NC}"
}

# Password Strength Checker
password_strength_checker() {
    banner
    echo -e "${BLUE}=== PASSWORD STRENGTH CHECKER ===${NC}"
    echo -e "${YELLOW}Enter password to check: ${NC}"
    read -r password
    
    local strength=0
    local length=${#password}
    
    if [ $length -ge 8 ]; then
        ((strength++))
        echo -e "${GREEN}[✓] Good length${NC}"
    else
        echo -e "${RED}[✗] Too short (min 8 characters)${NC}"
    fi
    
    if [[ "$password" =~ [A-Z] ]]; then
        ((strength++))
        echo -e "${GREEN}[✓] Contains uppercase letters${NC}"
    else
        echo -e "${RED}[✗] No uppercase letters${NC}"
    fi
    
    if [[ "$password" =~ [a-z] ]]; then
        ((strength++))
        echo -e "${GREEN}[✓] Contains lowercase letters${NC}"
    else
        echo -e "${RED}[✗] No lowercase letters${NC}"
    fi
    
    if [[ "$password" =~ [0-9] ]]; then
        ((strength++))
        echo -e "${GREEN}[✓] Contains numbers${NC}"
    else
        echo -e "${RED}[✗] No numbers${NC}"
    fi
    
    if [[ "$password" =~ [!@#\$%^\&*()_+\-] ]]; then
        ((strength++))
        echo -e "${GREEN}[✓] Contains special characters${NC}"
    else
        echo -e "${RED}[✗] No special characters${NC}"
    fi
    
    echo
    case $strength in
        5) echo -e "${GREEN}[✓] Excellent password strength!${NC}" ;;
        4) echo -e "${GREEN}[✓] Strong password${NC}" ;;
        3) echo -e "${YELLOW}[!] Moderate password strength${NC}" ;;
        *) echo -e "${RED}[✗] Weak password - consider improving${NC}" ;;
    esac
    pause
}

# Hash Generator
hash_generator() {
    banner
    echo -e "${BLUE}=== HASH GENERATOR ===${NC}"
    echo -e "${YELLOW}Enter text to hash: ${NC}"
    read -r text
    
    if command -v md5sum &> /dev/null; then
        echo -e "${GREEN}MD5: $(echo -n "$text" | md5sum | cut -d' ' -f1)${NC}"
    fi
    
    if command -v sha1sum &> /dev/null; then
        echo -e "${GREEN}SHA1: $(echo -n "$text" | sha1sum | cut -d' ' -f1)${NC}"
    fi
    
    if command -v sha256sum &> /dev/null; then
        echo -e "${GREEN}SHA256: $(echo -n "$text" | sha256sum | cut -d' ' -f1)${NC}"
    fi
    pause
}

# Pause function
pause() {
    echo
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Disclaimer
disclaimer() {
    banner
    echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                   WARNING                    ║${NC}"
    echo -e "${RED}║                                              ║${NC}"
    echo -e "${RED}║  THIS TOOL IS FOR EDUCATIONAL PURPOSES ONLY  ║${NC}"
    echo -e "${RED}║  Use only on systems you own or have         ║${NC}"
    echo -e "${RED}║  explicit permission to test.                ║${NC}"
    echo -e "${RED}║                                              ║${NC}"
    echo -e "${RED}║  The developers are not responsible for      ║${NC}"
    echo -e "${RED}║  any misuse or damage caused by this tool.   ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Do you agree to use this tool responsibly? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${RED}[!] Exiting. Please use responsibly.${NC}"
        exit 1
    fi
}

# Main function
main() {
    disclaimer
    
    # Initial checks
    if ! check_internet; then
        echo -e "${RED}[!] Exiting due to no internet connection${NC}"
        exit 1
    fi
    
    install_root
    check_tools
    
    echo -e "${GREEN}[✓] Initialization complete!${NC}"
    sleep 2
    
    main_menu
}

# Run main function
main
