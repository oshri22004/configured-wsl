set -e

WINDOWS_USERNAME=$(cmd.exe /C "echo %USERNAME%" 2>/dev/null | tr -d '\r')
SETTINGS_PATH="/mnt/c/Users/$WINDOWS_USERNAME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
cp settings.json $SETTINGS_PATH

# Define the custom theme and plugin paths
POWERLEVEL10K_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
ZSH_AUTOSUGGESTIONS_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
OHMYZSH_FULL_AUTOUPDATE_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate"

# Clone powerlevel10k theme if it doesn't already exist
if [ ! -d "$POWERLEVEL10K_PATH" ]; then
    git clone https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_PATH"
else
    echo "powerlevel10k already exists. Skipping."
fi

# Clone zsh-autosuggestions plugin if it doesn't already exist
if [ ! -d "$ZSH_AUTOSUGGESTIONS_PATH" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_PATH"
else
    echo "zsh-autosuggestions already exists. Skipping."
fi

# Clone zsh-syntax-highlighting plugin if it doesn't already exist
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_PATH"
else
    echo "zsh-syntax-highlighting already exists. Skipping."
fi

# Clone OhMyZsh-full-autoupdate plugin if it doesn't already exist
if [ ! -d "$OHMYZSH_FULL_AUTOUPDATE_PATH" ]; then
    git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git "$OHMYZSH_FULL_AUTOUPDATE_PATH"
else
    echo "OhMyZsh-full-autoupdate already exists. Skipping."
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Proceeding with installation..."

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    # Start Docker service
    sudo systemctl start docker
    # Optionally, enable Docker to start at boot
    sudo systemctl enable docker
    # Now, it's safe to change permissions
    sudo chmod 666 /var/run/docker.sock 
else
  echo "Docker is already installed. Skipping installation steps."
fi

# Ensure package_list.txt exists
if [ ! -f package_list.txt ]; then
    echo "package_list.txt not found."
    exit 1
fi

sudo apt install -y $(cat package_list.txt)

# Check if Homebrew is installed by looking for the 'brew' command
if ! command -v brew &> /dev/null; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
  # Add Homebrew to PATH for the current session and future sessions
  echo -e "\neval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> $HOME/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed. Skipping installation."
fi

# Install Homebrew's dependencies
sudo apt-get install -y build-essential

# Install GCC using Homebrew
brew install gcc

brew tap common-fate/granted
brew install granted

# Check if brew is installed, then use it
if command -v brew &>/dev/null; then
    if [ -f my_brews.txt ]; then
        while read -r i; do
            brew install "$i"
        done < my_brews.txt
    else
        echo "my_brews.txt not found."
    fi
else
    echo "brew not found, skipping brew installations."
fi

# Check if Chrome path exists before creating symlink
chrome_path="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
if [ -f "$chrome_path" ]; then
    # Check if the symlink for Chrome already exists to avoid the error
    if [ ! -L "/usr/bin/google" ]; then
        sudo ln -s "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" /usr/bin/google
    else
        echo "Symlink for Chrome already exists, skipping."
    fi
else
    echo "Chrome not found at $chrome_path, skipping symlink creation."
fi

# Check if a GPG key with the name "devops" already exists
if gpg --list-keys | grep -q "devops"; then
    echo "GPG key for 'devops' already exists. Skipping key generation."
else
    gpg --batch --passphrase '' --quick-gen-key devops default default
    GPG_KEY_ID=$(gpg --list-keys --with-colons | grep '^fpr' | awk -F: '{print $10}' | head -n 1)
    pass init $GPG_KEY_ID
fi

sudo apt install ruby-rubygems ruby-dev -y
gem install --user-install colorls 

mkdir -p ~/.granted
cp config ~/.granted/config
cp .zshrc ~/.zshrc
sudo cp assume /usr/local/bin/assume
sudo chmod +x config-aws-kube.sh
echo "Running config-aws-kube.sh"
#./config-aws-kube.sh
