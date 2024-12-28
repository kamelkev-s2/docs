---
title: VMware vSphere
logo_light: "/images/selector/library/vmware.svg"
logo_dark: "/images/selector/library/vmware-dark.svg"
layout: integration
---

# VMware vSphere

## Overview

Selector's VMware integration uses the vSphere API to gather metrics from multiple vCenter servers covering the following 
VMware services:

* Clusters
* Hosts
* Resource Pools
* VMs
* Datastores
* vSAN

### Supported versions of vSphere

Support exists for metric retrieval covering vSphere versions 6.5, 6.7, 7.0 and 8.0.

### Inventory Paths

Resources to be monitored can be selected using Inventory Paths. This treats
the vSphere inventory as a tree structure similar to a file system. A vSphere
inventory has a structure similar to this:

```bash
<root>
+-DC0 # Virtual datacenter
   +-datastore # Datastore folder (created by system)
   | +-Datastore1
   +-host # Host folder (created by system)
   | +-Cluster1
   | | +-Host1
   | | | +-VM1
   | | | +-VM2
   | | | +-hadoop1
   | | +-ResourcePool1
   | | | +-VM3
   | | | +-VM4
   | +-Host2 # Dummy cluster created for non-clustered host
   | | +-Host2
   | | | +-VM5
   | | | +-VM6
   +-vm # VM folder (created by system)
   | +-VM1
   | +-VM2
   | +-Folder1
   | | +-hadoop1
   | | +-NestedFolder1
   | | | +-VM3
   | | | +-VM4
```

## Virtual Machine Metrics

```metrics
cpu.demandEntitlementRatio.latest
cpu.usage.average
cpu.ready.summation
cpu.run.summation
cpu.system.summation
cpu.swapwait.summation
cpu.costop.summation
cpu.demand.average
cpu.readiness.average
cpu.maxlimited.summation
cpu.wait.summation
cpu.usagemhz.average
cpu.latency.average
cpu.used.summation
cpu.overlap.summation
cpu.idle.summation
cpu.entitlement.latest
datastore.maxTotalLatency.latest
disk.usage.average
disk.read.average
disk.write.average
disk.maxTotalLatency.latest
mem.llSwapUsed.average
mem.swapin.average
mem.vmmemctltarget.average
mem.activewrite.average
mem.overhead.average
mem.vmmemctl.average
mem.zero.average
mem.swapoutRate.average
mem.active.average
mem.llSwapOutRate.average
mem.swapout.average
mem.llSwapInRate.average
mem.swapinRate.average
mem.granted.average
mem.latency.average
mem.overheadMax.average
mem.swapped.average
mem.compressionRate.average
mem.swaptarget.average
mem.shared.average
mem.zipSaved.latest
mem.overheadTouched.average
mem.zipped.latest
mem.consumed.average
mem.entitlement.average
mem.usage.average
mem.decompressionRate.average
mem.compressed.average
net.multicastRx.summation
net.transmitted.average
net.received.average
net.usage.average
net.broadcastTx.summation
net.broadcastRx.summation
net.packetsRx.summation
net.pnicBytesRx.average
net.multicastTx.summation
net.bytesTx.average
net.bytesRx.average
net.droppedRx.summation
net.pnicBytesTx.average
net.droppedTx.summation
net.packetsTx.summation
power.power.average
power.energy.summation
rescpu.runpk1.latest
rescpu.runpk15.latest
rescpu.maxLimited5.latest
rescpu.actpk5.latest
rescpu.samplePeriod.latest
rescpu.runav1.latest
rescpu.runav15.latest
rescpu.sampleCount.latest
rescpu.actpk1.latest
rescpu.runpk5.latest
rescpu.runav5.latest
rescpu.actav15.latest
rescpu.actav1.latest
rescpu.actpk15.latest
rescpu.actav5.latest
rescpu.maxLimited1.latest
rescpu.maxLimited15.latest
sys.osUptime.latest
sys.uptime.latest
sys.heartbeat.latest
virtualDisk.write.average
virtualDisk.read.average
```

## Host System Metrics

```metrics
cpu.corecount.contention.average
cpu.usage.average
cpu.reservedCapacity.average
cpu.usagemhz.minimum
cpu.usagemhz.maximum
cpu.usage.minimum
cpu.usage.maximum
cpu.capacity.provisioned.average
cpu.capacity.usage.average
cpu.capacity.demand.average
cpu.capacity.contention.average
cpu.corecount.provisioned.average
cpu.corecount.usage.average
cpu.usagemhz.average
disk.throughput.contention.average
disk.throughput.usage.average
mem.decompressionRate.average
mem.granted.average
mem.active.average
mem.shared.average
mem.zero.average
mem.swapused.average
mem.vmmemctl.average
mem.compressed.average
mem.compressionRate.average
mem.reservedCapacity.average
mem.capacity.provisioned.average
mem.capacity.usable.average
mem.capacity.usage.average
mem.capacity.entitlement.average
mem.capacity.contention.average
mem.usage.minimum
mem.overhead.minimum
mem.consumed.minimum
mem.granted.minimum
mem.active.minimum
mem.shared.minimum
mem.zero.minimum
mem.swapused.minimum
mem.consumed.average
mem.usage.maximum
mem.overhead.maximum
mem.consumed.maximum
mem.granted.maximum
mem.overhead.average
mem.shared.maximum
mem.zero.maximum
mem.swapused.maximum
mem.vmmemctl.maximum
mem.usage.average
mem.active.maximum
mem.vmmemctl.minimum
net.throughput.contention.summation
net.throughput.usage.average
net.throughput.usable.average
net.throughput.provisioned.average
power.power.average
power.powerCap.average
power.energy.summation
vmop.numShutdownGuest.latest
vmop.numPoweroff.latest
vmop.numSuspend.latest
vmop.numReset.latest
vmop.numRebootGuest.latest
vmop.numStandbyGuest.latest
vmop.numPoweron.latest
vmop.numCreate.latest
vmop.numDestroy.latest
vmop.numRegister.latest
vmop.numUnregister.latest
vmop.numReconfigure.latest
vmop.numClone.latest
vmop.numDeploy.latest
vmop.numChangeHost.latest
vmop.numChangeDS.latest
vmop.numChangeHostDS.latest
vmop.numVMotion.latest
vmop.numSVMotion.latest
vmop.numXVMotion.latest
```

## Resource Pool Metrics

```metrics
cpu.usagemhz.average
cpu.cpuentitlement.latest
cpu.usagemhz.minimum
cpu.usagemhz.maximum
cpu.capacity.entitlement.average
cpu.capacity.usage.average
cpu.capacity.demand.average
cpu.capacity.contention.average
cpu.corecount.provisioned.average
cpu.corecount.contention.average
disk.throughput.usage.average
disk.throughput.contention.average
mem.capacity.contention.average
mem.overhead.average
mem.consumed.average
mem.granted.average
mem.active.average
mem.shared.average
mem.zero.average
mem.swapped.average
mem.vmmemctl.average
mem.capacity.provisioned.average
mem.capacity.entitlement.average
mem.capacity.usage.average
mem.mementitlement.latest
mem.compressed.average
mem.compressionRate.average
mem.decompressionRate.average
mem.overhead.minimum
mem.consumed.minimum
mem.granted.minimum
mem.active.minimum
mem.shared.minimum
mem.zero.minimum
mem.swapped.minimum
mem.vmmemctl.maximum
mem.overhead.maximum
mem.consumed.maximum
mem.granted.maximum
mem.active.maximum
mem.shared.maximum
mem.zero.maximum
mem.swapped.maximum
mem.vmmemctl.minimum
net.throughput.usage.average
net.throughput.contention.summation
power.power.average
power.energy.summation
```

## Cluster Metrics

```metrics
cpu.corecount.contention.average
cpu.usage.average
cpu.reservedCapacity.average
cpu.usagemhz.minimum
cpu.usagemhz.maximum
cpu.usage.minimum
cpu.usage.maximum
cpu.capacity.provisioned.average
cpu.capacity.usage.average
cpu.capacity.demand.average
cpu.capacity.contention.average
cpu.corecount.provisioned.average
cpu.corecount.usage.average
cpu.usagemhz.average
disk.throughput.contention.average
disk.throughput.usage.average
mem.decompressionRate.average
mem.granted.average
mem.active.average
mem.shared.average
mem.zero.average
mem.swapused.average
mem.vmmemctl.average
mem.compressed.average
mem.compressionRate.average
mem.reservedCapacity.average
mem.capacity.provisioned.average
mem.capacity.usable.average
mem.capacity.usage.average
mem.capacity.entitlement.average
mem.capacity.contention.average
mem.usage.minimum
mem.overhead.minimum
mem.consumed.minimum
mem.granted.minimum
mem.active.minimum
mem.shared.minimum
mem.zero.minimum
mem.swapused.minimum
mem.consumed.average
mem.usage.maximum
mem.overhead.maximum
mem.consumed.maximum
mem.granted.maximum
mem.overhead.average
mem.shared.maximum
mem.zero.maximum
mem.swapused.maximum
mem.vmmemctl.maximum
mem.usage.average
mem.active.maximum
mem.vmmemctl.minimum
net.throughput.contention.summation
net.throughput.usage.average
net.throughput.usable.average
net.throughput.provisioned.average
power.power.average
power.powerCap.average
power.energy.summation
vmop.numShutdownGuest.latest
vmop.numPoweroff.latest
vmop.numSuspend.latest
vmop.numReset.latest
vmop.numRebootGuest.latest
vmop.numStandbyGuest.latest
vmop.numPoweron.latest
vmop.numCreate.latest
vmop.numDestroy.latest
vmop.numRegister.latest
vmop.numUnregister.latest
vmop.numReconfigure.latest
vmop.numClone.latest
vmop.numDeploy.latest
vmop.numChangeHost.latest
vmop.numChangeDS.latest
vmop.numChangeHostDS.latest
vmop.numVMotion.latest
vmop.numSVMotion.latest
vmop.numXVMotion.latest
```

## Datastore Metrics

```metrics
datastore.numberReadAveraged.average
datastore.throughput.contention.average
datastore.throughput.usage.average
datastore.write.average
datastore.read.average
datastore.numberWriteAveraged.average
disk.used.latest
disk.provisioned.latest
disk.capacity.latest
disk.capacity.contention.average
disk.capacity.provisioned.average
disk.capacity.usage.average
```
