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


$log = CCLog.new(CCLog::LEVEL_INFO)


class LogService < Service
	def initialize
		@out = nil
	end

	def self.open!
		init.open
	end

	def open
		if path = ConfigBus.get_log_path
			out = File.open(path, "a")
			@out = $log.out = out
		end
	end

	def on_sighup
		if path = ConfigBus.get_log_path
			out = File.open(path, "a")
			if @out
				@out.close
				@out = nil
			end
			@out = $log.out = out
		end
	end

	def shutdown
		if @out
			@out.close
			@out = nil
		end
	end

	def log_event_bus
		$log.on_trace do
			SpreadOSD.constants.each {|const|
				klass = SpreadOSD.const_get(const)
				if klass.is_a?(Class) && klass < Bus
					bus = klass
					name = bus.name.gsub('SpreadOSD::','')
					$log.trace name
					bus.ebus_all_slots.each {|s|
						s = s.to_s.gsub('SpreadOSD::','')
						$log.trace "  #{s}"
					}
				end
			}
		end
	end

	ebus_connect :ProcessBus,
		:shutdown,
		:on_sighup
end


end
