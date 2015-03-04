/*
 * Taskly - A simple tasks app for Material Design
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem

ListView {
    id: listView
    clip: true

    move: Transition {
        NumberAnimation { properties: "x,y"; duration: 500 }
    }

    moveDisplaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 500 }
    }

    section.property: "section"
    section.delegate: ListItem.Header {
        text: section
    }

    delegate: ListItem.Subtitled {
        id: listItem

        //checked: modelData.completed
        text: formatText(modelData.title)
        subText: modelData.dueDateString

        // onCheckedChanged: {
        //     modelData.completed = checked
        //     if (modelData)
        //         checked = Qt.binding(function() { return modelData.completed })
        // }

        onClicked: {
            pageStack.push(Qt.resolvedUrl("../ui/TaskDetailsPage.qml"), {task: modelData, project: project})
        }
    }
}
