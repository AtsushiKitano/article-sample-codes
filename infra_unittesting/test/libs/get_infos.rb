require 'json'

def get_infos(project)
  {
    :networks => JSON.parse(command("gcloud compute networks list --project #{project} --format json").stdout).map { |vpc| [vpc["name"], vpc] }.to_h,
    :subnetworks => JSON.parse(command("gcloud compute networks subnets list --project #{project} --format json").stdout).map { |subnet| [subnet["name"], subnet] }.to_h,
    :firewalls =>JSON.parse(command("gcloud compute firewall-rules list --project #{project} --format json").stdout).map { |fw| [fw["name"], fw] }.to_h,
    :gces => JSON.parse(command("gcloud compute instances list --project #{project} --format json").stdout).map { |gce| [gce["name"], gce] }.to_h,
    :disks => JSON.parse(command("gcloud compute disks list --project #{project} --format json").stdout).map { |disk| [disk["name"], disk] }.to_h,
  }
end

def parse_firewall_rules(rules)
  Array.new().append(
    rules.map do |rule|
      if rule["type"] == "allow"
        {"IPProtocol" => rule["protocol"], "ports" => rule["ports"]}
      end
    end
  ).flatten
end
