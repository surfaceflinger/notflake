{
  anime4k,
  cunny,
  lib,
  writeTextFile,
}:
let
  anime4kShader = name: "${anime4k}/Anime4K_${name}.glsl";
  cunnyShader = name: "${cunny}/share/mpv-shaders/CuNNy/${name}.glsl";

  anime4kDownscale = [
    (anime4kShader "AutoDownscalePre_x2")
    (anime4kShader "AutoDownscalePre_x4")
  ];

  recommendedMarker = recommended: key: if lib.elem key recommended then " (R)" else "";

  anime4kRecommended = [
    "HQ A+A"
    "Fast A"
  ];

  # Stacks from Anime4K's low-end and high-end templates.
  anime4kStacks =
    quality: restore: small: final:
    let
      recommendation = if quality == "HQ" then "high end" else "low end";
      mark = variant: "${quality} ${variant}" |> recommendedMarker anime4kRecommended;
    in
    [
      {
        name = "Anime4K sharp (A ${quality}) (${recommendation})${mark "A"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Restore_CNN_${restore}")
          (anime4kShader "Upscale_CNN_x2_${restore}")
        ]
        ++ anime4kDownscale
        ++ [ (anime4kShader "Upscale_CNN_x2_${final}") ];
      }
      {
        name = "Anime4K soft (B ${quality}) (${recommendation})${mark "B"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Restore_CNN_Soft_${restore}")
          (anime4kShader "Upscale_CNN_x2_${restore}")
        ]
        ++ anime4kDownscale
        ++ [ (anime4kShader "Upscale_CNN_x2_${final}") ];
      }
      {
        name = "Anime4K denoise (C ${quality}) (${recommendation})${mark "C"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Upscale_Denoise_CNN_x2_${restore}")
        ]
        ++ anime4kDownscale
        ++ [ (anime4kShader "Upscale_CNN_x2_${final}") ];
      }
      {
        name = "Anime4K double sharp (A+A ${quality}) (${recommendation})${mark "A+A"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Restore_CNN_${restore}")
          (anime4kShader "Upscale_CNN_x2_${restore}")
          (anime4kShader "Restore_CNN_${small}")
        ]
        ++ anime4kDownscale
        ++ [ (anime4kShader "Upscale_CNN_x2_${final}") ];
      }
      {
        name = "Anime4K double soft (B+B ${quality}) (${recommendation})${mark "B+B"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Restore_CNN_Soft_${restore}")
          (anime4kShader "Upscale_CNN_x2_${restore}")
        ]
        ++ anime4kDownscale
        ++ [
          (anime4kShader "Restore_CNN_Soft_${small}")
          (anime4kShader "Upscale_CNN_x2_${final}")
        ];
      }
      {
        name = "Anime4K denoise+sharp (C+A ${quality}) (${recommendation})${mark "C+A"}";
        shaders = [
          (anime4kShader "Clamp_Highlights")
          (anime4kShader "Upscale_Denoise_CNN_x2_${restore}")
        ]
        ++ anime4kDownscale
        ++ [
          (anime4kShader "Restore_CNN_${small}")
          (anime4kShader "Upscale_CNN_x2_${final}")
        ];
      }
    ];

  cunnyTiers = [
    {
      tier = "8x32";
      label = "max";
      recommendation = "high end";
      variants = [ "DS" ];
    }
    {
      tier = "4x32";
      label = "ultra";
      recommendation = "high end";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "4x24";
      label = "high";
      recommendation = "high-mid";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "4x16";
      label = "medium";
      recommendation = "mid";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "4x12";
      label = "light";
      recommendation = "low-mid";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "3x12";
      label = "lighter";
      recommendation = "low";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "2x12";
      label = "minimal";
      recommendation = "low";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "fast";
      label = "fast";
      recommendation = "very low";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "faster";
      label = "faster";
      recommendation = "very low";
      variants = [
        "DS"
        "SOFT"
      ];
    }
    {
      tier = "veryfast";
      label = "fastest";
      recommendation = "potato";
      variants = [ "SOFT" ];
    }
  ];

  cunnyVariant = variant: if variant == "DS" then "detail" else "soft";

  cunnyRecommended = [
    "4x32 DS"
    "4x16 DS"
    "2x12 DS"
    "veryfast SOFT"
  ];

  cunnyStacks =
    cunnyTiers
    |> lib.concatMap (
      {
        tier,
        label,
        recommendation,
        variants,
      }:
      map (
        variant:
        let
          mark = "${tier} ${variant}" |> recommendedMarker cunnyRecommended;
        in
        {
          name = "CuNNy ${label} ${cunnyVariant variant} (${tier} ${variant}) (${recommendation})${mark}";
          shaders = [ (cunnyShader "${lib.toLower variant}/CuNNy-${tier}-${variant}") ];
        }
      ) variants
    );

  stacks = anime4kStacks "HQ" "VL" "M" "M" ++ anime4kStacks "Fast" "M" "S" "S" ++ cunnyStacks;
in
writeTextFile {
  name = "mpv-shader-stacks";
  destination = "/share/mpv/scripts/shader-stacks.lua";

  text = ''
    local input = require("mp.input")
    local utils = require("mp.utils")
    local stacks = utils.parse_json([==[
    ${builtins.toJSON stacks}
    ]==])

    local selected = 1

    local function apply(index)
      local stack = stacks[index]
      mp.commandv("change-list", "glsl-shaders", "set", table.concat(stack.shaders, ":"))
      mp.osd_message("Shader stack: " .. stack.name)
      selected = index
    end

    mp.add_key_binding(nil, "select", function()
      local items = {}
      for index, stack in ipairs(stacks) do
        items[index] = stack.name
      end
      input.select({
        prompt = "Shader stack: ",
        items = items,
        default_item = selected,
        submit = apply,
      })
    end)
  '';

  passthru.scriptName = "shader-stacks.lua";

  meta.description = "Selectable Anime4K and CuNNy shader stacks for mpv";
}
