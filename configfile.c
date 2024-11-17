#Server Configuration file

server {
       listen 832;

         location ~* /WEBPOS-VARIANT-TWO {
                rewrite ^/WEBPOS-VARIANT/(.*)$ /$1 break;
                proxy_pass         http://localhost:6035;
                proxy_http_version 1.1;
                proxy_set_header   Upgrade $http_upgrade;
                proxy_set_header   Connection keep-alive;
                proxy_set_header   Host $host;
                proxy_cache_bypass $http_upgrade;
                proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header   X-Forwarded-Proto $scheme;
                client_max_body_size    100M;

        }

           location / {
       root /var/www/html/WEBPOSVARIANTTWOFRONT;
       try_files $uri $uri/ /index.html;
       index index.html index.htm;
}
}




## SSL ssl_certificate config file::
    add the .cert file and .key file that is public ssl_certificate and private ssl_certificate to the Configuration file at the path below:
    >> /etc/nginx/sites-available
    >> and then edit default with the certificates and error msg port 80 

#    }
#}
