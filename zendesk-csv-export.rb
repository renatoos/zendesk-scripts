#################################################################
## Script to export data from Zendesk Support instances to CSV
## using official Zendesk Ruby API Client 
## Author: Renato Oliveira
## Repo: https://github.com/renatoos/zendesk-scripts
## 
## More info: https://github.com/zendesk/zendesk_api_client_rb
##################################################################


require 'zendesk_api'

#Zendesk Client API
  client = ZendeskAPI::Client.new do |config|
    config.url = "https://<zendesk-domain>.zendesk.com/api/v2" 
    config.username = "<zendesk-user@useremail.com>"
    config.token = "<sendesk-support-token>"
    config.retry = true
  end
 
  csvHeader = ""
  csvData = ""
  counter = 0

  # Label used to name the CSV file
  entity = "TicketForms"

    ################# ENTITIES/OBJECTS TO EXPORT  #############################
    # Uncomment one of the below lines to export all data from that entity.
    # 
    # client.macros.include(:categories,:permissions,:app_installation,:usage_1h,:usage_24h,:usage_7d,:usage_30d).all! do |resource|
    # client.triggers.include(:permissions,:app_installation,:usage_1h,:usage_24h,:usage_7d,:usage_30d).all!   do |resource|
    # client.automations.include(:permissions,:app_installation,:usage_1h,:usage_24h,:usage_7d,:usage_30d).all! do |resource|
    # client.views.include(:permissions,:app_installation).all! do |resource|
    # client.groups.all! do |resource| 
    # client.apps.all! do |resource|
    # client.ticket_fields.all! do |resource|
    # client.user_fields.all! do |resource|
    # client.organization_fields.all! do |resource|
     client.ticket_forms.all! do |resource|
    # client.tags.all! do |resource|
    #
    # ATTENTION: The follow objects are NOT implemented on Ruby Client API so far: SLAS, Dynamic Content
    #########################################################################
    

    # Executes only in the first iteration to generate the CSV Header
    if counter == 0 && resource.length > 0
        resource.keys.each{ |key|
          csvHeader = "#{csvHeader}#{key};"
        }
        csvHeader = "#{csvHeader}\r\n" 
        counter = 1
    end

    # Iterate to generate CSV Data
    resource.keys.each{ |key|

      # WORKAROUND: Some fields have line break that not fits CSV files. 
      # This "IF" block exclude that info setting "..." to the value. 
      # TODO: Replace line breaks and return all data
      if key != "long_description" && key != "raw_long_description" && key != "installation_instructions" && key != "raw_installation_instructions" 
        value = resource[key]
      else 
        value = "..."
      end
      csvData = "#{csvData}#{value};"
    }
    csvData = "#{csvData}\r\n"
 
end

# Print result to console - For testing
# puts "######## CSV Report  ##########"
# puts csvHeader
# puts csvData

# Generate CSV file
filename = "Zendesk-#{entity}-#{Time.now.strftime('%Y%m%d')}.csv"
File.write(filename, csvHeader, mode: "w")
File.write(filename, csvData, mode: "a")
