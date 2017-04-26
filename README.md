# Local Wordpress Development Setup

## Dependencies

* [WP-CLI](http://wp-cli.org/)
* [CLI Hosts](https://github.com/alphabetum/hosts)

The make file runs tasks that use both WP-CLI and Hosts. Attempting to run it without them will end in failure.

## Start a new Project

Firstly, clone the starter project into a new folder

`git clone git@github.com:discoliam/local-wordpress-dev.git <folder-name>`

Change directory into your new folder 

`cd <folder-name>`

There are two variables in the default theme.

* `slugname` is used as the name of files/folders for the theme, to namespace functions. This should be the same as `<folder-name>` so the vhost setup works. 
* `title` is used in Documentation and as the display name of the theme.

To Run the script:

`make slugname="<slug-name>" title="<Site Title>"`

This will:

* Download the latest version of Wordpress in GB English
* Setup `wp-config.php` file
* Create MySQL database called `<slugname>`
* Create a default admin user
    * **Username:** admin 
    * **Password:** passw0rd
* Download, rename and activate the [_Starter](https://github.com/discoliam/_starter) theme
* Installs and activates several plugins
    * [Contact From 7](http://contactform7.com/)
    * [WP-PageNavi](https://en-gb.wordpress.org/plugins/wp-pagenavi/)
    * [Regenerate Thumbnails](https://en-gb.wordpress.org/plugins/regenerate-thumbnails/)
    * [Yoast SEO](https://en-gb.wordpress.org/plugins/wordpress-seo/)
* Create a reference to `<slugname>.local` in your hosts file
* Create a refrence to `user/discoliam/sites/<slugname>` in your `vhost.conf` file
* Sets the permalink structure to `/%year%/%monthnum%/%day%/%postname%/`
* Remove source files and git upstream to this repo
* Replace this `README.md` with the themes `README.md`
* Run `npm install` for frontned dependecies


## To Do
* Add vhost automaticaly not currenlty working :( 
* Added a var that lets you choose the theme to install
