ActivemodelYoutubeUrlParser
==================

Make it easier to extract ids and create viewable urls from non-viewable Youtube urls

[![Build Status](https://travis-ci.com/substancelab/activemodel-youtube_url_parser.svg?branch=master)](https://travis-ci.com/substancelab/activemodel-youtube_url_parser)


Usage examples
--------------

Initialize the ActivemodelYoutubeUrlParser and call `parse`, it will return the video id:

```
  ActivemodelYoutubeUrlParser.new.parse("https://www.youtube.com/watch?v=C0DPdy98e4c") => "C0DPdy98e4c"
```

Or try `parse_as_url`, a working, viewable, video url will be returned for share, embed or short urls:

```
  ActivemodelYoutubeUrlParser.new.parse_as_url("https://youtu.be/C0DPdy98e4c") => ""https://www.youtube.com/watch?v=C0DPdy98e4c"
```

License
-------

ActivemodelYoutubeUrlParser is licensed under the MIT license. See LICENSE for details.
