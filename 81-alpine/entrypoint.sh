#!/bin/sh

[ -f /opt/entrypoint.sh ] && { 
  exec /bin/sh /opt/entrypoint.sh $@
} || { 
  exec $@ 
}
