---@diagnostic disable: undefined-global

local function find_action_window(view, block_id)
  if block_id ~= nil then
    for _, window in ipairs(view.windows or {}) do
      for _, layer in ipairs(window.layers or {}) do
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == block_id then
            return window
          end
        end
      end
    end
  end

  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      return window
    end
  end
end

rex.action{
  name = "toggle_main_pane_layout",
  title = "Toggle Main Pane Layout",
  description = "Make the focused pane main and switch between tmux-style main-horizontal and main-vertical layouts.",
  category = "Pane",
  keywords = "tmux layout main horizontal vertical",
  run = function(ctx)
    local view, view_err = rex.session.view{}
    if view_err ~= nil then error(view_err, 0) end

    local window = find_action_window(view, ctx.block_id)
    if window == nil then error("No active window found.", 0) end

    local tiled_layer
    for _, layer in ipairs(window.layers or {}) do
      if layer.kind == "tiled" then
        tiled_layer = layer
        break
      end
    end

    local root_split = tiled_layer and tiled_layer.layout and tiled_layer.layout.split
    local focused_block_id = ctx.block_id or window.focused_block_id
    local block_ids = {}
    local other_block_ids = {}
    local focused_is_tiled = false
    for _, block in ipairs(tiled_layer and tiled_layer.blocks or {}) do
      if block.block_id ~= nil then
        if block.block_id == focused_block_id then
          focused_is_tiled = true
        else
          table.insert(other_block_ids, block.block_id)
        end
      end
    end

    if not focused_is_tiled then
      error("The focused pane is not in the tiled layout.", 0)
    end

    table.insert(block_ids, focused_block_id)
    for _, block_id in ipairs(other_block_ids) do
      table.insert(block_ids, block_id)
    end

    if #block_ids < 2 or root_split == nil then
      error("Toggle Main Pane Layout requires at least two tiled panes.", 0)
    end

    local main_direction = root_split.direction == "horizontal" and "vertical" or "horizontal"
    local stack_direction = main_direction == "horizontal" and "vertical" or "horizontal"
    local main_ratio = root_split.ratio

    -- Keep the first pane as the main pane. Place every other pane in an
    -- evenly-sized stack on the right (main-vertical) or bottom
    -- (main-horizontal), preserving the panes' current layout order.
    for index = 2, #block_ids do
      local direction = index == 2 and main_direction or stack_direction
      local ratio = index == 2 and main_ratio or 0.5
      local _, move_err = rex.session.move_block{
        block_id = block_ids[index],
        anchor_block_id = block_ids[index - 1],
        direction = direction,
        side = "after",
        ratio = ratio,
      }
      if move_err ~= nil then error(move_err, 0) end
    end

    local result, resize_err = rex.session.resize_pane{
      direction = main_direction,
      before_block_id = block_ids[1],
      after_block_id = block_ids[2],
      ratio = main_ratio,
    }
    if resize_err ~= nil then error(resize_err, 0) end

    -- The secondary area is a right-deep split tree. Size each split so all
    -- non-main panes receive an equal share of that area.
    for index = 2, #block_ids - 1 do
      local resize_err
      result, resize_err = rex.session.resize_pane{
        direction = stack_direction,
        before_block_id = block_ids[index],
        after_block_id = block_ids[index + 1],
        ratio = 1 / (#block_ids - index + 1),
      }
      if resize_err ~= nil then error(resize_err, 0) end
    end

    return {
      layout = main_direction == "horizontal" and "main-vertical" or "main-horizontal",
      main_block_id = focused_block_id,
      pane_count = #block_ids,
      revision = result.revision,
    }
  end,
}
