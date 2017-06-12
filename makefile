# Define vHost Example
define vhostdata
	<VirtualHost *:80>
		DocumentRoot \"/Users/discoliam/sites/${slugname}\"
		ServerName ${slugname}.local
	  <directory \"/Users/discoliam/sites/${slugname}\">
	    Options Indexes FollowSymLinks
	    AllowOverride All
	    Order allow,deny
	    Allow from all
	  </directory>
	</VirtualHost>
endef
export vhostdata

main:
	# Instal latest GB English version of Wordpress
	wp core download --locale=en_GB

	# Setup Config File
	wp core config --dbname=${slugname} --dbuser=root --dbpass= --locale=en_GB

	# Create Database
	wp db create

	# Install Wordpress (with basic admin username password)
	wp core install --url=${slugname}.local --title="${title}" --admin_user=admin --admin_password=passw0rd --admin_email=info@example.local

	# Set Permalinks to Year / Month / Day Name 
	wp rewrite structure "/%year%/%monthnum%/%day%/%postname%/"

	#Download _Starter Repo
	curl -LOk https://github.com/discoliam/_starter/archive/master.zip

	# Unzip _Starter Repo
	unzip master.zip

	# Move Theme to correct folder and rename
	mv _starter-master/wp-content/themes/_starter wp-content/themes/${slugname}

	# Move other files to root
	mv _starter-master/gulpfile.js gulpfile.js
	mv _starter-master/package.json package.json
	mv _starter-master/README.md README.md 
	mv _starter-master/sprite-template.html sprite-template.html
	mv _starter-master/acf-custom-fields.json acf-custom-fields.json

	# Find and replace on _starter with ${slugname}
	find . -name '*.php' |xargs perl -pi -e 's/_starter/${slugname}/g'
	find . -name 'gulpfile.js' |xargs perl -pi -e 's/starter/${slugname}/g';
	find . -name 'package.json' |xargs perl -pi -e 's/_starter/${slugname}/g';

	# Find and replace on _Starter with ${title}
	find . -name 'README.md' |xargs perl -pi -e 's/_Starter/${title}/g';

	# Activate starter theme
	wp theme activate ${slugname}

	# Install and activate plugins
	wp plugin install contact-form-7 --activate        		# Concact Form 7
	wp plugin install wp-pagenavi --activate           		# Wp Page Navi
	wp plugin install regenerate-thumbnails --activate 		# Regenrate Thumnails
	wp plugin install wordpress-seo --activate         		# Yoast SEO
  wp plugin install wordpress-popular-posts --activate 	# Wordpress Popular Posts
  wp plugin install breadcrumb-navxt --activate 				# Breadcrumb NavXT


	# Install ACF Pro
	curl -o acf-pro.zip "http://connect.advancedcustomfields.com/index.php?a=download&p=pro&k=$(ACFKEY)"
	wp plugin install acf-pro.zip --activate
	rm acf-pro.zip

	# Delete all Posts
	wp post delete $(wp post list --post_type='post' --format=ids)

	# Delete all Pages
	wp post delete $(wp post list --post_type='page' --format=ids)

	#Delete unused Plugins
	wp plugin delete akismet hello

	#Delete unused Themes
	wp theme delete twentyseventeen twentysixteen twentyfifteen

	#Turn of Comments
	wp option set default_comment_status closed

	# Creat home and Contact Page with correct templates
	wp post create --post_type=page --post_status=publish --post_title='Home' --page_template='page-home.php'
	wp post create --post_type=page --post_status=publish --post_title='Contact'  --page_template='page-contact.php'

	#Create record in hosts file
	sudo hosts add 127.0.0.1 ${slugname}.local

	# #Create record for virtual host
	# sudo @echo "$$vhostdata" > /private/etc/apache2/extra/httpd-vhosts.conf

	# Setup Permalink Structure
	$ wp rewrite structure '/%year%/%monthnum%/%day%/%postname%/'

	#Restart Apache
	sudo apachectl restart

	#Install dependecies from NPM
	npm install

	# Delete source theme files and git stuff
	rm -rf _starter-master master.zip .git

clean: 
	wp db drop --yes
	rm -rf _starter-master wp-admin wp-includes wp-content sprite-template.html package.json gulpfile.js .gitignore master.zip wp-config.php readme.html license.txt .htaccess wp-activate.php wp-config-sample.php wp-login.php wp-trackback.php wp-blog-header.php wp-cron.php wp-mail.php wp-comments-post.php wp-links-opml.php wp-settings.php wp-load.php wp-signup.php xmlrpc.php index.php;

help:
	@echo "Makefile usage:"
	@echo " make \t\t Install Wordpress, Theme, Plugins. Create Database"
	@echo " make cleane \t Delete Wordpress files and Database"