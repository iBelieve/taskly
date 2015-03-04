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

import "../components"
import "../model"
import "../udata"

Item {
	id: tasksView

    property bool upcomingOnly
    property bool showCompletedTasks
    property bool showAllProjects

    property Project project

    property string searchQuery

    property bool noTasksYet: allTasks.count == 0

    property bool active: true

    TasksListView {
        id: listView

        anchors.fill: parent
        model: tasks
    }

    Column {
        anchors.centerIn: parent
        visible: tasks.count == 0
        spacing: units.dp(8)

        Icon {
            name: searchQuery ? "action/search"
                              : showCompletedTasks ? "action/done_all"
                                                   : noTasksYet ? "content/add"
                                                                : upcomingOnly ? "action/alarm" 
                                                                			   : "action/done_all"
            size: units.dp(64)
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Item {
        //     width: parent.width
        //     height: units.dp(16)
        // }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            style: "title"
            //opacity: 0.5

            text: searchQuery ? "No matching tasks"
                              : showCompletedTasks ? "Nothing completed"
                                                   : noTasksYet ? project ? "No tasks yet" 
                                                   						  : "Welcome to Taskly!"
                                                                : "Great job!"
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            style: "subheading"
            color: Theme.light.subTextColor
            width: tasksView.width - units.dp(32)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            text: searchQuery ? "No tasks match your search query"
                              : showCompletedTasks ? "You haven't finished any tasks yet"
                                                   : noTasksYet ? "Tap the blue add button to create your first task"
                                                                : "No upcoming tasks"

        }
    }

    Scrollbar {
        flickableItem: listView
    }

    QueryCount {
        id: allTasks
        _db: database
        enabled: tasksView.active
        type: 'Task'
        predicate: {
            var predicate = []

            if (!showAllProjects)
                predicate.push("projectId == '%1'".arg(project ? project._id : ''))

            print(predicate.join(" AND "))

            return predicate.join(" AND ")
        }
    }

    Query {
        id: tasks
        type: "Task"
        groupBy: "section"
        predicate: {
            var predicate = []

            if (upcomingOnly) {
                predicate.push("dueDate != ''")
            }

            if (!showAllProjects)
                predicate.push("projectId == '%1'".arg(project ? project._id : ''))

            if (searchQuery) {
                var query = searchQuery
                query = query.replace('_', '\\_').replace('%', '\\%')
                predicate.push("(UPPER(title) LIKE UPPER('%%1%') ESCAPE '\\')".arg(query))
            } else {
                predicate.push('(completed == %1)'.arg(showCompletedTasks ? '1' : '0'))
            }

            print(predicate.join(" AND "))

            return predicate.join(" AND ")
        }
        sortBy: "completed,dueDate,priority,title"
        _db: database
    }

    function formatText(text) {
        var regex = /(\d\d?:\d\d\s*(PM|AM|pm|am))/gi
        text = text.replace(regex, "<font color=\"%1\">$1</font>".arg(Palette.colors.green["500"]))
        if (text.indexOf("!") !== -1)
            text = colorize(/*"<b>%1</b>".arg(*/text/*)*/, Palette.colors.red["500"])

        return text
    }
}
