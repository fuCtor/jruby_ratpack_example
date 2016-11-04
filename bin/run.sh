#! /bin/sh
export JRUBY_OPTS='-J-Xms512m -J-Xmx512m -J-Dorg.slf4j.simpleLogger.defaultLogLevel=debug'
jruby --server -S bin/server
