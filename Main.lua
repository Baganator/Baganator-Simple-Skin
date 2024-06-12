local function ConvertTags(tags)
  local res = {}
  for _, tag in ipairs(tags) do
    res[tag] = true
  end
  return res
end

Baganator.Constants.ButtonFrameOffset = 0

local backdropInfo = {
  bgFile = "Interface/AddOns/Baganator-DarkMinimalist/Assets/minimalist-backgroundfile",
  edgeFile = "Interface/AddOns/Baganator-DarkMinimalist/Assets/minimalist-edgefile",
  tile = true,
  tileEdge = true,
  tileSize = 32,
  edgeSize = 6,
  insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local color = CreateColor(0.05, 0.05, 0.05)

local toColor = {
  backdrops = {},
  textures = {},
}

local possibleVisuals = {
  "BotLeftCorner", "BotRightCorner", "BottomBorder", "LeftBorder", "RightBorder",
  "TopRightCorner", "TopLeftCorner", "TopBorder", "TitleBg", "Bg",
  "TopTileStreaks",
}
local function RemoveFrameTextures(frame)
  for _, key in ipairs(possibleVisuals) do
    if frame[key] then
      frame[key]:Hide()
      frame[key]:SetTexture()
    end
  end
  if frame.NineSlice then
    for _, region in ipairs({frame.NineSlice:GetRegions()}) do
      region:Hide()
    end
  end
end

local texCoords = {0.08, 0.92, 0.08, 0.92}
local function ItemButtonQualityHook(frame)
  if frame.bgrMinimalistHooked then
    frame.IconBorder:SetTexture("Interface/AddOns/Baganator-DarkMinimalist/Assets/minimalist-icon-border")
    frame:ClearNormalTexture()
    local c = ITEM_QUALITY_COLORS[quality]
    if c then
      c = c.color
      frame.IconBorder:SetVertexColor(c.r, c.g, c.b)
    end
  end
end
local function ItemButtonTextureHook(frame)
  if frame.bgrMinimalistHooked then
    frame.icon:SetTexCoord(unpack(texCoords))
  end
end

local function StyleButton(button)
  button.Left:Hide()
  button.Right:Hide()
  button.Middle:Hide()
  button:ClearHighlightTexture()

  local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
  backdrop:SetBackdrop(backdropInfo)
  backdrop:SetBackdropColor(color.r, color.g, color.b, 0.5)
  backdrop:SetBackdropBorderColor(color.r, color.g, color.b, 1)
  table.insert(toColor.backdrops, {backdrop = backdrop, bgAlpha = 0.5, borderAlpha = 1})
  backdrop:SetAllPoints()
  backdrop:SetFrameStrata("BACKGROUND")
  button:SetScript("OnEnter", function()
    if button:IsEnabled() then
      backdrop:SetBackdropColor(math.min(1, color.r + 0.15), math.min(1, color.g + 0.15), math.min(color.b + 0.15), 0.8)
    end
  end)
  button:SetScript("OnLeave", function()
    backdrop:SetBackdropColor(color.r, color.g, color.b, 0.5)
  end)
end

local skinners = {
  ItemButton = function(frame)
    frame.bgrMinimalistHooked = true
    frame.darkBg = frame:CreateTexture(nil, "BACKGROUND")
    frame.darkBg:SetColorTexture(color.r, color.g, color.b, 0.4)
    frame.darkBg:SetPoint("CENTER")
    frame.darkBg:SetSize(36, 36)
    frame.IconBorder:SetSize(36, 36)
    frame.IconBorder:ClearAllPoints()
    frame.IconBorder:SetPoint("CENTER")
    frame.icon:SetSize(36, 36)
    frame.icon:ClearAllPoints()
    frame.icon:SetPoint("CENTER")
    table.insert(toColor.textures, {texture = frame.darkBg, alpha = 0.4})
    if frame.SetItemButtonQuality then
      hooksecurefunc(frame, "SetItemButtonQuality", ItemButtonQualityHook)
    end
    if frame.SetItemButtonTexture then
      hooksecurefunc(frame, "SetItemButtonTexture", ItemButtonTextureHook)
    end
  end,
  IconButton = function(button)
    StyleButton(button)
  end,
  Button = function(button)
    StyleButton(button)
  end,
  ButtonFrame = function(frame)
    RemoveFrameTextures(frame)
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetBackdrop(backdropInfo)
    backdrop:SetBackdropColor(color.r, color.g, color.b, 0.6)
    backdrop:SetBackdropBorderColor(color.r, color.g, color.b, 1)
    table.insert(toColor.backdrops, {backdrop = backdrop, bgAlpha = 0.6, borderAlpha = 1})
    backdrop:SetAllPoints()
    backdrop:SetFrameStrata("BACKGROUND")
  end,
  SearchBox = function(frame)
  end,
  EditBox = function(frame)
  end,
  TabButton = function(frame)
  end,
  TopTabButton = function(frame)
  end,
  SideTabButton = function(frame)
  end,
  TrimScrollBar = function(frame)
  end,
  CheckBox = function(frame)
  end,
  Slider = function(frame)
  end,
  InsetFrame = function(frame)
  end,
  CornerWidget = function(frame, tags)
  end,
  DropDownWithPopout = function(button)
  end,
}

if C_AddOns.IsAddOnLoaded("Masque") then
  skinners.ItemButton = function() end
else
  hooksecurefunc("SetItemButtonQuality", ItemButtonQualityHook)
  hooksecurefunc("SetItemButtonTexture", ItemButtonTextureHook)
end

local function SkinFrame(details)
  local func = skinners[details.regionType]
  if func then
    func(details.region, details.tags and ConvertTags(details.tags) or {})
  end
end

Baganator.API.Skins.RegisterListener(SkinFrame)

--Baganator.Config.Set(Baganator.Config.Options.EMPTY_SLOT_BACKGROUND, true)

for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do
  SkinFrame(details)
end
