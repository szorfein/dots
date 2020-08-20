update-zsh: \
	update-oh-my-zsh \
	update-dots

update-oh-my-zsh:
	curl -s -L -o oh-my-zsh-master.tar.gz https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh oh-my-zsh-master.tar.gz

update-dots:
	curl -s -L -o dotfiles.tar.gz https://github.com/szorfein/dotfiles/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.dotfiles dotfiles.tar.gz
