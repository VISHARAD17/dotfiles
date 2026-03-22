local java_home = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home"
local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

return {
  cmd = {
    java_home .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
		"-javaagent:" .. lombok_path,
    "-Xmx1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    
    -- Replace 'YOUR_USER' and 'YOUR_PATH' with your actual jdtls installation path
    "-jar", vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_mac"),
    "-data", vim.fn.expand("~/.cache/jdtls-workspace")
  },
  filetypes = { "java" },
  root_markers = { "pom.xml", "build.gradle", ".git" },
  settings = {
    java = {
      home = java_home,
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = java_home,
            default = true,
          },
        },
      },
    },
  },
}
