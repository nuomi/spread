SpreadOSD
=========
A scalable distributed storage system.


## Overview

SpreadOSD is a distributed storage system that can store large data like photos, music or movies.
SpreadOSD cluster provides high **Scalability**, **Availability** and **Maintainability** for storage system.


### Scalability

Storage capacity and I/O throughput grow as you add servers.
Since change of cluster configuration is hidden from applications, you can scales-out without stopping or reconfiguring the application.


### Availability

SpreadOSD supports replication. Data won't be lost even if some servers crashed. Also I/O requests from applications will be proceeded normally.

Replication strategy of SpreadOSD is combination of multi-master replication. When a master server is crashed, another master server fails-over immediately at minimal downtime.

SpreadOSD also supports inter-datacenter replication (aka. geo-redundancy). Each data is stored over multiple datacenters and you can prepare for disasters.


### Maintainability

SpreadOSD provides some management tools to control all data servers all together. And you can visualize load of servers with monitoring tools.
It means that management cost doesn't grow even if scale of the cluster grows.


## Learm more

  - [Architecture](doc/arch.md)
  - [Installation](doc/install.md)
  - [Cluster construction](doc/build.md)
  - [Operation](doc/operation.md)
  - [Fault management](doc/fault.md)
  - [Commandline reference](doc/command.md)
  - [Plug-in Reference](doc/plugin.md)
  - [API Reference](doc/api.md)
  - [Debugging and Improvement](doc/devel.md)
  - [HowTo](doc/howto.md)
  - [FAQ](doc/faq.md)


## Building HTML Documents

    $ gem install bluecloth
    $ make htmldoc
    $ open doc/index.html

## License

    Copyright (C) 2010-2011  FURUHASHI Sadayuki
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
    
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

See also NOTICE file.

