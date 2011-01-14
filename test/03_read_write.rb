#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'common'

LOOP   = (ARGV[0] || ENV["LOOP"] || (ENV["HEAVY"] ? 20 : 3)).to_i
SIZE   = (ARGV[1] || 10).to_i
NUM    = (ARGV[2] || 50).to_i

mds = start_mds
cs = start_cs
ds0 = start_ds(0, 0)
ds1 = start_ds(1, 0)
ds2 = start_ds(2, 1)
ds3 = start_ds(3, 1)

cs.show_nodes
cs.show_version

gw = start_gw

pid = Process.pid
keyf = "#{pid}-key%d"
data = "@"*SIZE

test "run normally" do
	c = gw.client

	LOOP.times {|o|
		NUM.times do |i|
			key = keyf % i

			test 'write offset=0' do
				c.call(:write, key, 0, data)
			end

			test 'write offset=2' do
				c.call(:write, key, 2, "OVER")
			end
		end

		data_over = data.dup
		data_over[2,4] = "OVER"

		data_0_8  = data_over[0,8]
		data_3_20 = data_over[3,20]

		NUM.times do |i|
			key = keyf % i

			test 'read offset=0 size=8' do
				data_ = c.call(:read, key, 0, 8)

				test_equals data_0_8, data_, 'read data_ 0-8 == data'
			end

			test 'read offset=3 size=20' do
				data_ = c.call(:read, key, 3, 20)

				test_equals data_3_20, data_, 'read data_ 3-20 == data'
			end

			test 'get_data_attrs' do
				data_ = c.call(:get_data, key)
				attrs_ = c.call(:get_attrs, key)

				test_equals data_over, data_, 'get_data data_ == data'
				test_equals Hash.new, attrs_, 'get_attrs attrs_ == {}'
			end
		end
	}
end

cs.show_items
cs.show_stat

term_all(ds0, ds1, ds2, ds3, gw, mds, cs)

