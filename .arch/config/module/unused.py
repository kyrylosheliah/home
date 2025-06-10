

# # Adding a Hyprland plugin
#
## hyprpm dependencies
#        "cmake",
#        "meson",
#        "cpio",
#        "pkgconf",
#        "gcc",
#
#def install_hy3():
#    result = sh("hyprpm add https://github.com/outfoxxed/hy3")
#    if 0 != result.returncode:
#        return False
#    result = sh("hyprpm enable hy3")
#    return 0 == result.returncode
#
#username = os.getlogin()
#
#blocks.append({ "ensure": conditional_execution, "for": {
#    "title": "Hyprland hy3 plugin",
#    "condition": lambda: not file_exists(f"/var/cache/hyprpm/{username}/hy3/hy3.so"),
#    "function": install_hy3,
#    } },)
