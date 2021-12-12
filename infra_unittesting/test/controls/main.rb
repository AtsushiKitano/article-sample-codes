require 'yaml'
require_relative("../libs/get_infos")
require_relative("../libs/network")
require_relative("../libs/gce")

networks = YAML.load_file("../config/networks.yaml")
gces = YAML.load_file("../config/gce.yaml")
project = YAML.load_file("../config/project.yaml")

control "sample" do
  actual_infos = get_infos(project)

  networks.each do |expected_network|
    describe "network" do
      it_behaves_like "network", expected_network, actual_infos[:networks], actual_infos[:subnetworks], actual_infos[:firewalls]
    end
  end

  gces.each do |expected_gce|
    describe "gce" do
      it_behaves_like "gce", expected_gce, actual_infos[:gces], actual_infos[:disks]
    end
  end
end
