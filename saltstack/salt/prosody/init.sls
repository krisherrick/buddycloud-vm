#
# Prosody - jabber server
#

prosody-repo:
  pkgrepo.managed:
   - name: deb http://packages.prosody.im/debian trusty main
   - key_url: http://packages.prosody.im/debian/pubkey.asc
   - require_in:
     - pkg: prosody

prosody-packages:
  pkg.installed:
    - pkgs:
      - lua-dbi-postgresql # postgresql adapter
      - lua-zlib  # mod_compression
      - lua-sec   # ssl & auth
      - lua-event # use_libevent
      - lua-bitop # mod_websockets
      - prosody-0.10
    - require:
      - pkgrepo: prosody-repo

prosody:
  service.running:
    - require:
      - pkg: prosody-packages

/etc/prosody/modules:
  file.recurse:
    - source: salt://prosody/modules
    - user: root
    - group: root
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - require_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

/etc/prosody/prosody.cfg.lua:
  file.managed:
    - source: salt://prosody/prosody.cfg.lua.jinja
    - template: jinja
    - user: root
    - group: prosody
    - mode: 640
    - watch_in:
      - service: prosody
    - require:
      - pkg: prosody-packages
