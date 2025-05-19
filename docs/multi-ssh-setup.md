
---

## 📄 Managing Multiple GitHub Accounts with Separate SSH Keys on a VPS

### 🧠 Scenario

You are working with two private repositories from **two different GitHub accounts** (e.g., frontend and backend) and want to:

* Deploy both projects to the **same VPS**
* Use **separate SSH keys** to authenticate with each GitHub account

---

### ✅ Step-by-Step Guide

---

### 1. 📁 Generate a Second SSH Key

On your VPS:

```bash
ssh-keygen -t ed25519 -C "your-second@email.com"
```

When prompted:

```bash
Enter file in which to save the key (/root/.ssh/id_ed25519): /root/.ssh/id_ed25519_dev2
```

---

### 2. 🔑 Add the New Public Key to GitHub (Second Account)

Display the public key:

```bash
cat ~/.ssh/id_ed25519_dev2.pub
```

Copy the full output.

Then go to **GitHub Account #2**:

> **Settings** → **SSH and GPG keys** → **New SSH key**
> Paste the key and save.

---

### 3. ⚙️ Configure the SSH Client

Edit (or create) the SSH config file:

```bash
nano ~/.ssh/config
```

Add this configuration:

```ini
# GitHub for Account 1 (default)
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

# GitHub for Account 2 (frontend)
Host github-dev2
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_dev2
```

Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

---

### 4. 🧬 Clone Each Repo Using the Correct Host

Now you can clone each repo using the correct SSH host.

#### Clone Backend (Account 1)

```bash
git clone git@github.com:dev1-username/backend-repo.git
```

#### Clone Frontend (Account 2)

```bash
git clone git@github-dev2:dev2-username/frontend-repo.git
```

> Note the use of `github-dev2` as defined in your SSH config.

---

### 5. 🧪 Test the SSH Connections

Verify both identities work:

```bash
ssh -T git@github.com        # For Account 1
ssh -T git@github-dev2       # For Account 2
```

Expected output:

```
Hi dev1-username! You've successfully authenticated...
Hi dev2-username! You've successfully authenticated...
```

---

### ✅ Summary

* Each GitHub account has its own SSH key.
* `~/.ssh/config` defines which key to use per host.
* You clone using the appropriate `Host` alias.
* This setup allows clean separation for deploying repos from multiple accounts on the same VPS.

---
