Category.create(name: "Adapter")
Category.create(name: "Monitor")

Workspace.create(name: "Android", address: "6th Floor", phone: "01692461313")
Workspace.create(name: "IOs", address: "6th Floor", phone: "01692461213")

5.times do |n|
  name  = "Adapter Device - #{n+1}"
  thumnail = "adapter.jpg"
  informations = "3 Volts 1 Amps, Fully Regulated
Operates from 100 to 240 VAC input with a standard 2-prong US plug (automatically adjusts to input voltage, so can be used by overseas customers; but an adapter plug to match the wall socket will be needed if this device will be used overseas).
Fully regulated means that this power supply maintains 3V output at all times, and adjusts the amperage output to match the device being powered (up to 1000mA).
3 foot output cable with a 5.5/2.1mm output plug. CE recognized."
  borrowed = false
  status = "High quality"
  category_id = 1
  workspace_id = 1
  Device.create!(name: name,
              thumnail: thumnail,
              informations: informations,
              borrowed: borrowed,
              status: status,
              category_id: category_id,
              workspace_id: workspace_id)
end

5.times do |n|
  name  = "Moniter Device - #{n+1}"
  thumnail = "moniter.jpg"
  informations = "3 Volts 1 Amps, Fully Regulated
Operates from 100 to 240 VAC input with a standard 2-prong US plug (automatically adjusts to input voltage, so can be used by overseas customers; but an adapter plug to match the wall socket will be needed if this device will be used overseas).
Fully regulated means that this power supply maintains 3V output at all times, and adjusts the amperage output to match the device being powered (up to 1000mA).
3 foot output cable with a 5.5/2.1mm output plug. CE recognized."
  borrowed = false
  status = "High quality"
  category_id = 2
  workspace_id = 2
  Device.create!(name: name,
              thumnail: thumnail,
              informations: informations,
              borrowed: borrowed,
              status: status,
              category_id: category_id,
              workspace_id: workspace_id)
end
