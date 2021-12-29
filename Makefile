update-zsh: \
	update-oh-my-zsh \
	update-dots \
	update-emacs

update-oh-my-zsh:
	curl -s -L -o oh-my-zsh-master.tar.gz https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh oh-my-zsh-master.tar.gz

update-dots:
	curl -s -L -o dotfiles.tar.gz https://github.com/szorfein/dotfiles/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.dotfiles dotfiles.tar.gz

update-emacs:
	curl -s -L -o doom-emacs.tar.gz https://github.com/hlissner/doom-emacs/archive/develop.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.emacs.d doom-emacs.tar.gz
