Setup
=====

Before bundling...

Darwin
======
  $ cat .bundle/config
  ---
  BUNDLE_WITHOUT: windows:linux


Linux
=====
  $ cat .bundle/config
  ---
  BUNDLE_WITHOUT: windows:darwin


Windows (not well supported)
=======
  $ cat .bundle/config
  ---
  BUNDLE_WITHOUT: linux:darwin
