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

import "../model"

ListItem.Standard {
	text: project.title

	property Project project

	action: Item {
		width: units.dp(28)
		height: width

		anchors {
			left: parent.left
			verticalCenter: parent.verticalCenter
		}

		Rectangle {
			anchors.centerIn: parent
			color: project.color
			radius: width/2
			width: units.dp(15)
			height: width
		}
	}
}