#!/bin/bash

set -e

printhelp()
{
	echo "Usage: $0 [options]
Options:
  -h, --help                            display this help message and exit.
  -hn, --hostname HOSTNAME              hostname.
  -f, --fastmode                        build only.
  -d, --webdir DIR                      dir for fronend.
  -bu, --backendurl URL                 url of backend.
  -vu, --vncproxyurl URL                url of vncproxy.
  -e, --emails email1,email2...         emails for letsencrypt
  -c, --cert                            cert info.
      -cn                                   cert cn
      -ds, --domains domain1,domain2...     cert domains" 1>&2
	exit 1
}

gencert()
{
    output=$(echo "{}" | jq -c ".cn = \"$1\"")
    echo "$output" | jq -c ".domains = $2"
}

dirpath=$(dirname "$0")

hostname=""
webdir="/var/www/nasajudge"
backendurl="localhost:3000"
vncproxyurl="localhost:4000"
emails="[]"
certs="[]"
oncerts=false
fastmode=false

while [ "$1" != "" ]
do
    case "$1" in
        -h|--help)
            printhelp
            ;;
        -d|--webdir)
            shift
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            webdir=$1
            ;;
        -f|--fastmode)
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            fastmode=true
            ;;
        -hn|--hostname)
            shift
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            hostname=$1
            ;;
        -bu|--backendurl)
            shift
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            backendurl=$1
            ;;
        -vu|--vncproxyurl)
            shift
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            vncproxyurl=$1
            ;;
        -e|--emails)
            shift
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            emails=$(echo "\"$1\"" | jq -c 'split(",")')
            #emails=$(echo $emails | jq -c ". + [\"$1\"]")
            ;;
        -c|--cert)
            if $oncerts
            then
                certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
                oncerts=false
            fi
            oncerts=true
            domains="[]"
            cn=""
            ;;
        -cn)
            shift
            if $oncerts
            then
                cn=$1
            fi
            ;;
        -ds|--domains)
            shift
            if $oncerts
            then
                domains=$(echo "\"$1\"" | jq -c 'split(",")')
            fi
            ;;
    esac
    shift
done

if $oncerts
then
    certs=$(echo "$certs" | jq -c ". + [$(gencert "$cn" "$domains")]")
    oncerts=false
fi

if [ "$hostname" == "" ]
then
    printhelp
fi

if $fastmode
then
    ansible-playbook $dirpath/setupfastmode.yml -e "{\"hostname\":\"$hostname\",\"webdir\":\"$webdir\",\"backendurl\":\"$backendurl\",\"vncproxyurl\":\"$vncproxyurl\",\"emails\":$emails, \"certs\":$certs}"
else
    ansible-galaxy collection install -r $dirpath/requirements.yml -f
    ansible-galaxy role install -r $dirpath/requirements.yml -f
    ansible-playbook $dirpath/setup.yml -e "{\"hostname\":\"$hostname\",\"webdir\":\"$webdir\",\"backendurl\":\"$backendurl\",\"vncproxyurl\":\"$vncproxyurl\",\"emails\":$emails, \"certs\":$certs}"
fi

echo ""
echo ""
echo "NASA Judge Frontend install.sh complete."
echo "Fix your config file at /etc/nginx/sites-enabled/nasa"
echo "Then you can use systemctl start nginx.service to start the service"
