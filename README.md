# PrestaShop Autoinstaller
This is an automatic PrestaShop installer.

## Quickstart
Just edit the file ".env" in the root folder and change the values as needed.
After that, open a terminal in the project's root directory and execute "sh install.sh".

## Warnings
If you will install the page in localhost:80, and you get a Redirect loop,
enter to the database and remove the explicit ":80" from the domain values in table **ps_shop_url**
