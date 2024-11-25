
# BigBlueButton Exporter

Client-side version of the script that enables users to download BigBlueButton 2.3 recordings as a single video file.

## What's supported?

✅ Annotations <br  />
✅ Chat <br  />
✅ Cursor <br  />
✅ Polls <br  />
✅ Screen shares <br  />
✅ Slides<br  />
✅ Text <br  />
✅ Webcams <br  />
✅ Zooms <br  />

## Client Side Usage

```bash
ruby presentation.rb -h <recording hostname> -m <meeting-id> -f <output video filename>
```

### Requirements

FFmpeg compiled with `--enable-librsvg` and `--enable-libx264` <br  />

Install the necessary gems with `bundle install`. <br  />

###  Rendering options 
If your server runs BBB 2.2 or earlier, it is advised to set the flag `REMOVE_REDUNDANT_SHAPES` to **true** in `export_presentation.rb`. This will ensure the live whiteboard feature is still supported, require less storage space and increase rendering speeds.

Less data can be written on the disk by turning `SVGZ_COMPRESSION` on.

To make rendering faster and less resource-intensive, download FFMpeg's source code and replace the file `ffmpeg/libavcodec/librsvgdec.c` with the one in this directory. After compiling and installing FFMpeg, enable `FFMPEG_REFERENCE_SUPPORT` in `export_presentation.rb` .

The video output quality can be controlled with the `CONSTANT_RATE_FACTOR`.

### License

This script was developed for my [bachelor's thesis](https://mediatum.ub.tum.de/doc/1632305/1632305.pdf) at the Technical University of Munich and is licensed under MIT. Please cite as

```
@mastersthesis{bbb-recording-exporter,
	author = {Daniel Petri Rocha},
	title = {Development of a Sophisticated Session Recording Exporter for the BigBlueButton Web Conferencing System},
	year = {2021},
	school = {Technische Universität München},
	month = {},
	adress = {80805 Munich},
	pages = {65},
	language = {en},
	abstract = {BigBlueButton is an open-source web conferencing system designed for remote teaching.
              A longstanding feature request by community members has been to give users the
              ability to download the recording of a meeting as a video file, including the presentation,
              webcams, and chat messages. This thesis implemented that enhancement as a script
              executed automatically by the server once a recorded conference ends, performing
              significantly faster than previous solutions capturing the screen of the web player in realtime.
              Additionally, annotated slides can be output as PDF. Processing the presentation into both
              formats can also be done client-side if the user has no access to the server.
              Development of the converter did not introduce new dependencies into BigBlueButton
              and resulted in contributions to a Ruby library providing a data structure for efficient
              queries on intervals and FFmpeg, a command-line multimedia framework. The code
              offers a foundation for other improvements on BigBlueButton’s roadmap, such as giving
              instructors the option to import work done on documents in breakout rooms into the
              main session.},
	keywords = {open-source, web conferencing},
	note = {},
	url = {https://mediatum.ub.tum.de/doc/1632305/1632305.pdf},
}
```