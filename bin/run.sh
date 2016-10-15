#! /bin/sh
export JRUBY_OPTS='-J-Xms512m -J-Xmx512m'
bundle exec jbundle install
jruby --server -S bin/server
