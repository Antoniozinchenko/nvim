local setup, plugin = pcall(require, "flutter-intl")
if not setup then
	return
end

plugin.setup()
