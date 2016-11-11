#Local Wordpress Development Setup

## Dependencies
* [WP-CLI](http://wp-cli.org/)
* [CLI Hosts](https://github.com/alphabetum/hosts)


## Start a new Project
Staring a new project is easy. There are two variables in the default theme.

* `slugname` is used as the name of files/folders for the theme, to namespace functions.
* `title` is used in Documentation and as the display name of the theme.

The following command will generate a new instance of Wordpress, create a default admin user, download and rename the [_starter](https://github.com/discoliam/_starter) theme, and create a reference to `slugname.local` in the hosts file.

`make slugname="<slug name>" title="<site title>"`

`make slugname="testing" title="Testing"`

You'll need to create your own virtual host and restart apache after this has run successful. 