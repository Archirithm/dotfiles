pragma Singleton

import Quickshell
import QtQuick

Singleton {
<* for name, value in colors *>
    readonly property color {{name}} : "{{value.default.hex}}"
<* endfor *>
}
