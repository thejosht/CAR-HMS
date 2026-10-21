package application.usecases

import application.dtos.queries.SendHikeReminderRequest

interface SendHikeReminder {
    fun sendHikeReminder(request: SendHikeReminderRequest)
}