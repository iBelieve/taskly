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

import "../components"

Page {
	title: "Taskly"

	actions: [
		Action {
			name: "Settings"
			iconName: "action/assessment"
		},

		Action {
			name: "Archived Projects"
			iconName: "content/archive"
		},

		Action {
			name: "Settings"
			iconName: "action/settings"
		}
	]

	TasklySidebar {
		id: sidebar

		onAddProject: newProjectDialog.show()
	}

	ActionButton {
		iconName: "content/add"

		anchors {
			right: parent.right
			bottom: parent.bottom
			margins: units.dp(16)
		}
	}

	Dialog {
		id: newProjectDialog

		text: "Enter project name:"

		TextField {
			id: textField
			width: parent.width

			placeholderText: "Project name"
		}

		positiveButtonText: "Create"

		onOpened: {
			textField.text = ""
			textField.forceActiveFocus()
		}

		onAccepted: {
			database.newObject("Project", { title: textField.text })
		}
	}
}