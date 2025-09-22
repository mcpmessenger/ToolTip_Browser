# Chromium Download Commands - Step by Step

## Current Status
✅ Environment setup complete
✅ Depot tools installed
✅ Git configured
✅ Ready to download Chromium source

## Step 1: Initial Chromium Fetch
**Command to run:**
```powershell
fetch --nohooks chromium
```

**What this does:**
- Downloads the main Chromium source code (~15GB)
- Creates the initial repository structure
- Sets up the main branch
- **Time:** 1-2 hours depending on internet speed

**Note:** The `--nohooks` flag skips running build hooks initially to speed up the download.

## Step 2: Install Dependencies
**Command to run:**
```powershell
gclient sync
```

**What this does:**
- Downloads additional dependencies and submodules
- Updates the source to the latest version
- **Time:** 30-60 minutes

## Step 3: Run Build Hooks
**Command to run:**
```powershell
gclient runhooks
```

**What this does:**
- Runs necessary build configuration scripts
- Sets up platform-specific tools
- **Time:** 10-20 minutes

## Step 4: Verify Download
**Command to run:**
```powershell
ls
```

**Expected output:**
You should see directories like:
- `chrome/`
- `content/`
- `ui/`
- `build/`
- `third_party/`
- And many more...

## Step 5: Check Chromium Version
**Command to run:**
```powershell
git log --oneline -1
```

**Expected output:**
Something like: `[chromium-dev] Update VERSION to 131.0.6778.0`

## Troubleshooting

### If fetch fails:
1. Check internet connection
2. Try again: `fetch --nohooks chromium`
3. If still failing, try: `fetch chromium` (without --nohooks)

### If gclient sync fails:
1. Wait a few minutes and try again
2. Check if antivirus is blocking the download
3. Ensure you have enough disk space (100GB+)

### If you need to start over:
```powershell
cd C:\chromium
rmdir /s src
mkdir src
cd src
```

## Next Steps After Download
Once the download is complete, we'll:
1. Set up the build environment
2. Create our custom fork branch
3. Start implementing the tooltip functionality
4. Add AI integration

## Current Directory
You're currently in: `C:\chromium\src`
This is the correct location to run the fetch command.

---

**Ready to proceed? Run the first command when you're ready!**
