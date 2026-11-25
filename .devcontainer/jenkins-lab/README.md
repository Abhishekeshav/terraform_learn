# Jenkins Lab: follow the video in a codespace

This codespace stands in for the video's AWS EC2 Ubuntu server. Most commands from the
video work as shown. The differences:

| The video (EC2)                                   | You (this codespace)                                       |
|---------------------------------------------------|------------------------------------------------------------|
| Launch an EC2 instance and SSH in                 | Already done: use the terminal                             |
| Install Java                                      | `sudo apt install -y fontconfig openjdk-21-jre`            |
| Add the Jenkins apt repo, `apt install jenkins`   | Same as the video (if apt shows a key error, use the commands on jenkins.io/doc/book/installing/linux) |
| `sudo systemctl start jenkins`                    | `jenkinsctl start`                                         |
| `sudo systemctl status jenkins`                   | `jenkinsctl status`                                        |
| `sudo systemctl restart jenkins`                  | `jenkinsctl restart`                                       |
| `sudo systemctl enable jenkins`                   | Not needed; run `jenkinsctl start` each session            |
| Open port 8080 in the security group, browse to `http://<public-ip>:8080` | PORTS tab > 8080 > globe icon (keep it Private) |
| `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` | Same (or `jenkinsctl password`)                     |
| Install Docker (`apt install docker.io`)          | SKIP: Docker is already installed. Installing it again breaks it. |
| `sudo usermod -aG docker jenkins`                 | Same, then `jenkinsctl restart`                            |
| Agents: launch a 2nd EC2, SSH in, install Java    | `agent-vm start`, then `agent-vm ssh`, then install Java inside it |
| Node config: host = agent's IP, port 22           | host `localhost`, port `2222` (see `agent-vm info`)        |

Every session: `jenkinsctl start` (and `agent-vm start` once you reach the agents chapter).
When done: stop the codespace (Ctrl+Shift+P > Codespaces: Stop Current Codespace).
