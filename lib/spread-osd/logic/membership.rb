#
#  SpreadOSD
#  Copyright (C) 2010  FURUHASHI Sadayuki
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
module SpreadOSD


class NodeList
	def initialize
		@path = nil
		@map = {}  # {nid => Node}
		update_hash
	end

	def open(path)
		@path = path
		read
	end

	def close
	end

	def get(nid)
		@map[nid]
	end

	def add(node)
		@map[node.nid] = node
		on_change
		true
	end

	def delete(nid)
		if node = @map.delete(nid)
			on_change
			node
		else
			false
		end
	end

	def include?(nid)
		@map.has_key?(nid)
	end

	def update(nid, address, name, rsids)
		node = @map[nid]
		if node
			if address
				node.address = address
			end
			if name
				node.name = name
			end
			if rsids
				node.rsids = rsids
			end
			false
		else
			on_change
			true
		end
	end

	def each(&block)
		@map.each_value(&block)
	end

	def get_hash
		@hash
	end

	def get_all_nids
		@map.map {|nid,node| nid }
	end

	def to_msgpack(out = '')
		@map.values.to_msgpack(out)
	end

	def from_msgpack(obj)
		map = {}
		obj.each {|n|
			node = Node.new.from_msgpack(n)
			map[node.nid] = node
		}
		@map = map
		on_change
		self
	end

	if RUBY_VERSION >= "1.9"
		CSV_OPEN_OPTION = {:col_sep => "\t"}
	else
		CSV_OPEN_OPTION = "\t"
	end

	private
	def read
		return nil unless @path

		begin
			map = {}

			tsv_read(@path) do |row|
				nid = row[0].to_i

				name = row[1]

				addr = row[2].to_s
				host, port = addr.split(':',2)
				port ||= DS_DEFAULT_PORT
				address = Address.new(host, port.to_i)

				rsids = row[3].split(',').map {|id| id.to_i }

				map[nid] = Node.new(nid, address, name, rsids)
			end

			@map = map

		rescue
			$log.debug $!
		end

		update_hash
	end

	def write
		return nil unless @path

		map = {}
		tsv_write(@path) do |writer|
			@map.each_value {|node|
				row = []
				row[0] = node.nid.to_s
				row[1] = node.name
				row[2] = "#{node.address.host}:#{node.address.port}"
				row[3] = node.rsids.join(',')
				writer << row
			}
		end

	rescue
		p $!
		pp $!.backtrace
		raise
	end

	def on_change
		update_hash
		write
	end

	def update_hash
		@hash = Digest::SHA1.digest(to_msgpack)
		write
	end


	if RUBY_VERSION >= "1.9"
		def tsv_read(path, &block)
			CSV.open(path, "r", :col_sep => "\t") do |csv|
				csv.each {|row|
					yield row
				}
			end
		end
		def tsv_write(path, &block)
			CSV.open(path, "w", :col_sep => "\t") do |csv|
				yield csv
			end
		end
	else
		def tsv_read(path, &block)
			CSV.open(path, "r", "\t") do |row|
				yield row
			end
		end
		def tsv_write(path, &block)
			CSV.open(path, "w", "\t") do |writer|
				yield writer
			end
		end
	end
end


class Membership
	def initialize
		@nodes = NodeList.new
		@replset = {}  # #{rsid => [nid]}
	end

	def open(path)
		@nodes.open(path)
		reset_replset
	end

	def close
		@nodes.close
	end

	def add_node(nid, address, name, rsids)
		node = Node.new(nid, address, name, rsids)
		if @nodes.get(nid)
			raise "nid already exist: #{nid}"
		end
		@nodes.add(node)
		add_replset(nid, rsids)
		node
	end

	def remove_node(nid)
		node = @nodes.delete(nid)
		unless node
			raise "nid not exist: #{nid}"
		end
		remove_replset(nid, node.rsids)
		true
	end

	def update_node_info(nid, address, name, rsids)
		node = get_node(nid)
		old_rsids = node.rsids
		@nodes.update(nid, address, name, rsids)
		if rsids
			remove_replset(nid, old_rsids)
			add_replset(nid, rsids)
		end
		true
	end

	def get_node(nid)
		node = @nodes.get(nid)
		unless node
			raise "no such node id: #{nid.inspect}"
		end
		node
	end

	def get_replset_nids(rsid)
		nids = @replset[rsid]
		if !nids || nids.empty?
			raise "no such rsid: #{rsid.inspect}"
		end
		nids
	end

	def get_all_nids
		@nodes.get_all_nids
	end

	def get_all_rsids
		@replset.keys
	end

	def include?(nid)
		@nodes.include?(nid)
	end

	def get_hash
		@nodes.get_hash
	end

	def to_msgpack(out = '')
		@nodes.to_msgpack(out)
	end

	def from_msgpack(obj)
		@nodes.from_msgpack(obj)
		reset_replset
		self
	end

	private
	def reset_replset
		replset = {}
		@nodes.each {|node|
			nid = node.nid
			node.rsids.each {|rsid|
				if ids = replset[rsid]
					ids << nid
				else
					replset[rsid] = [nid]
				end
			}
		}
		@replset = replset
	end

	def add_replset(nid, rsids)
		rsids.each {|rsid|
			if ids = @replset[rsid]
				ids << nid unless ids.include?(nid)
			else
				@replset[rsid] = [nid]
			end
		}
		true
	end

	def remove_replset(nid, rsids)
		rsids.reject! {|rsid|
			if ids = @replset[rsid]
				ids.delete(nid)
				ids.empty?
			end
		}
	end
end


end