# trombik.cbsd

Manage `cbsd`.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `cbsd_user` | user of `cbsd` | `cbsd` |
| `cbsd_group` | group of `cbsd` | `cbsd` |
| `cbsd_service` | service name of `cbsd` | `cbsdd` |
| `cbsd_workdir` | path to work directory | `/usr/local/jails` |
| `cbsd_home` | path to `cbsd`'s home directory | `/usr/local/cbsd` |
| `cbsd_conf_dir` | path to user configuration directory | `/usr/local/etc/cbsd` |
| `cbsd_initenv_conf_file` | path to `initenv.conf` | `{{ cbsd_conf_dir }}/initenv.conf` |
| `cbsd_initenv_conf` | content of `initenv.conf` | `""` |
| `cbsd_profiles` | list of user-defined profiles (see below) | `[]` |

## `cbsd_profiles`

This is a list of dict.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `name` | file name relative from `{{ cbsd_workdir }}/etc` | yes |
| `config` | the content of the file | no |
| `state` | `present` or `absent`. the default is `present` | no |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  pre_tasks:
  roles:
    - ansible-role-cbsd
  vars:
    cbsd_config: ""
    cbsd_initenv_conf: |
      # see /usr/local/cbsd/share/initenv.conf
      nodename="auto"
      nodeip="auto"
      jnameserver="8.8.8.8 8.8.4.4"
      nodeippool="10.0.0.0/24"
      natip="auto"
      nat_enable="pf"
      mdtmp="8"
      ipfw_enable="1"
      zfsfeat="1"
      hammerfeat="0"
      fbsdrepo="1"
      repo="http://bsdstore.ru"
      workdir="{{ cbsd_workdir }}"
      jail_interface="auto"
      parallel="5"
      stable="auto"
      statsd_bhyve_enable="0"
      statsd_jail_enable="0"
      statsd_hoster_enable="0"
      initenv_modify_sudoers="1"
      initenv_modify_rcconf_hostname="1"
      initenv_modify_rcconf_cbsd_workdir="1"
      initenv_modify_rcconf_cbsd_enable="0"
      initenv_modify_rcconf_rcshutdown_timeout="1"
      initenv_modify_syctl_rcshutdown_timeout="1"
      initenv_modify_rcconf_cbsdrsyncd_enable="1"
      initenv_modify_rcconf_cbsdrsyncd_flags="1"
      initenv_modify_cbsd_homedir="1"
    cbsd_profiles:
      - name: defaults/jail-freebsd-puppet.conf
        state: absent
      - name: defaults/jail-freebsd-myprofile.conf
        config: |
          # XXX must be "1" to enable the profile
          jail_active="1"

          jail_profile="myprofile"
          emulator="jail"
          default_jailname="j"
          default_domain="i.trombik.org"
          user_pw_root="password"
          allow_raw_sockets="0"
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
