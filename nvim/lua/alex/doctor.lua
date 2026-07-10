local M = {}

local function is_finding(line)
  local warning = line:match("%f[%a]WARNING%f[%A]")
  local error = line:match("%f[%a]ERROR%f[%A]")
  return warning ~= nil or error ~= nil
end

function M.assert_health()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local report = table.concat(lines, "\n")
  local findings = vim.tbl_filter(is_finding, lines)

  vim.api.nvim_out_write(report .. "\n")
  if #findings > 0 then
    vim.cmd("cquit 1")
  end
end

return M
