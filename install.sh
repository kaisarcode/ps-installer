# Load environment variables
. ./.env

# Clean up old installation
sudo echo 'Cleaning up...'
mkdir -p www
sudo docker-compose down
sudo chmod -R 777 www
sudo rm -rf www
mkdir -p www

# Install base files
wget "https://download.prestashop.com/download/releases/prestashop_${PSVERSION}.zip"
unzip prestashop_$PSVERSION.zip -d www
sudo rm prestashop_$PSVERSION.zip
rm www/Install_PrestaShop.html
rm www/index.php
unzip www/prestashop.zip -d www
rm www/prestashop.zip
sudo chmod -R 777 www

# Build environment
sudo docker-compose build
sudo docker-compose up -d

# Install PrestaShop
echo 'Setting up PrestaShop, please wait...'
sudo docker exec -ti $PSCONTAINER sh -c \
"php install/index_cli.php \
--db_server=${DBCONTAINER} \
--db_name=${DBNAME} \
--db_password=${DBPASS} \
--prefix=${DBPREFIX} \
--engine=${DBENGINE} \
--domain=${PSDOMAIN}:${PSPORT} \
--language=${PSLANG} \
--email=${PSEMAIL} \
--password=${PSPASS} \
--name=${PSNAME} \
--send_email=0 \
--newsletter=0"; #> /dev/null 2>&1;

# Set up admin dir
sudo mv www/admin www/$PSADMINDIR
sudo rm -rf www/var/cache
sudo rm -rf www/install

# Install geolocation database
cp assets/GeoLite2-City.mmdb www/app/Resources/geoip/GeoLite2-City.mmdb

# Set permissions
sudo chmod -R 777 www
#find www -type d -exec sudo chmod 0755 {} \;
#find www -type f -exec sudo chmod 0644 {} \; 

# Done!
echo "Setup complete! Have fun!";