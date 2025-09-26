# Systematic Debugging Guide: Resolving `rc.exe` Not Found Error

**Objective:** To systematically diagnose why the Chromium build process cannot find `rc.exe` and apply a working solution.

**Summary of Problem:** The build fails with a `FileNotFoundError` when `build\toolchain\win\rc\rc.py` attempts to execute `rc.exe`. This occurs despite Visual Studio 2022 and the correct Windows SDK being installed.

Follow these steps in order. Do not skip any steps, as they build on each other to isolate the root cause.

---

## Step 1: Verify the Build Environment Manually

This step confirms that the Visual Studio environment script (`vcvars64.bat`) is working correctly on its own, separate from the `autoninja` build process.

1.  **Open a clean Command Prompt:**
    *   Press `Win + R`, type `cmd.exe`, and press Enter. Do **not** use PowerShell or a pre-configured developer shell for this test.

2.  **Run the VS environment script:**
    *   Execute the following command. Use quotes to handle spaces in the path.
      ```cmd
      "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
      ```
    *   You should see a confirmation message like `[vcvarsall.bat] Environment initialized for: 'x64'`.

3.  **Check the `PATH` variable:**
    *   In the *same* command prompt window, run:
      ```cmd
      echo %PATH%
      ```
    *   Carefully inspect the output. You **must** see the path to the Windows Kits `bin` directory. It should look something like this (your version number may differ):
      `C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64`

4.  **Attempt to run `rc.exe` directly:**
    *   In the *same* command prompt, run:
      ```cmd
      rc.exe
      ```
    *   **Expected Outcome:** You should see output from the Microsoft Resource Compiler, such as `Microsoft (R) Windows (R) Resource Compiler Version...`, followed by usage information.
    *   **Failure Outcome:** If you see `'rc.exe' is not recognized...`, then `vcvars64.bat` is failing to set up the environment correctly. The problem lies with the Visual Studio or Windows SDK installation itself.

| Result | Next Action |
| :--- | :--- |
| **Success:** `rc.exe` runs. | The environment script works. The problem occurs when `autoninja` calls the build scripts. **Proceed to Step 2.** |
| **Failure:** `rc.exe` is not recognized. | The core environment setup is broken. **Go to the [Troubleshooting vcvars64.bat](#troubleshooting-vcvars64bat) section below.** |

---

## Step 2: Debug the Subprocess Environment

This is the most critical step. We will modify the Python script that fails (`rc.py`) to write its own environment to a log file. This will show us exactly what `PATH` the script sees when `autoninja` runs it.

1.  **Navigate to the script location:**
    *   `C:\chromium\src\src\build\toolchain\win\rc\`

2.  **Edit `rc.py`:**
    *   Open `rc.py` in a text editor.
    *   Locate the `RunRc` function. It should be around line 190.
    *   Find this line (around line 196):
      ```python
      subprocess.Popen(rc_cmd, stdin=subprocess.PIPE)
      ```
    *   **Add the following code snippet directly above that line:**
      ```python
      # ---- START DEBUG CODE ----
      import os
      debug_log_path = os.path.join(os.environ.get("TEMP", "C:\\temp"), "rc_py_debug.log")
      with open(debug_log_path, "w") as f:
          f.write("--- rc.py Debug Log ---\n")
          f.write(f"Executing command: {' '.join(rc_cmd)}\n\n")
          f.write("Environment PATH:\n")
          path_vars = os.environ.get("PATH", "PATH not found").split(';')
          for path in path_vars:
              f.write(f"{path}\n")
      # ---- END DEBUG CODE ----
      ```

3.  **Run the build again to trigger the error:**
    *   Open a new command prompt and run your original build command:
      ```cmd
      cmd /c '"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" && autoninja -C out/Default chrome'
      ```

4.  **Analyze the debug log:**
    *   The build will fail as before. Now, open the log file created at `C:\temp\rc_py_debug.log` (or in your user's `%TEMP%` directory).
    *   Examine the `Environment PATH` section.
    *   **Crucial Question:** Does the path to `rc.exe` (`C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64`) appear in this log file?

| Result | Analysis & Next Action |
| :--- | :--- |
| **Path is MISSING:** | This is the most likely scenario. It confirms the environment variables set by `vcvars64.bat` are being lost or stripped before `rc.py` is executed. **Proceed to Step 3.** |
| **Path is PRESENT:** | This is highly unlikely, but if it happens, it points to a more complex issue (e.g., file system permissions, antivirus interference, or a bug in Python's `subprocess` module on your system). **Double-check the path for typos or subtle errors.** |

---

## Step 3: Resolve the Environment Loss

Based on the findings from Step 2, here are the most likely solutions.

### Solution A: Use `gn` to Set the SDK Path Explicitly

The most robust solution is to stop relying on inherited environment variables and tell `gn` exactly where the Windows SDK is.

1.  **Clean your output directory:**
    *   Delete the `C:\chromium\src\src\out\Default` directory to ensure a clean configuration.

2.  **Find the exact SDK path:**
    *   Note the path to your Windows SDK installation root, which should be `C:\Program Files (x86)\Windows Kits\10`.

3.  **Re-run `gn gen` with the `win_sdk_path` argument:**
    ```powershell
    gn gen out/Default --args="is_debug=false is_component_build=false win_sdk_path=\"C:\Program Files (x86)\Windows Kits\10\""
    ```
    *   **Note:** The trailing slash is important. The quotes are necessary to handle the spaces.

4.  **Attempt the build again:**
    ```powershell
    autoninja -C out/Default chrome
    ```
    *   This method is generally more reliable as it hardcodes the SDK path into the build configuration, bypassing the fragile environment variable inheritance.

### Solution B: The `depot_tools` Environment Wrapper

`depot_tools` includes a Python script that can set the environment and then execute a command, which can be more stable.

1.  **Open a regular command prompt (no `vcvars64.bat`).**
2.  **Run the build using `python.bat`:**
    ```cmd
    C:\path\to\depot_tools\python.bat C:\path\to\depot_tools\win_toolchain\vs_build_runtime_helpers.py -- "C:\Program Files\Microsoft Visual Studio\2022\Community" autoninja -C C:\chromium\src\src\out\Default chrome
    ```
    *   This is a more complex command but directly manages the toolchain environment.

---

## Appendix: Troubleshooting `vcvars64.bat`

If you failed at Step 1, your Visual Studio/SDK installation is the problem.

1.  **Repair Visual Studio:**
    *   Open the "Visual Studio Installer".
    *   Find your VS 2022 installation and click "Modify".
    *   Ensure the "Desktop development with C++" workload is checked.
    *   On the "Individual components" tab, find the exact Windows SDK version listed in your status report (`10.0.26100.4188`) and make sure it is checked. If multiple SDKs are installed, this can sometimes cause conflicts.
    *   Proceed with the modification/repair.

2.  **Check for `reg.exe`:**
    *   In a command prompt, type `where reg`. Ensure it's found in `C:\Windows\System32`. Some corporate security policies can restrict access to the registry editor, which would break `vcvars64.bat`.

After trying these fixes, **return to Step 1** to verify the environment.

---

## Quick Reference Commands

### Clean Build Process
```cmd
# Clean output directory
rmdir /s /q C:\chromium\src\src\out\Default

# Generate build files with explicit SDK path
gn gen out/Default --args="is_debug=false is_component_build=false win_sdk_path=\"C:\Program Files (x86)\Windows Kits\10\""

# Build Chrome
autoninja -C out/Default chrome
```

### Alternative Build Method
```cmd
# Using depot_tools environment wrapper
C:\path\to\depot_tools\python.bat C:\path\to\depot_tools\win_toolchain\vs_build_runtime_helpers.py -- "C:\Program Files\Microsoft Visual Studio\2022\Community" autoninja -C C:\chromium\src\src\out\Default chrome
```

### Debug Environment
```cmd
# Check if rc.exe is accessible
"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
rc.exe
```
