
export PATH="/Users/petar.artinov/Applications/Sublime Text.app/Contents/SharedSupport/bin:/Users/petar.artinov/bin:$PATH"

alias ll="ls -al"
alias clr="clear"
alias ssh="ssh -oStrictHostKeyChecking=no -p18765"
alias kur="exit"
alias python="python3"

function node () {
	host -t txt node.server.config $1 | grep -o '".*"' | sed 's/"//g'
}
function dc () {
	host -t txt dc.server.config $1 | grep -o '".*"' | sed 's/"//g'
}
function cont () { 
	host -t txt container.server.config $1 | grep -o '".*"' | sed 's/"//g'
}
function servhost () { 
	host -t txt hostname.server.config $1 | grep -o '".*"' | sed 's/"//g'
}

function servinfo () {
	node=$(host -t txt node.server.config $1 | grep -o '".*"' | sed 's/"//g')
	cont=$(host -t txt container.server.config $1 | grep -o '".*"' | sed 's/"//g')
	echo -e "\nContainer Name:"
	echo $cont
	echo -e "\nServer hostname:"
	host -t txt hostname.server.config $1 | grep -o '".*"' | sed 's/"//g'
	echo -e "\nHosting Node:"
	echo $node
	echo -e "\nData Center:"
	host -t txt dc.server.config $1 | grep -o '".*"' | sed 's/"//g'
	echo -e "\nContainer Grafana:"
	echo -e "https://grafana.sgvps.net/d/000000038/container-statistics?refresh=5s&orgId=1&var-node=$node&var-container=$cont"
	echo -e "\nNode Grafana:"
	echo -e "https://grafana.sgvps.net/d/Du7JIsuZz/node-exporter-server-metrics-new?orgId=1&refresh=30s&var-node=$node\n"
}

function SInfo () {
server="$(host -t txt hostname.server.config $1 | tail -n1 | awk '{print $4}' | tr -d '"')"
open "https://avalon-grafana.sgvps.net/d/B2V1fFFWz/server-stats?orgId=1&var-server=$server&var-offset=1h"
}


#export PATH=/Users/petar.artinov/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:/Users/petar.artinov/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/petar.artinov/support_tools
function bundleinf () {
 open "https://avalon-grafana.sgvps.net/d/-WFc82PGk/bundle-stats?orgId=1&var-accountid=$1" 
 }

function token {
cat Downloads/tools_site* | grep -w siteToken | awk -F '"' '{print $4}' > key.txt
#cat key.txt
rm ~/Downloads/tools_site*
}

function site-tools-client () {
if [ -z "$2" ]; then
	echo -e "Usage: -l for login; -s for SSH; -r for Refresh..."
	return
fi
domain="$2"
key="$(cat key.txt)"
server="$(curl -sX POST 'https://maco.siteground.com/site_manager/' --cookie "PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=$domain&username=&date_created_from=&date_created_to=&server=" | grep -B3 "<td>Active</td>" | awk -F "<*td>\|</" '{print $2}' | head -n1)"
user="$(curl -sX POST 'https://maco.siteground.com/site_manager/' --cookie "PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=$domain&username=&date_created_from=&date_created_to=&server=" | grep -B3 "<td>Active</td>" | awk -F "<*td>\|</" '{print $2}' | head -n2 | tail -n1)"

if [ "$1" = "-r" ]; then
	curl -sX GET https://${server}/api-sgcp/v00/domain/1?_site_token=${key} | python3 -m json.tool
elif [ "$1" = "-s" ]; then
	curl -k "https://${server}/api-sgcp/v00/ssh?_site_token=${key}"  --data-raw '{"comment":"sg","key_pub":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7JVPUX805HHbnqHrutSCEQRNEbqokGA6pQZ6w6rp21ZS4ldWfViLT5GSGu016iWrabvz+Tf7K9oGPyornzBYb0dVwogy9SuABv9wA1vz+EHlbCbju/aNThz9WdNjTr0AiYRWgNZps7MY5D4FeYMOdg0wwQ0qp2yFaGocuwwvZFbejmqQlq31xz0kvUXcq3DV07ykrWnzNNdt0Sw3eEu+Df0KGotmKSzVxuM9ZBrrgFLzl1aBCFMb0mTwl7MeHsBLVFBi6j/w5wppIZcngRrnCKeLJinRcowC5svyXWIGWdKSfg1oA4+3ZzgLtSe0uGs6MJfGQOVJUAeZ51PmOLSgad74yASqn+vj9QBZkV50E49b+/tUOU8s9Gs1Yv4W4HQFQjIo+5SbP2Yq1D6gkQ8I6xXbgghIWutheIs76OsDJbELenUAMYlSPP1lCIrQ7hmR8DeUkxElt0MC8lf1AlzMvaUNRsGbdEt4AdpJ+L1GIqONHGQRZxlR8+oQr/JcbBFE= sgtest","_meta":{"notification":{"type":"form","formName":"CREATE_SSH","success":{"intlKey":"translate.page.ssh.imported_msg","intlValues":{"name":"sg"}},"error":{"intlKey":"translate.page.ssh.failed_import_msg","intlValues":{"name":"sg"}}}}}'
	echo ""
	echo ""
	echo "--------- SSH Commands ---------"
	echo ""
	echo "wp cache flush; wp sg purge; wp rewrite flush; wp transient delete --expired; rm -rf wp-content/cache/*; rm -rf ~/.opcache/*"
	echo "find . -type f -print0 | xargs -0 chmod 0644 && find . -type d -print0 | xargs -0 chmod 0755"
	echo "du -sch .[!.]* * | sort -h "
	echo ""
	echo "---------- End of SSH ----------"
	echo ""
	sleep 2
	echo $user
	echo $server
	ssh -oStrictHostKeyChecking=no -p18765 $user@$server
	ssh -p 18765 -oStrictHostKeyChecking=no $user@$server "sed -i '$ d' ~/.ssh/authorized_keys2; echo 'Key deleted!'";
elif [ "$1" = "-l" ]; then
	curl "https://${server}/api-sgcp/v00/app?_site_token=${key}" > out.txt
	python ~/bin/par.py $domain
	curl -sX PUT "https://${server}/api-sgcp/v00/wordpress/$(cat ~/bin/app_id.txt)?auto_login=1&_site_token=${key}" --data-raw '{"urlParams":{"auto_login":1}}'   --compressed | python -m json.tool | grep autologin | awk -F\" '{print $4}' > wplog.txt 
	open "$(cat wplog.txt)"
elif [ "$1" = "-c" ]; then
	curl -s "https://${server}/api-sgcp/v00/ssh?_site_token=${key}"  --data-raw '{"comment":"sg","key_pub":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7JVPUX805HHbnqHrutSCEQRNEbqokGA6pQZ6w6rp21ZS4ldWfViLT5GSGu016iWrabvz+Tf7K9oGPyornzBYb0dVwogy9SuABv9wA1vz+EHlbCbju/aNThz9WdNjTr0AiYRWgNZps7MY5D4FeYMOdg0wwQ0qp2yFaGocuwwvZFbejmqQlq31xz0kvUXcq3DV07ykrWnzNNdt0Sw3eEu+Df0KGotmKSzVxuM9ZBrrgFLzl1aBCFMb0mTwl7MeHsBLVFBi6j/w5wppIZcngRrnCKeLJinRcowC5svyXWIGWdKSfg1oA4+3ZzgLtSe0uGs6MJfGQOVJUAeZ51PmOLSgad74yASqn+vj9QBZkV50E49b+/tUOU8s9Gs1Yv4W4HQFQjIo+5SbP2Yq1D6gkQ8I6xXbgghIWutheIs76OsDJbELenUAMYlSPP1lCIrQ7hmR8DeUkxElt0MC8lf1AlzMvaUNRsGbdEt4AdpJ+L1GIqONHGQRZxlR8+oQr/JcbBFE= sgtest","_meta":{"notification":{"type":"form","formName":"CREATE_SSH","success":{"intlKey":"translate.page.ssh.imported_msg","intlValues":{"name":"sg"}},"error":{"intlKey":"translate.page.ssh.failed_import_msg","intlValues":{"name":"sg"}}}}}'
	ssh -p 18765 -oStrictHostKeyChecking=no $user@$server "cd www/${domain}/public_html/; wp cache flush; wp sg purge; wp rewrite flush; wp transient delete --expired; rm -rf wp-content/cache/*; rm -rf ~/.opcache/*; sed -i '$ d' ~/.ssh/authorized_keys2; echo 'Key deleted!'";
	curl "https://${server}/api-sgcp/v00/domain-all/1?_site_token=${key}" --data-raw "{'_meta':{'notification':{'type':'generic','success':{'intlKey':'translate.page.domainCache.cache_flushed','intlValues':{'entityName':'${domain}'}},'error':{'intlKey':'translate.page.domainCache.cache_flushed.failed','intlValues':{'entityName':'${domain}'}}}},'flush_cache':1,'id':1}"
elif [ "$1" = "-t" ]; then
	curl -s "https://${server}/api-sgcp/v00/ssh?_site_token=${key}"  --data-raw '{"comment":"sg","key_pub":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7JVPUX805HHbnqHrutSCEQRNEbqokGA6pQZ6w6rp21ZS4ldWfViLT5GSGu016iWrabvz+Tf7K9oGPyornzBYb0dVwogy9SuABv9wA1vz+EHlbCbju/aNThz9WdNjTr0AiYRWgNZps7MY5D4FeYMOdg0wwQ0qp2yFaGocuwwvZFbejmqQlq31xz0kvUXcq3DV07ykrWnzNNdt0Sw3eEu+Df0KGotmKSzVxuM9ZBrrgFLzl1aBCFMb0mTwl7MeHsBLVFBi6j/w5wppIZcngRrnCKeLJinRcowC5svyXWIGWdKSfg1oA4+3ZzgLtSe0uGs6MJfGQOVJUAeZ51PmOLSgad74yASqn+vj9QBZkV50E49b+/tUOU8s9Gs1Yv4W4HQFQjIo+5SbP2Yq1D6gkQ8I6xXbgghIWutheIs76OsDJbELenUAMYlSPP1lCIrQ7hmR8DeUkxElt0MC8lf1AlzMvaUNRsGbdEt4AdpJ+L1GIqONHGQRZxlR8+oQr/JcbBFE= sgtest","_meta":{"notification":{"type":"form","formName":"CREATE_SSH","success":{"intlKey":"translate.page.ssh.imported_msg","intlValues":{"name":"sg"}},"error":{"intlKey":"translate.page.ssh.failed_import_msg","intlValues":{"name":"sg"}}}}}'
	scp -P 18765 ~/tree $user@$server:~/bin/.
	ssh -oStrictHostKeyChecking=no -p18765 $user@$server
	ssh -p 18765 -oStrictHostKeyChecking=no $user@$server "sed -i '$ d' ~/.ssh/authorized_keys2; rm ~/bin/tree; echo 'Key and tree deleted!'";
elif [ "$1" = "-ll" ]; then
	curl -k "https://${server}/api-sgcp/v00/ssh?_site_token=${key}"  --data-raw '{"comment":"sg","key_pub":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7JVPUX805HHbnqHrutSCEQRNEbqokGA6pQZ6w6rp21ZS4ldWfViLT5GSGu016iWrabvz+Tf7K9oGPyornzBYb0dVwogy9SuABv9wA1vz+EHlbCbju/aNThz9WdNjTr0AiYRWgNZps7MY5D4FeYMOdg0wwQ0qp2yFaGocuwwvZFbejmqQlq31xz0kvUXcq3DV07ykrWnzNNdt0Sw3eEu+Df0KGotmKSzVxuM9ZBrrgFLzl1aBCFMb0mTwl7MeHsBLVFBi6j/w5wppIZcngRrnCKeLJinRcowC5svyXWIGWdKSfg1oA4+3ZzgLtSe0uGs6MJfGQOVJUAeZ51PmOLSgad74yASqn+vj9QBZkV50E49b+/tUOU8s9Gs1Yv4W4HQFQjIo+5SbP2Yq1D6gkQ8I6xXbgghIWutheIs76OsDJbELenUAMYlSPP1lCIrQ7hmR8DeUkxElt0MC8lf1AlzMvaUNRsGbdEt4AdpJ+L1GIqONHGQRZxlR8+oQr/JcbBFE= sgtest","_meta":{"notification":{"type":"form","formName":"CREATE_SSH","success":{"intlKey":"translate.page.ssh.imported_msg","intlValues":{"name":"sg"}},"error":{"intlKey":"translate.page.ssh.failed_import_msg","intlValues":{"name":"sg"}}}}}'
	mkdir $domain && cd $domain
	scp -P 18765 -oStrictHostKeyChecking=no $user@$server:www/$domain/logs/* . && gzip -d * && python ~/Downloads/stats.py *; cd .. && rm -rf $domain
	ssh -p 18765 -oStrictHostKeyChecking=no $user@$server "sed -i '$ d' ~/.ssh/authorized_keys2; echo 'Key deleted!'";
elif [ "$1" = "-dns" ]; then
	curl -k "https://${server}/api-sgcp/v00/ssh?_site_token=${key}"  --data-raw '{"comment":"sg","key_pub":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7JVPUX805HHbnqHrutSCEQRNEbqokGA6pQZ6w6rp21ZS4ldWfViLT5GSGu016iWrabvz+Tf7K9oGPyornzBYb0dVwogy9SuABv9wA1vz+EHlbCbju/aNThz9WdNjTr0AiYRWgNZps7MY5D4FeYMOdg0wwQ0qp2yFaGocuwwvZFbejmqQlq31xz0kvUXcq3DV07ykrWnzNNdt0Sw3eEu+Df0KGotmKSzVxuM9ZBrrgFLzl1aBCFMb0mTwl7MeHsBLVFBi6j/w5wppIZcngRrnCKeLJinRcowC5svyXWIGWdKSfg1oA4+3ZzgLtSe0uGs6MJfGQOVJUAeZ51PmOLSgad74yASqn+vj9QBZkV50E49b+/tUOU8s9Gs1Yv4W4HQFQjIo+5SbP2Yq1D6gkQ8I6xXbgghIWutheIs76OsDJbELenUAMYlSPP1lCIrQ7hmR8DeUkxElt0MC8lf1AlzMvaUNRsGbdEt4AdpJ+L1GIqONHGQRZxlR8+oQr/JcbBFE= sgtest","_meta":{"notification":{"type":"form","formName":"CREATE_SSH","success":{"intlKey":"translate.page.ssh.imported_msg","intlValues":{"name":"sg"}},"error":{"intlKey":"translate.page.ssh.failed_import_msg","intlValues":{"name":"sg"}}}}}'
	ssh -oStrictHostKeyChecking=no -p18765 $user@$server "site-tools-client dns list -f domain,type,name,value,ttl,port,prio,proto,service,weight domain_name=${domain} --multi-line | tr -d '\\\' "
	ssh -p 18765 -oStrictHostKeyChecking=no $user@$server "sed -i '$ d' ~/.ssh/authorized_keys2; echo 'Key deleted!'";
else
	echo -e "Usage: -l for login; -ll for logs; -s for SSH; -r for Refresh..."
fi
} 

function sb() {
	source ~/.bash_profile
}

function ttfb() {
	curl -s -o /dev/null -w "TTFB: %{time_starttransfer}\n" $1
}

function checkOnline() {
	while true; do
		st="$(curl -s 'https://admin.chat-assistance.com/chat/monitor' --cookie "PHPSESSID=$(cat ~/bin/chat_cookie.txt)" | grep teamstatus | cut -d '"' -f 2)"
		if [[ "$st" != "status on" ]]; then
			osascript -e 'display notification "You are offline!" with title "Online Checker" sound name "serious-sam"'
			sleep 5
			continue
		fi
		sleep 60
	done
}

function countIPs() {
	cat $1 | awk '{print $1}' | sort -n | uniq -c | sort -nr | head -20
}

function addToHosts() {
	echo "$1 $2 www.$2" >> /etc/hosts
}

function check {
domain=$1
ip=$(dig +short $(curl -s 'https://maco.siteground.com/site_manager/' -H "cookie: PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=${domain}&username=&date_created_from=&date_created_to=&server=" | grep -B3 Active | awk -F '<td>|</td>' '{print $2}' | head -n1))
cont=$(curl -m 5 -skf "https://$ip/.well-known/srvinfo/container")
node=$(curl -m 5 -skf "https://$ip/.well-known/srvinfo/node")
echo -e "-----------------------"
echo -e "$cont"
echo -e "$cont" | pbcopy
echo -e "-----------------------"
echo -e "$node"
echo -e "-----------------------"
open "https://grafana.sgvps.net/d/000000038/container-statistics?refresh=5s&orgId=1&var-node=${node}&var-container=${cont}"
open "https://grafana.sgvps.net/d/Du7JIsuZz/node-exporter-server-metrics-new?orgId=1&refresh=1h&var-node=${node}"
}
function ncheck {
domain=$1
ip=$(dig +short $(curl -s 'https://maco.siteground.com/site_manager/' -H "cookie: PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=${domain}&username=&date_created_from=&date_created_to=&server=" | grep -B3 Active | awk -F '<td>|</td>' '{print $2}' | head -n1))
cont=$(curl -m 5 -skf "https://$ip/.well-known/srvinfo/container")
node=$(curl -m 5 -skf "https://$ip/.well-known/srvinfo/node")
echo -e "-----------------------"
echo -e "$cont"
echo -e "$cont" | pbcopy
echo -e "-----------------------"
echo -e "$node"
echo -e "-----------------------"
open "https://monitoring.mci-master.sgvps.net/grafana/d/bGY-LSB7k/lxd-server-metrics?orgId=1&var-job=mci&var-project=default&var-name=${node}&var-container=${cont}&refresh=5m"
open "https://monitoring.mci-master.sgvps.net/grafana/d/Du7JIsuZz/node-exporter-server-metrics?orgId=1&var-node=${node}&refresh=30s"
}
function abuse {
domain=$1
curl -s 'https://maco.siteground.com/site_manager/'   -H "cookie: PHPSESSID=$(cat ~/bin/cookie.txt)"   --data-raw "site_id=&account_id=&client_id=&domain=${domain}&username=&date_created_from=&date_created_to=&server=" | grep account_manager | tail -n1 | grep -Eo '[0-9]+' | head -n1 > acc.txt
acc=$(cat acc.txt)
server="$(curl -sX POST 'https://maco.siteground.com/site_manager/' --cookie "PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=$domain&username=&date_created_from=&date_created_to=&server=" | grep -B3 "<td>Active</td>" | awk -F "<*td>\|</" '{print $2}' | head -n1)"
user="$(curl -sX POST 'https://maco.siteground.com/site_manager/' --cookie "PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "site_id=&account_id=&client_id=&domain=$domain&username=&date_created_from=&date_created_to=&server=" | grep -B3 "<td>Active</td>" | awk -F "<*td>\|</" '{print $2}' | head -n2 | tail -n1)"
#open "https://maco.siteground.com/manualabuse/cases?acc_id=${acc}&domain=&site_id=&uname=&status=&server=${server}&type=0&action_id=0&abuse_id=&search=1"
curl -s 'https://maco.siteground.com/autoabuse/list' -H "cookie: PHPSESSID=$(cat ~/bin/cookie.txt)" --data-raw "page=1&account_id=&username=${user}&type_id=&subtype_id=&status_id=&server=${server}&closedBy=&is_read=&is_email_read=" | egrep -A8 ">open<|open[0-9]+|notcleaned|limited" | grep autoabuse | awk -F 'case/' '{print $2}' | grep -Eo "[0-9]+" | while read id; do open https://maco.siteground.com/autoabuse/case/${id}.htm;done
}
function iplookup {
ip=$1
curl -s "https://ipman.sgvps.net/ipman.pl?action=search_ip&domain=$ip" -H 'x-requested-with: XMLHttpRequest' | python3 -m json.tool | grep "server\|ip_addr" | tr -d '"|,'
}
echo "
      888      8888888888 8888888b   8888888888 888b    888        d8888      888    d8P  8888888b.         d8888 888      8888888  d8888b         d8888 
      888      888        888   Y88b 888        8888b   888       d88888      888   d8P   888   Y88b       d88888 888        888  d88P  Y88b      d88888 
      888      888        888    888 888        88888b  888      d88P888      888  d8P    888    888      d88P888 888        888  888    888     d88P888 
      888      8888888    888    888 8888888    888Y88b 888     d88P 888      888d88K     888   d88P     d88P 888 888        888  888           d88P 888 
      888      888        888    888 888        888 Y88b888    d88P  888      8888888b    8888888P      d88P  888 888        888  888          d88P  888 
      888      888        888    888 888        888  Y88888   d88P   888      888  Y88b   888 T88b     d88P   888 888        888  888    888  d88P   888 
      888      888        888   d88P 888        888   Y8888  d8888888888      888   Y88b  888  T88b   d8888888888 888        888  Y88b  d88P d8888888888 
      88888888 8888888888 8888888P   8888888888 888    Y888 d88P     888      888    Y88b 888   T88b d88P     888 88888888 8888888  Y8888P  d88P     888"

export PATH=/Users/petar.artinov/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:/Users/petar.artinov/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/petar.artinov/support_tools
PS1="(☞ ͡° ͜ʖ ͡°)☞~ "