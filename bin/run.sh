#! /bin/sh
export JRUBY_OPTS='-J-Xms512m -J-Xmx512m'
jruby --server -S bin/server
