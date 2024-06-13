local function ToHSL(r, g, b)
  local M = math.max(r, g, b)
  local m = math.min(r, g, b)

  local c = M - m

  local h_dash
  if c == 0 then
    h_dash = 0
  elseif M == r then
    h_dash = ((g - b) / c) % 6
  elseif M == g then
    h_dash = (b - r) / c + 2
  elseif M == b then
    h_dash = (r - g) / c + 4
  end
  local h = h_dash * 60

  local l = 1/2 * (M + m)

  local s
  if l == 1 or l == 0 then
    s = 0
  else
    s = c / (1 - math.abs(2 * l - 1))
  end

  return h, s, l
end

local function FromHSL(h, s, l)
  c = (1 - math.abs(2 * l -1)) * s
  h_dash = h / 60
  x = c * ( 1 - math.max(h_dash % 2 - 1))
  m = l - c / 2
  if h < 1 then
    return c + m, x + m, 0 + m
  elseif h < 2 then
    return x + m, c + m, 0 + m
  elseif h < 3 then
    return 0 + m, c + m, x + m
  elseif h < 4 then
    return 0 + m, x + m, c + m
  elseif h< 5 then
    return x + m, 0 + m, c + m
  else
    return c + m, 0 + m, x + m
  end
end

function Baganator_Minimalist_Lighten(r, g, b, shift)
  local h, s, l = ToHSL(r, g, b)
  l = math.max(0, math.min(1, l + shift))

  return FromHSL(h, s, l)
end
