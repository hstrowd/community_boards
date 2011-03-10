require 'csv'

module EventImport
  RequiredSeriesAttrs  = %w(title)
  # The attributes available to users during import.
  AvailableSeriesAttrs = %w(title description visibility)
  AvailableEventAttrs  = %w(instance_description start_time end_time cost)

  # Imports the contents of the provided file into the specified community, setting the 
  # specified user as their creator.
  def self.import(import_file, community, creator)
    Rails.logger.info("User #{creator.id} attempting to upload events from #{import_file.inspect} into community #{community.id}.")
    # Keep track of any errors that occur.
    errors = {}

    if(community.private? && !community.members.include?(creator))
      # If this user is not athorized to create events in this community, error out.
      Rails.logger.warn("User #{creator.id} is not allowed to create events for community #{community.id}.")
      errors << 'User not authorized to create events in the specified community.'
    end

    # Parse the provided content.
    headers, content = validate_and_parse_content(import_file, errors)

    if errors.empty?
      content.each_with_index do |row, index|
        unless create_event(row, community, creator, errors)
          errors << "Unable to import row ##{index}. Please verify that all necessary information has been provided"
        end
      end
    end

    errors
  end

  # Validates the provided file to check for malicious content. Parses the content as a CSV.
  # Validates that the header of the CSV includes all required attributes.
  def validate_and_parse_content(import_file, errors)
    rows = CSV.parse(import_file.read)

    # The first row should always be the header.
    headers = rows[0]
    if((required_attrs - headers).empty?)
      headers, rows
    else
      Rails.logger.warn("Import file #{import_file.inspect} missing attributes #{(required_attrs - header).inspect}.")
      errors << 'Invalid import content. Please verify that all required fields have been specified.'
    end
  end

  # TODO: Pass back any rails validation errors that 
  def create_event(content, community, creator, errors)
    begin
      # Identify the Series data for this event.
      series_data = { 'title' => content['title'],
                      'description' => (content['description'] || ''),
                      'visibility_id' => ((content['visibility'] && EventVisibility.find_by_name(content['visibility']))
                                           || EventVisibility.public) }
      series = find_or_create_series(series_data)

      # Identify the Instance data of this event.
      instance_data = { 'event_series_id' => series.id,
                        'instance_description' => content['instance_description'],
                        'community_id' => community.id,
                        'creator_id' => creator.id,
                        'cost' => event_date['cost']
                        'start_time' => ((event_date['start_time'] && Time.iso8601(event_data['start_time']))
                                          || nil),
                        'end_time' => ((event_date['end_time'] && Time.iso8601(event_data['start_time']))
                                        || nil) }
      instance = find_or_create_instance(instance_data)
    rescue Exception => exp
      Rails.logger.warn("Error encountered during import of #{row.inspect}: #{exp.message}\n  Backtrace: #{exp.backtrace * "\n"}")
    end
    instance
  end

  def find_or_create_series(series_data)
    unless(series = EventSeries.find(:first, :conditions => series_data))
      series = EventSeries.new(series_data)
      series.save!
    end
    series
  end

  def find_or_create_instance(instance_data)
    unless(instance = Event.find(:first, :conditions => instance_data))
      instance = Event.new(instance_data)
      instance.save!
    end
    instance
  end
end
