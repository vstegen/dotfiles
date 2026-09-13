local M = {}

local function assert_finite(value, name)
    local is_finite = type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
    assert(is_finite, name .. " must be a finite number")
end

local function linear_to_srgb(channel)
    if channel <= 0.0031308 then
        return 12.92 * channel
    end

    return 1.055 * channel ^ (1 / 2.4) - 0.055
end

local function to_byte(channel)
    channel = math.max(0, math.min(1, linear_to_srgb(channel)))
    return math.floor(channel * 255 + 0.5)
end

---Convert an OKLCH color to an sRGB hex color.
---Colors outside the sRGB gamut have their RGB channels clipped to the valid range.
---@param lightness number 0..1 (for example, 0.7 means 70%)
---@param chroma number 0 or greater
---@param hue number Hue angle in degrees; values wrap around 360
---@return string hex
function M.oklch_to_hex(lightness, chroma, hue)
    assert_finite(lightness, "lightness")
    assert_finite(chroma, "chroma")
    assert_finite(hue, "hue")
    assert(lightness >= 0 and lightness <= 1, "lightness must be between 0 and 1")
    assert(chroma >= 0, "chroma must be 0 or greater")

    local hue_radians = math.rad(hue % 360)
    local a = chroma * math.cos(hue_radians)
    local b = chroma * math.sin(hue_radians)

    local l_root = lightness + 0.3963377774 * a + 0.2158037573 * b
    local m_root = lightness - 0.1055613458 * a - 0.0638541728 * b
    local s_root = lightness - 0.0894841775 * a - 1.2914855480 * b

    local l = l_root ^ 3
    local m = m_root ^ 3
    local s = s_root ^ 3

    local red = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    local green = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    local blue = -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s

    return string.format("#%02X%02X%02X", to_byte(red), to_byte(green), to_byte(blue))
end

return M
