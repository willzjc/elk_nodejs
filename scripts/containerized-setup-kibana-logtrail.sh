#!/bin/bash

# Priming shortcuts
echo -e "alias l='ls -ltarh'" >> $HOME/.bashrc

# Logtrail must lockstep match Kibana version
# List of available releases are at: https://github.com/sivasamyk/logtrail/releases

# Default logtrail version

export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.29/logtrail-6.3.2-0.1.29.zip" ;
export LOCALTAG=$TAG

if [ -z $1 ] ; then
{
	echo -e "No argument passed"
	if [ -z $LOCALTAG  ] ; then
	{
		echo '${TAG} also empty - Defaulting to 6.4.0 as TAG' ;
		export LOCALTAG="6.4.0";
	}
	fi
}
else
{
	export LOCALTAG=$1 ;
}
fi

# Version checking
if [ "${LOCALTAG}" == "6.4.0" ] ; then
	export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.30/logtrail-6.4.0-0.1.30.zip" ;
elif [ "${LOCALTAG}" = "6.3.2" ]  ; then
	export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.29/logtrail-6.3.2-0.1.29.zip" ;
elif [ "${LOCALTAG}" = "6.3.0" ]  ; then
	export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.27/logtrail-6.3.0-0.1.27.zip" ;
elif [ "${LOCALTAG}" = "6.2.4" ]  ; then
	export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.27/logtrail-6.2.4-0.1.27.zip" ;
elif [ "${LOCALTAG}" = "6.5.0" ]  ; then
	export LOGTRAIL_BINARY_URL="https://github.com/sivasamyk/logtrail/releases/download/v0.1.30/logtrail-6.5.0-0.1.30.zip" ;
else
	echo "Must define version for this to function"
	exit 1
fi

# Installs Logtrail via container execution
echo "Variables set at ${LOCALTAG}, from URL: ${LOGTRAIL_BINARY_URL}. Next step: Attempting to install now if not present"
if [[ ! -z $(/usr/share/kibana/bin/kibana-plugin list | grep logtrail) ]] ; then
{
  echo -e "Not installing, plugin already present" ;
}
else
{
	echo -e "Attempting to download from $LOGTRAIL_BINARY_URL"
	/usr/share/kibana/bin/kibana-plugin install $LOGTRAIL_BINARY_URL ;

	if [[ -z "$(/usr/share/kibana/bin/kibana-plugin list | grep logtrail)" ]] ; then 
	{
		echo -e "Still no plugin directory - likely you are behind a proxy/firewall"
		echo -e "Now will attempt to install from local source logtrail-6.7.1-0.1.31 (be prepared for incompatibilities)"
		cp -rf /usr/share/kibana/logtrail_package /usr/share/kibana/plugins/logtrail
		chmod -R 777 /usr/share/kibana/plugins
		sed -i "s/REPLACE_WITH_KIBANA_VERSION/${TAG}/g" /usr/share/kibana/plugins/logtrail/package.json
		echo -e "Config now at /usr/share/kibana/plugins/logtrail/package.json \n\n$(cat /usr/share/kibana/plugins/logtrail/package.json)"
	}
	fi
}
fi

# Update logtrail config
if [[ -f "/usr/share/kibana/plugins/logtrail/logtrail.json" ]] ; then
{
	echo -e "Removing existing logtrail.json"
	echo -e "===============================$(cat /usr/share/kibana/plugins/logtrail/logtrail.json)"
  rm -rf /usr/share/kibana/plugins/logtrail/logtrail.json
}
fi

cp /etc/logtrail.json /usr/share/kibana/plugins/logtrail/logtrail.json