# Powershell doesn't support MKLINK, it's only in cmd.exe!!!

# May want to add intelligence to check what exists before changing things
# add prompts, auto backup old things etc

# make the script appropriately idempotent

function link ($file, $dest) {
  write-host "Linking $file to $dest"
  cmd /c mklink /h $dest $file
}


link vimrc %USERPROFILE%\_vimrc
link vsvimrc %USERPROFILE%\_vsvimrc

link spacemacs %USERPROFILE%\.spacemacs
