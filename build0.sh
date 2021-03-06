#!/bin/bash
mkdir -p /nginx
cd /nginx
apt-get source nginx=${NGINX_VERSION}-1
mkdir -p nginx-${NGINX_VERSION}/debian/modules
cd nginx-${NGINX_VERSION}/debian/modules

wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz -O ngx_cache_purge-2.3.tar.gz
tar -xzvf ngx_cache_purge-2.3.tar.gz

wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip -O release-${NPS_VERSION}.zip
unzip release-${NPS_VERSION}.zip
cd incubator-pagespeed-ngx-${NPS_VERSION}/
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
[ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -xzvf $(basename ${psol_url})

cd /nginx/nginx-${NGINX_VERSION}
wget https://www.openssl.org/source/openssl-${OSSL_VERSION}.tar.gz
tar -xf openssl-${OSSL_VERSION}.tar.gz
sed -i "0,/CFLAGS\=\\\"\\\"/{/CFLAGS\=\\\"\\\"/ s/$/ --add-module=\/nginx\/nginx-${NGINX_VERSION}\/debian\/modules\/ngx_cache_purge-2.3 --add-module=\/nginx\/nginx-${NGINX_VERSION}\/debian\/modules\/incubator-pagespeed-ngx-${NPS_VERSION} ${PS_NGX_EXTRA_FLAGS} --with-openssl=\/nginx\/nginx-${NGINX_VERSION}\/openssl-${OSSL_VERSION}/}" /nginx/nginx-${NGINX_VERSION}/debian/rules
#sed "41 a --add-module=/nginx/nginx-${NGINX_VERSION}/debian/modules/ngx_pagespeed-release-${NPS_VERSION} ${PS_NGX_EXTRA_FLAGS}" -i /nginx/nginx-${NGINX_VERSION}/debian/rules
#sed "46 a --with-openssl=/nginx/nginx-${NGINX_VERSION}/openssl-${OSSL_VERSION}" -i /nginx/nginx-${NGINX_VERSION}/debian/rules

dpkg-buildpackage -b

#mkdir -p /nginx-dist
#cp /nginx/*.deb /nginx-dist/
