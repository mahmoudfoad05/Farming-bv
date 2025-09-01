# Farming B.V. — Secure Logo on AWS EC2

Minimal, secure-by-default setup to host a single static page that serves Farming B.V.'s logo over HTTPS on an EC2 instance.

## 🧱 Block Diagram

```flowchart LR
  User((User Browser)) -->|"HTTPS 443 / HTTP 80 → 301 Redirect"| SG[Security Group]
  subgraph AWS
    SG --> EC2[EC2: Amazon Linux 2023<br/>Nginx + TLS<br/>Fail2ban + Auto Updates]
    EC2 -->|"Serve static logo"| NGINX[Nginx Web Server]
  end

  classDef aws fill:#232f3e,stroke:#111,color:#fff;
  class EC2,SG aws;
```

## 🔐 Security Controls
- **Network**: Security Group allows 80/443 from the internet and SSH only from `allowed_ssh_cidr`.
- **Transport**: HTTPS enforced (self-signed by default; swap to Let's Encrypt when domain is available).
- **Host hardening**: Fail2ban, unattended security updates via `dnf-automatic`.
- **IAM**: Instance profile with `AmazonSSMManagedInstanceCore` (for future SSH-less operations).
- **Headers**: CSP, X-Frame-Options, Referrer-Policy, etc. via nginx.

## 🚀 Deploy

### 1) Terraform
```bash
cd terraform
terraform init
terraform apply -auto-approve \
  -var="region=eu-central-1" \
  -var="key_name=YOUR_AWS_KEYPAIR_NAME" \
  -var="allowed_ssh_cidr=YOUR.IP.ADDR.0/32"
```

Outputs include the instance `public_ip` and an **Ansible inventory example**.

### 2) Ansible
Update `ansible/inventory.ini` with your instance IP and SSH key path. Example:
```
[web]
1.2.3.4 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/YOUR_KEY.pem
```

Run the playbook:
```bash
cd ansible
ansible-playbook playbook.yml
```

When done, visit: `https://<public_ip>/` (your browser may warn about self-signed cert).

### 3) (Optional) Use your domain and Let's Encrypt
- Set DNS A record (e.g., `logo.example.com`) to the EC2 public IP.
- Set `domain_name` and `use_self_signed=false` in `ansible/playbook.yml` and extend the role to run `certbot` (left as an exercise or future PR).

## 🗂 Repo Structure
```
farming-bv-secure-logo/
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh
└── ansible
    ├── ansible.cfg
    ├── inventory.ini
    ├── playbook.yml
    └── roles
        ├── common
        │   └── tasks
        │       └── main.yml
        └── nginx
            ├── handlers
            │   └── main.yml
            ├── tasks
            │   └── main.yml
            └── templates
                ├── index.html.j2
                ├── logo.svg.j2
                ├── nginx.conf.j2
                └── site.conf.j2
```

## 🧪 Demo Checklist
- ✅ URL reachable over HTTPS (self-signed or real cert)
- ✅ Architecture overview (diagram above)
- ✅ Codebase (Terraform + Ansible)
- ✅ Threats & mitigations explained in README & during demo
- ✅ Bonus: automation, least privilege, headers, auto-updates, fail2ban

## 📄 Notes
- Instance user: `ec2-user` (Amazon Linux 2023)
- Nginx serves from `/var/www/farming-bv`
- Replace the placeholder logo at `ansible/roles/nginx/templates/logo.svg.j2` with the real logo when available.
```
