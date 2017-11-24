# Easy CPU and Memory Stressing for Docker and SwarmKit

There's lots of images/repos using `stress` or `stress-ng` but I needed something
that didn't need a custom ENTRYPOINT/CMD to work so it was easy to demo with
`docker service create`, so here we go:

> Simply running this image with various tags will get you pre-set cpu/memory stressing output.

| Image:Tag | Command |
| --------- | ------- |
| `bretfisher/stress:latest` | `stress --verbose --vm 1 --vm-bytes 256M` |
| `bretfisher/stress:256m` | `stress --verbose --vm 1 --vm-bytes 256M` |
| `bretfisher/stress:512m` | `stress --verbose --vm 1 --vm-bytes 512M` |
| `bretfisher/stress:1024m` | `stress --verbose --vm 1 --vm-bytes 1024M` |
| `bretfisher/stress:2cpu256m` | `stress --verbose --vm 2 --vm-bytes 256M` |
| `bretfisher/stress:2cpu512m` | `stress --verbose --vm 2 --vm-bytes 512M` |
| `bretfisher/stress:2cpu1024m` | `stress --verbose --vm 2 --vm-bytes 1024M` |
