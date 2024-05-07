#!/usr/bin/env bash

cat << RSS
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <atom:link href="https://torunar.github.io/rss-feeds/build/bandcamp-liked-albums.xml" rel="self" type="application/rss+xml" />
    <title># /usr/bin/torunar --music</title>
    <link>https://bandcamp.com/torunar/wishlist</link>
    <description>Понравившиеся альбомы на Bandcamp</description>
    <language>ru-RU</language>
    <generator>https://github.com/torunar/rss-feeds/bandcamp-liked-albums.sh</generator>
RSS

curl -sq -X POST https://bandcamp.com/api/fancollection/1/search_items -d '{"fan_id": 3382834, "search_type": "wishlist", "search_key": ""}' > /tmp/bandcamp-liked-albums.json

cat /tmp/bandcamp-liked-albums.json | \
  jq -r '.tralbums |= sort_by(.added | strptime("%d %b %Y %H:%M:%S %Z")) | .tralbums | reverse | limit(1; .[]) | "
    <lastBuildDate>\(.added | strptime("%d %b %Y %H:%M:%S %Z") | strftime("%a, %d %b %Y %H:%M:%S %z"))</lastBuildDate>"'

cat /tmp/bandcamp-liked-albums.json | \
  jq -r '.tralbums |= sort_by(.added | strptime("%d %b %Y %H:%M:%S %Z")) | .tralbums | reverse | limit(20; .[]) | "
    <item>
      <title><![CDATA[\(.band_name) — \(.album_title)]]></title>
      <link>\(.item_url)</link>
      <guid>\(.item_url)</guid>
      <pubDate>\(.added | strptime("%d %b %Y %H:%M:%S %Z") | strftime("%a, %d %b %Y %H:%M:%S %z"))</pubDate>
      <description><![CDATA[<img src=\"\(.item_art.url)\" />]]></description>
    </item>"'

rm -f /tmp/bandcamp-liked-albums.json

cat << RSS
  </channel>
</rss>
RSS

