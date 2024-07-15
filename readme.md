## Configured WSL

This project configured wsl for DevOps/SRE/Developers...  
Installing important plugins, extentins and tools.  
Python, node, k9s, brew, granted and more...  

pre-request:  
WSL 2  
oh-my-zsh(installed in WSL)  
[Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?rtc=1&hl=he-il&gl=IL)  
[NerdFonts](https://github.com/romkatv/dotfiles-public/tree/master/.local/share/fonts/NerdFonts).    

### First step install oh-my-zsh:  
In WSL:  
```
sudo apt update
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Second step clone the project  
This will take sonething like 10 minutes(you can run the script as many times as you like):  
```
git clone https://github.com/oshri22004/configured-wsl.git
cd configured-wsl
chmod +x configure_my_wsl.sh
./configure_my_wsl.sh
```

### Confiured your theme:  
In a new shell session:
```
p10k configure
```  

### EXTRA SCRIPT
This script will configured your kubeconfig and .aws/config files, you need to change the fields in the script that is in "TODO:".  
In addition it will make aliases of assume+kubectx and you can change them as you like in the script(run this script as many times as you like).  
```
cd configured-wsl
chmod +x config-aws-kube.sh
./config-aws-kube.sh
```