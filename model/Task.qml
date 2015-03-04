/*
 * Taskly - A simple tasks app for Ubuntu Touch
 *
 * Copyright (C) 2014 Michael Spencer
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

import "../udata"
import "../qml-extras/dateutils.js" as DateUtils

Document {
    id: task
    _type: "Task"

    _properties: [
        "title",
        "description",
        "completed",
        "dueDate",
        "repeats",
        "projectId",
        "priority"
    ]

    property string title
    property string description
    property bool completed: false
    property date dueDate
    property string repeats: "never" // or "daily", "weekly", "monthly"
    property string projectId
    property int priority

    onLoaded: {
        priority = title.indexOf("!") != -1 ? 0 : 1
    }

    // High priority if the title ends with "!", example: "Do this NOW!"
    onTitleChanged: {
        priority = title.indexOf("!") != -1 ? 0 : 1
    }

    onCompletedChanged: {
        print("Completed changed!", isLoaded, completed, hasDueDate, repeats)
        if (isLoaded && completed && hasDueDate && repeats !== "never") {
            print("Updating new repeating task!")
            var nextDueDate = new Date(dueDate.toISOString())
            var today = new Date()

            do {
                if (repeats == "daily")
                    nextDueDate.setDate(nextDueDate.getDate() + 1)
                else if (repeats == "weekly")
                    nextDueDate.setDate(nextDueDate.getDate() + 7)
                else if (repeats == "monthly")
                    nextDueDate.setMonth(nextDueDate.getMonth() + 1)
            } while (DateUtils.dateIsBefore(nextDueDate, today));

            print(dueDate, nextDueDate)

            var tasks = _db.queryWithPredicate('Task', "dueDate == '%1' AND title == '%2'"
                                               .arg(nextDueDate.toISOString())
                                               .arg(title))
            print("Task:", tasks)
            if (tasks.length == 0) {
                var json = toJSON()
                json.completed = false
                json.dueDate = nextDueDate
                _db.create('Task', json)
            }
        }
    }

    property bool hasDueDate: DateUtils.isValid(dueDate)

    property string dueDateString: {
        if (hasDueDate) {
            var dateString = DateUtils.formattedDate(dueDate)
            return dateString
        } else {
            return ""
        }
    }

    property string section: {
        if (completed)
            return i18n.tr("Completed")
        else if (!hasDueDate)
            return i18n.tr("No Due Date")
        else if (DateUtils.dateIsBefore(dueDate, new Date()))
            return i18n.tr("Overdue")
        else if (DateUtils.isToday(dueDate))
            return i18n.tr("Today")
        else if (DateUtils.isTomorrow(dueDate))
            return i18n.tr("Tomorrow")
        else if (DateUtils.isThisWeek(dueDate))
            return i18n.tr("This Week")
        else
            return i18n.tr("Upcoming")
    }
}