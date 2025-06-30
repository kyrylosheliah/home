import os
import shlex
import tempfile
import lib.helpers as helpers
import subprocess

def read_config_value(filename, group, key):
    if not os.path.exists(filename):
        return None
    try:
        output = subprocess.check_output(['sudo', 'cat', filename], encoding='utf-8')
        lines = output.splitlines()
    except subprocess.CalledProcessError:
        return None
    current_group = None
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('[') and stripped.endswith(']'):
            current_group = stripped[1:-1]
        elif current_group == group:
            if '=' in stripped:
                k, v = map(str.strip, stripped.split('=', 1))
                if k == key:
                    return v
    return None

def write_config_value(
        filename: str,
        group: str,
        key: str,
        value: str,
        ) -> str:
    if len(group) == 0 or len(key) == 0:
        return "len(group) == 0 or len(key) == 0"
    lines = []
    if os.path.exists(filename):
        file = open(filename, 'r', encoding='utf-8')
        lines = file.readlines()
        file.close()
    output = []
    current_group = None
    key_written = False
    for i in range(len(lines)):
        line = lines[i].strip("\n").strip()
        if line == "":
            continue
        if line.startswith('[') and line.endswith(']'):
            if current_group == group and not key_written:
                output.append(f"{key}={value}")
                key_written = True
                output.append("")
                if (i + 1 < len(lines)):
                    # inserting, include current line
                    output.append(''.join(lines[i:]))
                break
            current_group = line[1:-1]
            output.append("")
        elif current_group == group:
            if '=' in line:
                k, _ = map(str.strip, line.split('=', 1))
                if k == key:
                    output.append(f"{key}={value}")
                    key_written = True
                    if (i + 2 < len(lines)):
                        # replacing, exclude current line
                        output.append(''.join(lines[i + 1:]))
                    break
        output.append(line)
    # at the end of the file
    if not key_written:
        if current_group == group:
            # at the end of the group
            output.append(f"{key}={value}")
        else:
            # no matching group ever found
            output += [f"[{group}]", f"{key}={value}"]
    output = '\n'.join(output).strip('\n')
    tmp = tempfile.NamedTemporaryFile('w', delete=False, encoding='utf-8')
    tmp.write(output)
    tmp_filename = tmp.name
    tmp.close()
    copy_result = helpers.sh(
        f"sudo cp {shlex.quote(tmp_filename)} {shlex.quote(filename)}")
    os.remove(tmp_filename)
    if 0 != copy_result.returncode:
        return copy_result.stderr
    return ""

