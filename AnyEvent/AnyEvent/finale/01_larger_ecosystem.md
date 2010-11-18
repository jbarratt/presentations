!SLIDE bullets
# The larger ecosystem
* If you fling packets at it, AnyEvent it!
* CPAN FTW, lots already done

!SLIDE
# Databases
# DBI
# Redis CouchDB Riak Memcached

!SLIDE
# Messaging
# AnyMQ
# Stomp AMPQ RabbitMQ

!SLIDE
# Networking
# FastPing IRC SNMP XMPP

!SLIDE
# WebServers
# Tatsumaki Twiggy

!SLIDE
# Twiggy
## "The memory required to run twiggy is 6MB and it can serve more than 4500 req/s with a single process on Perl 5.10 with MacBook Pro 13" late 2009."

!SLIDE bullets
# Async is perfect for webapps
* Most of the time is waiting for input (FS, DB, Memcached)
* Let your process be "working" (for lots of clients) instead of "waiting" (for one)
* FREE THE RAMZ
