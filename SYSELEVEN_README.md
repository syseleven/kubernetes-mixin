# What is this fork for?

This fork is used to patch multiple 1m-lookbacks to use a 5m timespan instead.
We do this since we have a pretty high scrape interval (around 45-55s) which
breaks 1m lookback alerts and dashboards.

As long as the scraping interval is not shortened or the 1m lookbacks are made
configurable we want to keep this fork.
