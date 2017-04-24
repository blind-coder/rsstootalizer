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

## Usage

After logging in, you need to Add a new feed. Enter its complete URL and click on "Add Feed". All current entries will be pulled and marked as posted, that means the current entries in the feed are not posted.

Click on "Edit" to edit the feed settings. You will need to add at least one "Whitelist" filter or no entries will be ever be published. Also, you can change the format of the Toot. It would be nice if you kept the ``#RSSTootalizer`` tag, but it's by no means required. Then click "Save filters" to save them.

At the top of the Edit page, you see a button "Show raw entries". All current entries (at the time the page loaded) will be shown and color-coded. If they are red, they would not get posted with the current filterset, if they are green, they would get posted. Use this functionality to validate your filters. These codes are not live updated, you need to press "Save filters" in between changes.

After this is done, go back to your ``Dashboard`` and click on ``Enable`` to enable processing the feed. Then post new stuff to your RSS feed and watch the update!


## Pulling Twitter feeds

Personally, I use https://twitrss.me/ to pull my twitter feed into RSSTootalizer.
