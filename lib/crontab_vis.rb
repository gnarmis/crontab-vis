require 'parse-cron'
require 'time'
require 'active_support/all'

# This class helps visualize cron expressions over time, allowing people to
# see how the next week will look like with the given cron expression.
class CrontabVis
  attr_reader :anchor_time
  TIME_LOOKAHEAD = 1.week

  def initialize(anchor_time: nil)
    picked_value = if anchor_time.nil?
      Time.now
    else
      anchor_time
    end

    @anchor_time = picked_value.beginning_of_month
  end

  def next_events(cron_expression)
    occurrences = next_occurrences(cron_expression)

    occurrences.each_with_index.
      each_with_object([]) do |(item, index), list|
        list << {
          id: index,
          content: cron_expression,
          start: item.iso8601
        }
      end
  end

  def next_occurrences(cron_expression, limit: TIME_LOOKAHEAD)
    next_occurrences_for(
      parsed_line: parse_line(cron_expression),
      limit: limit
    )
  end

  protected

  def next_occurrences_for(parsed_line:, limit: TIME_LOOKAHEAD)
    start_time = parsed_line.next(anchor_time)
    end_time = anchor_time+limit

    occurrences = [start_time]

    while start_time <= end_time
      if (start_time = parsed_line.next(start_time)) <= end_time
        occurrences << start_time
      end
    end

    occurrences
  end

  def parse_line(line)
    CronParser.new(line)
  end
end
