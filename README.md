YoutubeUrlParser
==================

Make it easier to extract ids and create viewable urls from non-viewable Youtube urls

[![Build Status](https://travis-ci.com/substancelab/youtube_url_parser.svg?branch=master)](https://travis-ci.com/substancelab/youtube_url_parser)


Usage examples
--------------

### `#parse`

Initialize the YoutubeUrlParser and call `parse`, it will return the video id:

```
  YoutubeUrlParser.new.parse("https://www.youtube.com/watch?v=C0DPdy98e4c") => "C0DPdy98e4c"
```
Works with embed code from youtube as well:

```
  YoutubeUrlParser.new.parse('<iframe width="560" height="315" src="https://www.youtube.com/embed/C0DPdy98e4c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyrosco
pe; picture-in-picture; web-share" allowfullscreen></iframe>') => "C0DPdy98e4c"
```

And short urls

```
  YoutubeUrlParser.new.parse("https://youtube.com/shorts/C0DPdy98e4c") => "C0DPdy98e4c"
```

### `#parse_as_url`

Or try `parse_as_url`, a working, viewable, video url will be returned for share, embed or short urls:

```
  YoutubeUrlParser.new.parse_as_url("https://youtu.be/C0DPdy98e4c") => "https://www.youtube.com/watch?v=C0DPdy98e4c"
```

```
  YoutubeUrlParser.new.parse_as_url('<iframe width="560" height="315" src="https://www.youtube.com/embed/C0DPdy98e4c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media;
gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>') => "https://www.youtube.com/watch?v=C0DPdy98e4c"
```

License
-------

YoutubeUrlParser is licensed under the MIT license. See LICENSE for details.
