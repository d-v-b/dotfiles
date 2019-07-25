# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

umask 002


# added by Anaconda3 installer
export PATH="/groups/ahrens/home/bennettd/miniconda/bin:$PATH"
source activate base

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOPATH=/home/bennettd/go
export PATH=/user/local/go/bin:${PATH}:${GOPATH}/bin
