def find_group_index(groups: list[dict[str, str | list[dict[str, str]]]], name: str):
    for i in range(len(groups)):
        if groups[i]["group"] == name:
            return i
    return -1

def find_entry_index(entries: list[dict[str, str]], key: str):
    for i in range(len(entries)):
        if entries[i]["key"] == key:
            return i
    return -1

def filter_groups_to_apply(
    lines: list[str],
    groups: list[dict[str, str | list[dict[str, str]]]],
) -> dict[str, dict[str, str]]:
    if not isinstance(groups, list):
        groups = [ groups, ]
    skip_group = False
    i_group = -1
    for i_line in range(len(lines)):
        line = lines[i_line].strip("\n").strip()
        if line == "":
            continue
        if line.startswith('[') and line.endswith(']'):
            i_group = find_group_index(groups, line)
            skip_group = i_group == -1
            continue
        elif skip_group:
            continue
        entries = groups[i_group]["for"]
        if len(entries) == 0:
            groups.pop(i_group)
            i_group = -1
            skip_group = True
            continue
        if '=' in line:
            key, existing_value = map(str.strip, line.split('=', 1))
            i_entry = find_entry_index(entries, key)
            if i_entry == -1:
                continue
            value = entries[i_entry]["value"]
            if existing_value == value:
                entries.pop(i_entry)
                if len(entries) == 0:
                    groups.pop(i_group)
                    i_group = -1
                    skip_group = True
                    continue
    return groups

def write_config_groups(
    lines: list[str],
    groups: dict[str, dict[str, str]],
):
    output = []
    i_group = -1
    for i_line in range(len(lines)):
        line = lines[i_line].strip("\n").strip()
        if line == "":
            continue
        if line.startswith('[') and line.endswith(']'):
            if i_group != -1:
                # reverse to keep the order when popping from the end
                leftover_entries = groups[i_group]["for"]
                for i_entry in range(len(leftover_entries)):
                    entry = leftover_entries[i_entry]
                    output.append(f"{entry["key"]}={entry["value"]}")
                    #entries.pop(i_entry)
                groups.pop(i_group)
                #i_group = -1
            output.append("")
            i_group = find_group_index(groups, line)
        elif i_group != -1:
            entries = groups[i_group]["for"]
            if '=' in line:
                key = str.strip(line.split('=', 1)[0])
                i_entry = find_entry_index(entries, key)
                if i_entry != -1:
                    value = entries[i_entry]["value"]
                    output.append(f"{key}={value}")
                    entries.pop(i_entry)
                    if len(entries) == 0:
                        groups.pop(i_group)
                        i_group = -1
                    continue
        output.append(line)
    if i_group != -1:
        # reverse to keep the order when popping from the end
        leftover_entries = groups[i_group]["for"]
        for i_entry in range(len(leftover_entries)):
            entry = leftover_entries[i_entry]
            output.append(f"{entry["key"]}={entry["value"]}")
            #entries.pop(i_entry)
        groups.pop(i_group)
        i_group = -1
    # at the end of the file
    for group in groups:
        entries = group["for"]
        #if not len(entries):
        #    continue
        output.append("")
        output.append(group["group"])
        for entry in entries:
            output.append(f"{entry["key"]}={entry["value"]}")
    output = '\n'.join(output).strip('\n')
    return output
