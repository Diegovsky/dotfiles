taiwins = require'taiwins'

compositor = taiwins.compositor()

compositor:keyboard_model('pc106')
compositor:keyboard_layout('br')

compositor:repeat_info(20, 300)

compositor:panel_pos('top')

compositor:enable_xwayland(true)

for _, ws in ipairs(compositor:workspaces()) do
  ws.set_layout('floating')
end

compositor.desktop_gaps(10, 10)

bindings = {
  ['Super-Return'] = 'alacritty',
  ['Super-Backspace'] = 'firefox',
}
for key, app in pairs(bindings) do
  compositor.bind_key(key, function()
    os.execute(app)
  end)
end
