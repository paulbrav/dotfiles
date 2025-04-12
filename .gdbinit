# Stanford CS107 Enhanced GDB Configuration
# Based on https://web.stanford.edu/class/cs107/resources/sample_gdbinit

# Don't confirm when quitting
set confirm off

# Print array elements on separate lines
set print array-indexes on
set print elements unlimited
set print pretty on
set print object on

# Print derived type info for objects
set print vtbl on
set print demangle on
set print asm-demangle on
set demangle-style gnu-v3

# Source code display settings
set listsize 15
set disassembly-flavor intel

# History settings
set history save on
set history size 10000
set history filename ~/.gdb_history
set history remove-duplicates unlimited

# Python pretty printers
python
import sys
import os
sys.path.insert(0, os.path.expanduser('~/.gdb/python'))
try:
    from libstdcxx.v6.printers import register_libstdcxx_printers
    register_libstdcxx_printers(None)
except ImportError:
    print("Note: libstdc++ pretty printers not found")
end

# Custom convenience functions
define parray
    if $argc != 2
        help parray
    else
        set $i = 0
        while $i < $arg1
            printf "[%d]: ", $i
            p *($arg0 + $i)
            set $i = $i + 1
        end
    end
end
document parray
    Print array elements with indices
    Usage: parray array_ptr length
end

# Enhanced memory examination
define xxd
    if $argc != 2
        help xxd
    else
        dump binary memory /tmp/gdb.dump $arg0 ((char *)$arg0 + $arg1)
        shell xxd /tmp/gdb.dump
        shell rm -f /tmp/gdb.dump
    end
end
document xxd
    Hexdump memory region
    Usage: xxd address length
end

# Print STL containers
define pvector
    if $argc == 0
        help pvector
    else
        set $size = $arg0._M_impl._M_finish - $arg0._M_impl._M_start
        set $capacity = $arg0._M_impl._M_end_of_storage - $arg0._M_impl._M_start
        set $size_max = $size - 1
        printf "Vector size = %u\n", $size
        printf "Vector capacity = %u\n", $capacity
        printf "Element "
        whatis $arg0._M_impl._M_start
        if $argc == 1
            printf "Vector contents:\n"
            set $i = 0
            while $i < $size
                printf "elem[%u]: ", $i
                p *($arg0._M_impl._M_start + $i)
                set $i++
            end
        end
    end
end
document pvector
    Print std::vector information
    Usage: pvector vector
end

# Breakpoint helpers
define bpl
    info breakpoints
end
document bpl
    List all breakpoints
end

define bp
    if $argc != 1
        help bp
    else
        break $arg0
    end
end
document bp
    Set a breakpoint
    Usage: bp location
end

# Memory leak detection
define leak_check
    set environment MALLOC_CHECK_ 2
    run
end
document leak_check
    Run program with memory leak checking enabled
end

# Enhanced step commands
define n+
    if $argc == 0
        next
    else
        next $arg0
    end
end
document n+
    Step over N times
    Usage: n+ [count]
end

define s+
    if $argc == 0
        step
    else
        step $arg0
    end
end
document s+
    Step into N times
    Usage: s+ [count]
end

# Color settings for TUI mode
set tui active-border-mode bold
set tui border-mode normal
set tui compact-source on

# Save breakpoints between sessions
save breakpoints ~/.gdb-breakpoints

# Additional settings for C++
set print static-members on
set print symbol-filename on
set print thread-events on

# Enable all warnings
set complaints 100

# Don't pause for long output
set height 0
set width 0

# Load any local configurations
source ~/.gdbinit.local 