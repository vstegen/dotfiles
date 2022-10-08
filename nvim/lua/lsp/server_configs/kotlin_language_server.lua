return {
  root_dir = function(fname)
    local util = require "lspconfig/util"

    local root_files = {
      "settings.gradle", -- Gradle (multi-project)
      "settings.gradle.kts", -- Gradle (multi-project)
      "build.xml", -- Ant
      "pom.xml", -- Maven
    }

    local fallback_root_files = {
      "build.gradle", -- Gradle
      "build.gradle.kts", -- Gradle
    }
    return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
  end,
}
