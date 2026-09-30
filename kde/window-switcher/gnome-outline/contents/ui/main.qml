/* SPDX-License-Identifier: MIT */

import QtQuick
import QtQuick.Window
import org.kde.kwin as KWin

KWin.TabBoxSwitcher {
    id: tabBox

    property string selectedWindowId: ""

    currentIndex: candidateList.currentIndex

    function updateSelectedWindow() {
        const item = candidateList.currentItem;
        selectedWindowId = item ? String(item.candidateWindowId) : "";
    }

    ListView {
        id: candidateList

        // KWin's switcher model still handles ordering and keyboard navigation,
        // but no list or popup is drawn.
        visible: false
        width: 1
        height: 1
        model: tabBox.model

        delegate: Item {
            required property var windowId
            readonly property var candidateWindowId: windowId
            width: 1
            height: 1
        }

        onCurrentItemChanged: tabBox.updateSelectedWindow()

        Connections {
            target: tabBox

            function onCurrentIndexChanged() {
                candidateList.currentIndex = tabBox.currentIndex;
                tabBox.updateSelectedWindow();
            }
        }
    }

    Instantiator {
        model: KWin.WindowModel {}

        delegate: Window {
            required property var window
            readonly property bool isSelected:
                tabBox.selectedWindowId !== ""
                && String(window.internalId) === tabBox.selectedWindowId

            visible: tabBox.visible && isSelected && !window.minimized
            x: window.x
            y: window.y
            width: window.width
            height: window.height

            color: "transparent"
            flags: Qt.BypassWindowManagerHint
                | Qt.FramelessWindowHint
                | Qt.WindowTransparentForInput

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: 2
                border.color: "#3daee9"
            }
        }
    }
}
