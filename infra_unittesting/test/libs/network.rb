# coding: utf-8
RSpec.shared_examples "network" do |expected_network, actual_networks, actual_subnetworks, actual_firewalls|
  it "vpcネットワーク #{expected_network["name"]} が存在する。" do
    expect(actual_networks[expected_network["name"]]["name"]).to eq expected_network["name"]
  end

  expected_network["subnetworks"].each do |subnetwork|
    it "サブネットワーク #{subnetwork["name"]}が存在する。" do
      expect(actual_subnetworks[subnetwork["name"]]["name"]).to eq subnetwork["name"]
    end

    it "サブネットワーク #{subnetwork["name"]}のcidrレンジは、#{subnetwork["cidr"]}である" do
      expect(actual_subnetworks[subnetwork["name"]]["ipCidrRange"]).to eq subnetwork["cidr"]
    end

    it "サブネットワーク #{subnetwork["name"]}のリージョンは、#{subnetwork["region"]}である" do
      expect(actual_subnetworks[subnetwork["name"]]["region"].split("/").reverse[0]).to eq subnetwork["region"]
    end

    it "サブネットワーク #{subnetwork["name"]}は、#{name}のVPCネットワークに所属している。" do
      expect(actual_subnetworks[subnetwork["name"]]["network"].split("/").reverse[0]).to eq expected_network["name"]
    end
  end

  expected_network["firewall"].each do |fw|
    it "ファイアーフォール #{fw["name"]}が存在する。" do
      expect(actual_firewalls[fw["name"]]["name"]).to eq fw["name"]
    end

    it "ファイアーフォール #{fw["name"]}の通信方向の制御は、#{fw["direction"]}である。" do
      expect(actual_firewalls[fw["name"]]["direction"]).to eq fw["direction"]
    end

    it "ファイアーフォール #{fw["name"]}は、#{expected_network["name"]}のVPCネットワークに所属している。" do
      expect(actual_firewalls[fw["name"]]["network"].split("/").reverse[0]).to eq expected_network["name"]
    end

    it "ファイアーフォール #{fw["name"]}の優先度は、#{fw["priority"]}である。" do
      expect(actual_firewalls[fw["name"]]["priority"]).to eq fw["priority"]
    end

    it "ファイアーフォール #{fw["name"]}のルールは、#{parse_firewall_rules(fw["rules"])}である。" do
      expect(actual_firewalls[fw["name"]]["allowed"]).to eq parse_firewall_rules(fw["rules"])
    end

    it "ファイアーフォール #{fw["name"]}のログ取得のメタデータは、#{fw["log_config_metadata"]}である。" do
      expect(actual_firewalls[fw["name"]]["logConfig"]["metadata"]).to match fw["log_config_metadata"]
    end

  end
end
