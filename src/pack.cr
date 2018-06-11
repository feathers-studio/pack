require "commander"

cli = Commander::Command.new do |cmd|
  cmd.use = "pack"
  cmd.long = "Pack and move at a moment's notice."

  cmd.run do |options, arguments|
    puts cmd.help
  end

  cmd.commands.add do |cmd|
    cmd.use = "start"
    cmd.short = "Start packing. Creates a manifest."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      # Do something
    end
  end

  cmd.commands.add do |cmd|
    cmd.use = "add"
    cmd.short = "Add path to manifest."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      # Do something
    end
  end

  cmd.commands.add do |cmd|
    cmd.use = "up"
    cmd.short = "Stop packing and create archive."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      # Do something
    end
  end
end

Commander.run(cli, ARGV)