import ctypes
import os
import sys


def test_conpty():
    # Get the library path
    library_bin = os.environ.get("LIBRARY_BIN")
    if not library_bin:
        print("ERROR: LIBRARY_BIN environment variable not set")
        sys.exit(1)

    dll_path = os.path.join(library_bin, "conpty.dll")

    # Verify DLL file exists
    assert os.path.exists(dll_path), f"DLL not found at {dll_path}"
    print(f"DLL exists at {dll_path}")

    # load the DLL
    try:
        dll = ctypes.WinDLL(dll_path)
        print("DLL loaded successfully")
    except OSError as e:
        print(f"ERROR: Could not load DLL - {e}")
        sys.exit(1)

    # Test 3: Verify expected exports exist
    expected_exports = [
        "CreatePseudoConsole",
        "ClosePseudoConsole",
        "ResizePseudoConsole",
        "ClearPseudoConsole",
        "ReleasePseudoConsole",
    ]

    for export in expected_exports:
        try:
            func = getattr(dll, export)
            print(f"Export function '{export}' found")
        except AttributeError:
            print(f"ERROR: Export '{export}' not found")
            sys.exit(1)

    print("\nSuccess test_conpty finished!!")


if __name__ == "__main__":
    test_conpty()