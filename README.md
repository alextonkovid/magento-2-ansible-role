
# **Ansible Playbook for Magento 2 Ubuntu 20.04 Setup**

## **Overview**
This Ansible playbook automates the installation and configuration of essential services and software on an Ubuntu 20.04 server, including:

- **Web Server**: Nginx 1.24  
- **Database**: MariaDB 10.6 with phpMyAdmin  
- **Search Engine**: Elasticsearch 8.11  
- **PHP Stack**: PHP 8.2 with required extensions  
- **Composer**: Composer 2.7  
- **Mail Transfer Agent**: Postfix 

The playbook also ensures optimal PHP configuration settings.

---

## **Installation and Setup**

### **Prerequisites**
- Ubuntu 20.04 server
- Ansible installed on the control node
- SSH access to the target server

### **Steps to Use**
1. Clone the repository:
   ```sh
   git clone https://github.com/alextonkovid/magento-2-ansible-role
   cd magento-2-ansible-role
   ```
2. Update the inventory file with your server details.
3. Run the playbook:
   ```sh
   ansible-playbook -i hosts playbook.yml
   ```

---

## **Installed Packages**

### **Core Packages**
- **Composer**: Version 2.7  
- **Elasticsearch**: Version 8.11  
- **MariaDB**: Version 10.6 with phpMyAdmin  
- **PHP**: Version 8.2  
- **Nginx**: Version 1.24  
- **Mail Transfer Agent**: Configurable (e.g., Postfix)

### **PHP Extensions**
- `bcmath`, `ctype`, `curl`, `dom`, `fileinfo`, `filter`, `gd`, `hash`, `iconv`, `intl`, `json`, `libxml`, `mbstring`, `openssl`, `pcre`, `pdo_mysql`, `simplexml`, `soap`, `sockets`, `sodium`, `tokenizer`, `xmlwriter`, `xsl`, `zip`, `zlib`, `libxml`

### **PHP Configuration**
- `realpath_cache_size=10M`
- `realpath_cache_ttl=7200`
- `memory_limit=4G`

---

## **Future Enhancements**
- Automated SSL setup with Let's Encrypt
- Additional security hardening
- Performance tuning for MariaDB and Elasticsearch
