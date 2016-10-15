#! /bin/sh
bundle exec jbundle install
jruby --server -S bin/server
