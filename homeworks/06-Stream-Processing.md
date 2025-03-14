Source Link: [https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/06-streaming/homework.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/06-streaming/homework.md)

## Question 1: Redpanda version

Now let's find out the version of redpandas.

For that, check the output of the command rpk help inside the container. The name of the container is redpanda-1.

Find out what you need to execute based on the help output.

What's the version, based on the output of the command you executed? (copy the entire version)

```
$ docker exec -it redpanda-1 bash
redpanda@af7f92881943:/$ rpk help 
rpk is the Redpanda CLI & toolbox

Usage:
  rpk [flags]
  rpk [command]

Available Commands:
  cloud       Interact with Redpanda cloud
  cluster     Interact with a Redpanda cluster
  connect     A stream processor for mundane tasks - https://docs.redpanda.com/redpanda-connect
  container   Manage a local container cluster
  debug       Debug the local Redpanda process
  generate    Generate a configuration template for related services
  group       Describe, list, and delete consumer groups and manage their offsets
  help        Help about any command
  iotune      Measure filesystem performance and create IO configuration file
  plugin      List, download, update, and remove rpk plugins
  profile     Manage rpk profiles
  redpanda    Interact with a local Redpanda process
  registry    Commands to interact with the schema registry
  security    Manage Redpanda security
  topic       Create, delete, produce to and consume from Redpanda topics
  transform   Develop, deploy and manage Redpanda data transforms
  version     Prints the current rpk and Redpanda version

Flags:
      --config string            Redpanda or rpk config file; default search paths are "/var/lib/redpanda/.config/rpk/rpk.yaml", $PWD/redpanda.yaml, and
                                 /etc/redpanda/redpanda.yaml
  -X, --config-opt stringArray   Override rpk configuration settings; '-X help' for detail or '-X list' for terser detail
  -h, --help                     Help for rpk
      --profile string           rpk profile to use
  -v, --verbose                  Enable verbose logging
      --version                  version for rpk

Use "rpk [command] --help" for more information about a command.
redpanda@af7f92881943:/$ rpk version
Version:     v24.2.18
Git ref:     f9a22d4430
Build date:  2025-02-14T12:52:55Z
OS/Arch:     linux/amd64
Go version:  go1.23.1

Redpanda Cluster
  node-1  v24.2.18 - f9a22d443087b824803638623d6b7492ec8221f9
```

**The version of redpandas is:**
```
Version:     v24.2.18
Git ref:     f9a22d4430
Build date:  2025-02-14T12:52:55Z
OS/Arch:     linux/amd64
Go version:  go1.23.1

Redpanda Cluster
  node-1  v24.2.18 - f9a22d443087b824803638623d6b7492ec8221f9
```
