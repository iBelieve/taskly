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
import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem

import "../udata"
import "../model"

Sidebar {
	property string selectedItem: "inbox"

	property Project selectedProject
	property bool showInbox: selectedItem == "inbox"

	onSelectedItemChanged: selectedProject = null

	signal addProject

	Column {
		anchors {
			top: parent.top
			left: parent.left
			right: parent.right

			topMargin: units.dp(8)
		}

		ListItem.Standard {
			iconName: "content/inbox"
			text: "Inbox"
			selected: selectedItem == "inbox"
			onClicked: {
				selectedItem = "inbox"
				selectedProject = null
			}
		}

		ListItem.Standard {
			iconName: "action/today"
			text: "Today"
			selected: selectedItem == "today"
			onClicked: selectedItem = "today"
		}

		ListItem.Standard {
			iconName: "action/view_week"
			text: "Next 7 days"
			selected: selectedItem == "week"
			onClicked: selectedItem = "week"
		}

		ListItem.Header {
			text: "Projects"
		}

		Repeater {
			model: projects
			delegate: ProjectListItem {
				project: modelData

				selected: selectedItem == "projects/" + project._id
				onClicked: {
					selectedItem = "projects/" + project._id
					selectedProject = modelData
				}
			}
		}

		ListItem.Standard {
			iconName: "content/add"
			text: "Add Project"
			textColor: Theme.light.subTextColor
			onClicked: addProject()
		}
	}

	Query {
        id: projects
        type: "Project"
        sortBy: "title"
        _db: database
    }
}