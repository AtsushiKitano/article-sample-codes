# coding: utf-8
RSpec.shared_examples "gce" do |expected_gce, actual_gces, actual_disks|
  expected_instance = expected_gce["instance"]
  expected_disk = expected_gce["boot_disk"]

  it "GCE #{expected_instance["name"]}が存在する。" do
    expect(actual_gces[expected_instance["name"]]["name"]).to eq expected_instance["name"]
  end

  it "GCE #{expected_instance["name"]}のマシンタイプは、#{expected_instance["machine_type"]}である。" do
    expect(actual_gces[expected_instance["name"]]["machineType"].split("/").reverse[0]).to eq expected_instance["machine_type"]
  end

  it "GCE #{expected_instance["name"]}のゾーンは、#{expected_instance["zone"]}である。" do
    expect(actual_gces[expected_instance["name"]]["zone"].split("/").reverse[0]).to eq expected_instance["zone"]
  end

  it "GCE #{expected_instance["name"]}のsubnetworkは、#{expected_instance["subnetwork"]}である。" do
    expect(actual_gces[expected_instance["name"]]["networkInterfaces"][0]["subnetwork"].split("/").reverse[0]).to eq expected_instance["subnetwork"]
  end

  it "GCE #{expected_instance["name"]}のタグは、#{expected_instance["tags"]}である。" do
    expect(actual_gces[expected_instance["name"]]["tags"]["items"]).to match expected_instance["tags"]
  end

  it "GCE ディスク #{expected_disk["name"]}が存在する。" do
    expect(actual_disks[expected_disk["name"]]["name"]).to eq expected_disk["name"]
  end

  it "GCE ディスク #{expected_disk["name"]}のディスクサイズは、#{expected_disk["size"]}である。" do
    expect(actual_disks[expected_disk["name"]]["sizeGb"]).to eq expected_disk["size"]
  end

  it "GCE ディスク #{expected_disk["name"]}のOSは、#{expected_disk["image"].split("/").reverse[0]}である。" do
    expect(actual_disks[expected_disk["name"]]["licenses"][0].split("/").reverse[0]).to eq expected_disk["image"].split("/").reverse[0]
  end
end
