import sys
code = sys.argv[-1]
ip = 0
vr = 0
tr = 0
stack = []
while ip < len(code):
    c = code[ip]
    if c == '+':
        stack.append(vr)
        ip += 1
    elif c == '-':
        vr = stack.pop()
        ip += 1
    elif c == '*':
        vr = stack[-1]
        ip += 1
    elif c == 'q':
        vr = stack[0]
        stack.pop(0)
        ip += 1
    elif c == '=':
        vr = ord(code[ip + 1])
        ip += 2
    elif c == 'L':
        string = ""
        ip += 1
        while code[ip] != ';':
            string += code[ip]
            ip += 1
        vr = int(string)
        ip += 1
    elif c == '[':
        ip += 1
    elif c == ']':
        ipc = ip - 1
        level = 0
        while code[ipc] != '[' or level > 0:
            if code[ipc] == ']':
                level += 1
            elif code[ipc] == '[':
                level -= 1
            ipc -= 1
        ip = ipc
    elif c == 'n':
        con = code[ip + 1]
        ins = code[ip + 2]
        if ins == '=' or ins == 'L' or ins == 'n':
            print("n must be followed by single width instruction")
            exit()

        if con == '=':
            if vr == tr:
                ip += 1
        if con == '!':
            if vr != tr:
                ip += 1
        elif con == '<':
            if vr < tr:
                ip += 1
        elif con == '>':
            if vr > tr:
                ip += 1
        elif con == '0':
            if vr == 0:
                ip += 1
        elif con == '1':
            if vr == 1:
                ip += 1
        elif con == 'n':
            if vr != 0:
                ip += 1
        else:
            print("unrecognised condition: " + con)
            exit()
        ip += 2
    elif c == 'b':
        while code[ip] != ']':
            ip += 1
        ip += 1
    elif c == 'i':
        vr += 1
        ip += 1
    elif c == 'd':
        vr -= 1
        ip += 1
    elif c == 's':
        t = vr
        vr = tr
        tr = t
        ip += 1
    elif c == 'e':
        exit()
    elif c == 'p':
        print(chr(vr), end="")
        ip += 1
    elif c == 'P':
        print(vr, end="")
        ip += 1
    elif c == 'N':
        print()
        ip += 1
    elif c == 'M':
        vr = vr * tr
        ip += 1
    elif c == 'S':
        vr = vr - tr
        ip += 1
    elif c == 'A':
        vr = vr + tr
        ip += 1