# Crontab Vis

Visualize your crontab!

Currently, you can see the next occurrences of a given cron expression.

    $ pry
    > cv = CrontabVis.new   # you can supply :anchor_time, which can be any timestamp like `Time.parse('2014-01-01')`
    > cv.next_occurrences('30 * * * *', limit: 1.month)
    #=> a list of timestamps when this cron expression will trigger over the next month

Notes:

* Some experimentation with a web server based visualization using vis.js.

```
$ rackup
$ open http://localhost:9292/index.html
```
