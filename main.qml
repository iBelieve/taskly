import QtQuick 2.0
import Material 0.1

import "udata"
import "ui"

ApplicationWindow {
	title: "Taskly"

	theme {
		primaryColor: Palette.colors.red["500"]
		accentColor: Palette.colors.blue["500"]

		//backgroundColor: "white"
	}

	initialPage: TasksPage {}

	Database {
        id: database

        version: 1
        name: "taskly"
        description: "Taskly for Papyros"
        modelPath: Qt.resolvedUrl("model")
    }
}