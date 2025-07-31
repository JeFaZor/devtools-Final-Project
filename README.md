# Joomla Docker Project - Final DevTools Assignment

## 👥 Team Members

**Lior Toledano**
- GitHub: [JeFaZor](https://github.com/JeFaZor)
- Email: toledano.lior@s.afeka.ac.il
- Articles: "Git Repository", "The CD Command", "Advanced Package Tool (APT)"

**Ido Bashari**
- GitHub: idobashari
- Email: ido1227@gmail.com
- Articles: "Linux Operating System", "Linus Torvalds", "Git Commit Command"

**Yuval Nurlian**
- GitHub: yuval.nurlian  
- Articles: "GitHub", "Echo", "Branch"

---

## 📋 Project Description

This project demonstrates **complete Joomla CMS deployment using Docker** with automated backup/restore capabilities and Git integration. The assignment required creating a containerized web application with database, automation scripts, and team collaboration.

---

## 🛠 Technologies Used

- **Docker** - Container platform (MySQL 8.0 + Joomla)
- **Bash Scripts** - Automation (setup, backup, restore, cleanup)
- **Git** - Version control and backup management
- **Joomla CMS** - Content management system
- **Ubuntu Linux** - Operating system

---

## 🏗 System Configuration

### Docker Setup
- **Network:** `joomla-network`
- **MySQL Container:** `mysql-joomla` (Port 3306)
- **Joomla Container:** `joomla-app` (Port 8080)

### Access Information
- **Site:** http://YOUR-IP:8080
- **Admin Panel:** http://YOUR-IP:8080/administrator
- **Username:** demoadmin | **Password:** secretpassword

### Database Details
- **Host:** mysql-joomla
- **Database:** joomla_db
- **User:** joomla_user
- **Password:** my-secret-pw

---

## 📁 Project Files

```
devtools-Final-Project/
├── setup.sh              # Complete system setup
├── backup.sh             # Database backup + Git push  
├── restore.sh            # Restore from backup
├── cleanup.sh            # System cleanup
├── README.md             # Documentation
└── *.sql.gz              # Database backups
```

---

## 🚀 Installation Guide

### Prerequisites
- Ubuntu Linux with Docker installed
- Git installed
- Internet connection

### Step-by-Step Setup

**1. Clone Repository**
```bash
git clone https://github.com/JeFaZor/devtools-Final-Project.git
cd devtools-Final-Project
chmod +x *.sh
```

**2. Setup System**
```bash
./setup.sh
```
*This automatically downloads images, creates containers, and restores existing content*

**3. Access Website**
- Open browser: `http://YOUR-IP:8080`
- Admin panel: `http://YOUR-IP:8080/administrator`
- Login with: demoadmin / secretpassword

**4. Add Content & Backup**
- Create articles in admin panel
- Run backup: `./backup.sh`

---

## 📜 Script Functions

### setup.sh
Creates complete Docker environment with MySQL and Joomla containers. Automatically restores existing backup if found.

### backup.sh  
Creates database backup with timestamp, backs up Joomla files, and pushes to Git repository.

### restore.sh
Restores system from backup file. Usage: `./restore.sh [backup_file.sql.gz]`

### cleanup.sh
Removes all containers, volumes, and optionally Docker images. Interactive prompts for safety.

---

## 📝 Content Created

**Total: 9 Articles across 3 team members**

Each team member created 3 articles demonstrating the system works across multiple users and Git collaboration.

---

## 🔄 Backup Strategy

- **Automatic**: setup.sh restores existing backup
- **Manual**: backup.sh creates timestamped backups  
- **Git Integration**: All backups automatically pushed to repository
- **Cross-System**: Backups work on any machine with Docker

---

## 🛠 Troubleshooting

**If containers don't start:**
```bash
docker ps -a
docker logs mysql-joomla
docker logs joomla-app
```

**If site not accessible:**
```bash
hostname -I  # Check your IP
netstat -tlnp | grep 8080  # Check port
```

**Fresh start:**
```bash
./cleanup.sh
./setup.sh
```

---

## ✅ Project Results

- ✅ Complete Docker containerization
- ✅ Automated backup/restore system
- ✅ Git integration and team collaboration  
- ✅ 9 articles created by team members
- ✅ Cross-system portability validated
- ✅ Full documentation

**Repository:** https://github.com/JeFaZor/devtools-Final-Project
