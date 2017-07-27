# Powershell doesn't support MKLINK, it's only in cmd.exe!!!

# May want to add intelligence to check what exists before changing things
# add prompts, auto backup old things etc

# make the script appropriately idempotent

function linkFile ($file, $dest) {
  write-host "Linking $file to $dest"
  cmd /c mklink /h $dest $file
}

function linkFolder ($file, $dest) {
  write-host "Linking $file to $dest"
  cmd /c mklink /j $dest $file
}

function gitGet ($name, $dest, $source) {
  Write-Host "Pulling $name from $source into $dest"
  git clone $source $dest
}

linkFile vimrc %USERPROFILE%\_vimrc
linkFile vsvimrc %USERPROFILE%\_vsvimrc

linkFolder vim %USERPROFILE%\vimfiles
mkdir ~\vimfiles\backups

mkdir ~\vimfiles\autoload
curl https://tpo.pe/pathogen.vim -outfile ./vim/autoload/pathogen.vim

gitGet NERDtree vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git



