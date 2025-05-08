#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
# files="bashrc vimrc vim zshrc oh-my-zsh private scrotwm.conf Xresources"    # list of files/folders to symlink in homedir
files="bashrc zshrc"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory
for file in $files; do
    if [ -e ~/.$file ]; then
        echo "Moving existing ~/.$file to $olddir/"
        mv ~/.$file ~/dotfiles_old/
    fi
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        echo "Cloning Oh My Zsh"
        git clone https://github.com/ohmyzsh/ohmyzsh $dir/oh-my-zsh
        
        # Create symlink after successful clone
        echo "Creating symlink to oh-my-zsh in home directory."
        ln -sf $dir/oh-my-zsh ~/.oh-my-zsh
    elif [[ ! -L ~/.oh-my-zsh || $(readlink ~/.oh-my-zsh) != "$dir/oh-my-zsh" ]]; then
        # If oh-my-zsh directory exists but symlink is missing or incorrect
        echo "Creating symlink to oh-my-zsh in home directory."
        ln -sf $dir/oh-my-zsh ~/.oh-my-zsh
    fi
    
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

# Run the zsh installation function
echo "Running Oh My Zsh installation..."
install_zsh

# Now create the symlinks for all files
for file in $files; do
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

echo "Setup complete!"
