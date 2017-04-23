# RSSTootalizer

Service to post RSS feeds to Mastodon

## Installation

First, make sure dependent programs and perl modules are installed:
```
# apt-get install libhtml-template-perl libjson-perl libdbd-mysql libdbi-perl libxml-feed-perl \
                  libuuid-tiny-perl libdbd-mysql-perl curl
```

Then clone into your webservers ``/cgi-bin/`` directory and make a non-cgi alias for the ``/static`` directory.
Example configuration for Apache:
``` apache
                Alias /cgi-bin/rsstootalizer/static /usr/lib/cgi-bin/rsstootalizer/static
                ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
                <Directory "/usr/lib/cgi-bin">
                        AllowOverride None
                        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                        Require all granted
                </Directory>
```

Finally, copy the file ``rsstootalizer.conf.example.json`` to ``rsstootalizer.conf.json`` and adapt to your setup and run ``./update_db.pl`` to create your tables.
Now you can log in to your very own instance of RSSTootalizer!
