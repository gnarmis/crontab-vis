require 'parse-cron'
require 'time'

# This class helps visualize cron expressions over time, allowing people to
# see how the next week will look like with the given cron expression.
class CrontabVis
  attr_reader :anchor_time

  def initialize(anchor_time: nil)
    @anchor_time = if anchor_time.nil?
      Time.now
    else
      anchor_time
    end
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

  def next_occurrences(cron_expression)
    next_occurrences_for(parsed_line: parse_line(cron_expression))
  end

  protected

  def next_occurrences_for(parsed_line:, previous_occurrences: [])
    next_occurrence = if previous_occurrences.last.nil?
      parsed_line.next(anchor_time)
    else
      parsed_line.next(previous_occurrences.last)
    end

    if next_week_range.cover?(next_occurrence)
      next_occurrences_for(
        parsed_line: parsed_line,
        previous_occurrences: [previous_occurrences, next_occurrence].flatten
      )
    else
      previous_occurrences
    end
  end

  def parse_line(line)
    CronParser.new(line)
  end

  def next_week(step: 30)
    return @next_week if @next_week

    start_time = anchor_time
    end_time = start_time + 24*3600*7

    timestamps = []

    while start_time < end_time
     start_time += step
     timestamps << [start_time]
    end

    @next_week = timestamps.flatten
  end

  def next_week_range
    next_week.first..next_week.last
  end
end
