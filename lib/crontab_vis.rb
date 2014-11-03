require 'parse-cron'

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

    if next_week.cover?(next_occurrence)
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

  def next_week
    anchor_time..(anchor_time + 3600*24*7)
  end
end
