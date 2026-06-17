# Backups Setup

As of writing only 2 hosts are declared:
- Venti: main server
- Xiao: wireguard relay

Xiao, being just a relay has no state and is fully declared in this config, thus, it needs to backups. For that reason this will only cover Venti (formerly Pandora).

All of the backups are done in incremental snapshots in [Restic](https://restic.net/) repositories and hey are managed automatically with [Backrest](https://garethgeorge.github.io/backrest/). All of the repositories are encrypted with a strong key named after them.

Besides the Backrest copies, at least once every 2 months you should back up the repositories to an off-site HDD.

## Layout

This may change in time, but for now there are 3 main backed up repositories:

[//]: # (Remember to update also venti-setup.md if changed)

|Repository      | Use                                                   |
|----------------|-------------------------------------------------------|
|`hot-storage`   |Relevant but lightweight userfiles from my workstation |
|`media-pandora` |`/srv/media` backup. Heavy files synced in venti       |
|`pandora-self`  |Persistent directories from venti, configs, DBs, etc.  |


### hot-storage
These are files that do not belong to Venti, but rather to my personal workstation or other devices. They would've been synced with Syncthing and contain just the essential documents from that device. The most notable path would be `/srv/private/sync/hot-storage` where my laptop files are.

Backs up:
- /srv/files/

When to back up: Nightly
Preserve: 100 yearly; 12 monthly; 30 daily

Expected Size: 10~50 GB


### media-pandora
Backs up large files served by services. Note, if the contents are lightweight enough (like Radicale's CalDAV) then they are saved in their own /var/lib. 

`/srv/media` has videos, images, music and books, aka. media lol.

Backs up:
- /srv/media
- /srv/minecraft

When to back up: Weekly
Preserve: 100 yearly; 6 monthly; 8 weekly

Expected Size: 100~500 GB


### pandora-self
Backs up the configs and DBs of services and the essential state of the system. It includes slightly more than strictly necessary to avoid any form of data loss.

Excludes AI models because they take too much space and can always be re-downloaded.

Backs up:
- /etc
- /home
- /root
- /srv/bak
- /srv/data
- /var/lib
- /var/log

Excludes:

- /var/lib/private/ollama/models/blobs
- /var/lib/private/open-webui
- /var/lib/systemd/coredump

When to back up: Nightly
Preserve: 100 yearly; 3 monthly; 30 daily

Expected Size: 1~5 GB


## Backrest

Backrest, is an automated Restic tool with a neat WebUI. Although very convenient, it has almost no declarative options that can be defined in NixOS, so this section will document them.

Backrest has two types of items: plans and repositories. Plans specify what and when to save it, and repositories tell where and how.

The [layout section](#layout) has already defined the repositories, conventiently, it is in the way that restic expects them to be. For each repository, there should be a plan named: `REPOSITORY_NAME-plan`, and the repositories should have their own name. The plan should define paths to include and exclude as specified above.

All repositories should be checked 100% and pruned monthly.

For added visibility I recommend that every plan has a Discord webhook set to run on `CONDITION_ANY_ERROR`. There's no need to run another service Gotify or similar tools because I check Discord semi-frequently and it just works.


### JSON settings

If you're a machine and it's easier to parse for you, or if you want to make this declarative, you may do so by modifying the backrest configuration JSON file with these entries:

hot-storage-plan:

```json
{
  "id": "hot-storage-plan",
  "repo": "hot-storage",
  "paths": [
    "/srv/files/"
  ],
  "excludes": [],
  "iexcludes": [],
  "schedule": {
    "clock": "CLOCK_LOCAL",
    "cron": "0 3 * * *"
  },
  "backup_flags": [],
  "retention": {
    "policyTimeBucketed": {
      "yearly": 100,
      "monthly": 12,
      "weekly": 0,
      "daily": 30,
      "hourly": 0,
      "keepLastN": 0
    }
  },
  "hooks": [
    {
      "conditions": [
        "CONDITION_ANY_ERROR"
      ],
      "onError": "ON_ERROR_IGNORE",
      "actionDiscord": {
        "webhookUrl": "RE-GENERATE_THIS_WEBHOOK",
        "template": "{{ .Summary }}"
      }
    }
  ]
}
```

---

media-pandora-plan:

```json
{
  "id": "media-pandora-plan",
  "repo": "media-pandora",
  "paths": [
    "/srv/media",
    "/srv/minecraft"
  ],
  "excludes": [],
  "iexcludes": [],
  "schedule": {
    "clock": "CLOCK_LOCAL",
    "cron": "0 4 * * 1"
  },
  "backup_flags": [],
  "retention": {
    "policyTimeBucketed": {
      "yearly": 100,
      "monthly": 6,
      "weekly": 8,
      "daily": 0,
      "hourly": 0,
      "keepLastN": 0
    }
  },
  "hooks": [
    {
      "conditions": [
        "CONDITION_ANY_ERROR"
      ],
      "onError": "ON_ERROR_IGNORE",
      "actionDiscord": {
        "webhookUrl": "RE-GENERATE_THIS_WEBHOOK",
        "template": "{{ .Summary }}"
      }
    }
  ]
}
```

---

pandora-self-plan:

```json
{
  "id": "pandora-self-plan",
  "repo": "pandora-self",
  "paths": [
    "/etc",
    "/home",
    "/root",
    "/srv/bak",
    "/srv/data",
    "/var/lib",
    "/var/log"
  ],
  "excludes": [
    "/var/lib/private/ollama/models/blobs",
    "/var/lib/private/open-webui/",
    "/var/lib/systemd/coredump"
  ],
  "iexcludes": [],
  "schedule": {
    "clock": "CLOCK_LOCAL",
    "cron": "0 5 * * *"
  },
  "backup_flags": [],
  "retention": {
    "policyTimeBucketed": {
      "yearly": 100,
      "monthly": 12,
      "weekly": 0,
      "daily": 30,
      "hourly": 0,
      "keepLastN": 0
    }
  },
  "hooks": [
    {
      "conditions": [
        "CONDITION_ANY_ERROR"
      ],
      "onError": "ON_ERROR_IGNORE",
      "actionDiscord": {
        "webhookUrl": "RE-GENERATE_THIS_WEBHOOK",
        "template": "{{ .Summary }}"
      }
    }
  ]
}
```

---

hot-storage:

```json
{
  "id": "hot-storage",
  "guid": "RE-GENERATE_IT",
  "uri": "/mnt/backup/hot-storage",
  "password": "YOU_SHOULD_HAVE_IT",
  "env": [],
  "flags": [],
  "prunePolicy": {
    "maxUnusedPercent": 10,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 0 1 * *"
    }
  },
  "checkPolicy": {
    "readDataSubsetPercent": 100,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 3 * * *"
    }
  },
  "commandPrefix": {
    "ioNice": "IO_DEFAULT",
    "cpuNice": "CPU_DEFAULT"
  },
  "autoUnlock": true,
  "hooks": []
}
```

---

media-pandora:

```json
{
  "id": "media-pandora",
  "guid": "RE-GENERATE_IT",
  "uri": "/mnt/backup/media-pandora",
  "password": "YOU_SHOULD_HAVE_IT",
  "env": [],
  "flags": [],
  "prunePolicy": {
    "maxUnusedPercent": 10,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 0 1 * *"
    }
  },
  "checkPolicy": {
    "readDataSubsetPercent": 100,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 0 1 * *"
    }
  },
  "commandPrefix": {
    "ioNice": "IO_DEFAULT",
    "cpuNice": "CPU_DEFAULT"
  },
  "autoUnlock": false,
  "hooks": []
}
```

---

pandora-self:

```json
{
  "id": "pandora-self",
  "guid": "RE-GENERATE_IT",
  "uri": "/mnt/backup/pandora-self",
  "password": "YOU_SHOULD_HAVE_IT",
  "env": [],
  "flags": [],
  "prunePolicy": {
    "maxUnusedPercent": 10,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 0 1 * *"
    }
  },
  "checkPolicy": {
    "readDataSubsetPercent": 100,
    "schedule": {
      "clock": "CLOCK_LAST_RUN_TIME",
      "cron": "0 5 1 * *"
    }
  },
  "commandPrefix": {
    "ioNice": "IO_DEFAULT",
    "cpuNice": "CPU_DEFAULT"
  },
  "autoUnlock": true,
  "hooks": []
}
```

