alias nginx.start='sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
alias nginx.stop='sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'
alias nginx.reload='sudo nginx -s reload'
alias nginx.edit="$VISUAL /usr/local/etc/nginx/"

function nginx.log {
  tail -250f "/usr/local/var/log/nginx/${1}/${2}.${3}.log"
}

function nginx.ssl {
  mkdir -p /usr/local/etc/nginx/ssl/${1}/${2}
  openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=${1}" -keyout /usr/local/etc/nginx/ssl/${1}/${2}.key -out /usr/local/etc/nginx/ssl/${1}/${2}.crt
}

function nginx.create {
  mkdir -p /usr/local/etc/nginx/sites-available/${1}/
  mkdir -p /usr/local/var/log/nginx/${1}/

  nginx.ssl ${1} ${2}
  # @todo Add a task to create confs from templates
}

function nginx.enable {
  mkdir -p /usr/local/etc/nginx/sites-enabled/${1}/
  ln -sfv /usr/local/etc/nginx/sites-available/${1}/${2}.conf /usr/local/etc/nginx/sites-enabled/${1}/${2}.conf
}

function nginx.disable {
  rm -f /usr/local/etc/nginx/sites-enabled/${1}/${2}.conf
}
