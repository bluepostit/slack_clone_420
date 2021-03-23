import consumer from "./consumer";

const initNotificationCable = () => {
  const messagesContainer = document.getElementById('messages');
  // We are NOT on the messages page, so show notifications
  if (!messagesContainer) {
    const messagesNav = document.getElementById('nav-messages');
    const userId = messagesNav.dataset.userId;

    consumer.subscriptions.create({ channel: "NotificationChannel", id: userId }, {
      received(data) {
        console.log(data)
        const notificationDot = messagesNav.querySelector('.notification-new-message');
        notificationDot.style.display = 'block';
      },
    });
  }
}

export { initNotificationCable };
