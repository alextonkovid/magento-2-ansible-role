#!/bin/bash

# Create role directories
mkdir -p roles/composer/{tasks,vars}
mkdir -p roles/elasticsearch/{tasks,vars}
mkdir -p roles/mariadb/{tasks,vars}
mkdir -p roles/nginx/{tasks,vars}
mkdir -p roles/phpmyadmin/{tasks,vars}
mkdir -p roles/postfix/{tasks,vars}
mkdir -p roles/php_settings/{tasks,vars}

# Create files with basic content
cat <<EOF > roles/composer/tasks/main.yml
- name: Ensure Composer is installed
  apt:
    name: composer
    state: present
EOF

cat <<EOF > roles/composer/vars/main.yml
---
composer_version: "2.7"
EOF

cat <<EOF > roles/elasticsearch/tasks/main.yml
- name: Install Elastic Repository
  yum_repository:
    name: elasticsearch
    description: Elastic Package Repository for Elasticsearch
    baseurl: https://artifacts.elastic.co/packages/8.x/apt stable main
    enabled: yes
    gpgcheck: yes
    gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch

- name: Install Elasticsearch
  apt:
    name: elasticsearch
    state: present

- name: Configure Elasticsearch
  lineinfile:
    path: /etc/elasticsearch/elasticsearch.yml
    regexp: '^network.host'
    line: 'network.host: 0.0.0.0'

- name: Start and Enable Elasticsearch Service
  service:
    name: elasticsearch
    state: started
    enabled: yes
EOF

cat <<EOF > roles/elasticsearch/vars/main.yml
---
elasticsearch_version: "8.2"
EOF

cat <<EOF > roles/mariadb/tasks/main.yml
- name: Install MariaDB
  apt:
    name: mariadb-server
    state: present

- name: Start and Enable MariaDB Service
  service:
    name: mariadb
    state: started
    enabled: yes

- name: Configure MariaDB for local delivery
  lineinfile:
    path: /etc/mysql/my.cnf.d/mariadb.cnf
    regexp: '^bind-address'
    line: 'bind-address = 127.0.0.1'
EOF

cat <<EOF > roles/mariadb/vars/main.yml
---
mariadb_version: "10.5"
EOF

cat <<EOF > roles/nginx/tasks/main.yml
- name: Install Nginx
  apt:
    name: nginx
    state: present

- name: Start and Enable Nginx Service
  service:
    name: nginx
    state: started
    enabled: yes
EOF

cat <<EOF > roles/nginx/vars/main.yml
---
nginx_version: "1.21"
EOF

cat <<EOF > roles/phpmyadmin/tasks/main.yml
- name: Install PHPMyAdmin
  apt:
    name: phpmyadmin
    state: present
    update_cache: yes

- name: Configure PHPMyAdmin to use Nginx
  template:
    src: templates/phpmyadmin.conf.j2
    dest: /etc/nginx/sites-available/phpmyadmin
  notify:
    - restart nginx

- name: Enable PHPMyAdmin site
  file:
    src: /etc/nginx/sites-available/phpmyadmin
    dest: /etc/nginx/sites-enabled/
    state: link

- name: Configure PHPMyAdmin database
  mysql_user:
    name: root
    host: localhost
    password: your_root_password
    priv: '*.*:ALL'
    state: present

- name: Import default configuration for phpmyadmin database
  copy:
    src: templates/config.inc.php.j2
    dest: /etc/phpmyadmin/config.inc.php
EOF

cat <<EOF > roles/phpmyadmin/vars/main.yml
---
phpmyadmin_version: "5.2"
EOF

cat <<EOF > roles/postfix/tasks/main.yml
- name: Install Postfix
  apt:
    name: postfix
    state: present

- name: Configure Postfix for local delivery
  lineinfile:
    path: /etc/postfix/main.cf
    regexp: '^myhostname'
    line: 'myhostname = localhost'

- name: Start and Enable Postfix Service
  service:
    name: postfix
    state: started
    enabled: yes
EOF

cat <<EOF > roles/postfix/vars/main.yml
---
postfix_version: "3.6"
EOF

cat <<EOF > roles/php_settings/tasks/main.yml
- name: Set PHP realpath_cache_size
  lineinfile:
    path: /etc/php/8.2/fpm/php.ini
    regexp: '^realpath_cache_size'
    line: 'realpath_cache_size = 10M'

- name: Set PHP realpath_cache_ttl
  lineinfile:
    path: /etc/php/8.2/fpm/php.ini
    regexp: '^realpath_cache_ttl'
    line: 'realpath_cache_ttl = 7200'

- name: Set PHP memory limit
  lineinfile:
    path: /etc/php/8.2/fpm/php.ini
    regexp: '^memory_limit'
    line: 'memory_limit = 1G'
EOF

cat <<EOF > roles/php_settings/vars/main.yml
---
php_settings_version: "8.2"
EOF

echo "Files and directories created successfully."