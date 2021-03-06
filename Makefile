update-zsh: \
	update-oh-my-zsh \
	update-zsh-spaceship-prompt \
	update-dots \
	update-emacs \
	update-plug.vim

update-oh-my-zsh:
	curl -s -L -o oh-my-zsh-master.tar.gz https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh oh-my-zsh-master.tar.gz

update-zsh-spaceship-prompt:
	mkdir -p dot_oh-my-zsh/custom/themes
	cd /tmp \
		&& curl -s -L -o spaceship-prompt-master.zip https://github.com/denysdovhan/spaceship-prompt/archive/master.zip \
		&& unzip spaceship-prompt-master.zip \
		&& tar -cvzf spaceship-prompt-master.tar.gz spaceship-prompt-master
	
	chezmoi import --strip-components 1 --destination ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt /tmp/spaceship-prompt-master.tar.gz

update-dots:
	curl -s -L -o dotfiles.tar.gz https://github.com/szorfein/dotfiles/archive/master.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.dotfiles dotfiles.tar.gz

update-emacs:
	curl -s -L -o doom-emacs.tar.gz https://github.com/hlissner/doom-emacs/archive/develop.tar.gz
	chezmoi import --strip-components 1 --destination ${HOME}/.emacs.d doom-emacs.tar.gz

update-plug.vim:
	curl -s -L https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $$(chezmoi source-path ~/.vim/autoload/plug.vim)
