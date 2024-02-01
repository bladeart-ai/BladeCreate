import { app, shell, BrowserWindow } from 'electron'
import { join } from 'path'
import child_process from 'child_process'
import fs from 'fs'
import { electronApp, is } from '@electron-toolkit/utils'

const MODE = import.meta.env.MODE
const PY_DIST_PATH = import.meta.env.MAIN_VITE_PY_DIST_PATH || 'bladecreate_app/bladecreate_app'

let pyProc: child_process.ChildProcess | null = null

const createPyProc = () => {
  let pyDistPath: string | null = null

  // Looking for Python distribution
  let possibilities: string[] = []
  if (process.platform === 'win32') {
    possibilities = [
      join(__dirname, '../../../dist', PY_DIST_PATH, '.exe'),
      join(process.resourcesPath, PY_DIST_PATH, '.exe')
    ]
  } else {
    possibilities = [
      join(__dirname, '../../../dist', PY_DIST_PATH), // when Python dist is generated
      join(process.resourcesPath, PY_DIST_PATH) // when in packaged app ?
    ]
  }

  console.log('Looking for py dist paths:', possibilities)
  for (const path of possibilities) {
    if (fs.existsSync(path)) {
      console.log('Used path:', path)
      pyDistPath = path
    }
  }

  const port = '8080'
  // TODO: check if port is used

  if (pyDistPath) {
    console.log('Found Python distribution in', pyDistPath)
    pyProc = child_process.spawn(pyDistPath, [], {
      env: { BC_SERVER__PORT: port },
      stdio: 'inherit'
    })
  } else if (MODE !== 'production') {
    console.log('Cannot find Python distribution; calling Python directly')
    pyProc = child_process.spawn('python', ['-m', 'bladecreate.app'], {
      env: { BC_SERVER__PORT: port },
      stdio: 'inherit'
    })
  }

  if (pyProc != null) {
    console.log('child process success on port ' + port)
  }
}

const exitPyProc = () => {
  if (pyProc) pyProc.kill()
}

function createWindow(): void {
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    width: 900,
    height: 670,
    show: false,
    autoHideMenuBar: true,
    // ...(process.platform === 'linux' ? { icon } : {}),
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false
    }
  })

  mainWindow.on('ready-to-show', () => {
    mainWindow.show()
  })

  mainWindow.webContents.setWindowOpenHandler((details) => {
    shell.openExternal(details.url)
    return { action: 'deny' }
  })

  // HMR for renderer base on electron-vite cli.
  // Load the remote URL for development or the local html file for production.
  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  // Set app user model id for windows
  electronApp.setAppUserModelId('com.electron')

  // Default open or close DevTools by F12 in development
  // and ignore CommandOrControl + R in production.
  // see https://github.com/alex8088/electron-toolkit/tree/master/packages/utils
  // app.on('browser-window-created', (_, window) => {
  //   optimizer.watchWindowShortcuts(window)
  // })

  createPyProc()

  createWindow()

  app.on('activate', function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
    exitPyProc()
  }
})

// In this file you can include the rest of your app"s specific main process
// code. You can also put them in separate files and require them here.
