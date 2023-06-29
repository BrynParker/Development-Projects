  local hotbar = Inventory.new()
    hotbar.title = "Hotbar"
    hotbar:set_size(7, 1)
    hotbar.type = 'hotbar'
    hotbar.multislot = false
  nut.item.inventories[hotbar.type] = hotbar