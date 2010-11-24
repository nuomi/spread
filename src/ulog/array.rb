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


class ArrayUpdateLog < UpdateLog
	def initialize(path)
		@array = []
	end

	def close
		@array.clear
	end

	def append(data, &block)
		@array.push(data)
		begin
			block.call
		rescue
			@array.pop
			raise
		end
	end

	# offsetから1レコード取り出して返す
	def get(offset)
		return @array[offset], offset+1
	end
end


end
