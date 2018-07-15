desc(
  'Run rubycritic and parse results to show it friendly'
)
task check_rubycritc: :environment do
  analized_paths = 'app lib'
  report_path = 'tmp/rubycritic'

  # execute command (analize)
  system("bundle exec rubycritic #{analized_paths} -f json -p #{report_path}")

  # parse result
  rubycritic_result = JSON.parse(File.read("#{report_path}/report.json"))

  notes = []

  rubycritic_result['analysed_modules'].each do |analyzed_module|
    analyzed_module['smells'].each do |smell|
      smell['locations'].each do |location|
        smell_path = location['path']
        smell_line = location['line']

        notes << {
          path: smell_path,
          line: smell_line,
          type: smell['type'],
          message: smell['message']
        }
      end
    end
  end

  if notes.empty?
    puts "\nNo smell detected\n"
  else
    puts "\n#{notes.size} smell(s) detected\n"

    notes.each do |note|
      puts "- #{note[:path]}:#{note[:line]} - #{note[:message]} (#{note[:type]})"
    end
  end

  minimum_score = 90
  score = rubycritic_result['score'].to_i
  good_score = score >= minimum_score

  if good_score
    puts "\nThe global score (#{score} >= #{minimum_score}) was accepted"
  else
    puts "\nThe global score (#{score} < #{minimum_score}) was rejected"
  end
end
