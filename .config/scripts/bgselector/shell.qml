import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: shell
    settings.watchFiles: false
    readonly property string listPath: Quickshell.env("BGSEL_LIST")
    readonly property string applyScript: Quickshell.env("BGSEL_APPLY")
    readonly property string currentPath: Quickshell.env("BGSEL_CURRENT")

    FileView {
        id: listFile
        path: shell.listPath
        blockLoading: true
    }

    function parseList() {
        const out = []
        const lines = listFile.text().split("\n")
        for (let i = 0; i < lines.length; i++) {
            if (lines[i] === "") continue
            const p = lines[i].split("\t")
            if (p.length < 3) continue
            out.push({ name: p[0], thumb: p[1], path: p[2] })
        }
        return out
    }

    Process {
        id: applyProc
        onExited: (exitCode) => {
            picker.finishAndQuit()
        }
    }

    PanelWindow {
        color: "transparent"
        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore

        WlrLayershell.namespace: "bgselector"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Picker {
            id: picker
            anchors.fill: parent
            focus: true
            entries: shell.parseList()
            startPath: shell.currentPath

            onPicked: (path) => {
                picker.busy = true
                applyProc.command = ["bash", shell.applyScript, path]
                applyProc.running = true
            }
            onDismissed: Qt.quit()
        }
    }
}
