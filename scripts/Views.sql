CREATE VIEW my_tickets AS
SELECT t.id, t.title, t.description, t.created_at, 
       s.name AS status_name, p.name AS priority_name, sv.name AS service_name
FROM Tickets t
JOIN Statuses s ON t.status_id = s.id
JOIN Priorities p ON t.priority_id = p.id
JOIN Services sv ON t.service_id = sv.id
WHERE t.user_id = current_user_id();

CREATE VIEW developer_load AS
SELECT u.fio AS developer_name, COUNT(a.ticket_id) AS active_tickets
FROM Developers d
JOIN Users u ON d.user_id = u.id
LEFT JOIN Assignments a ON d.id = a.developer_id
LEFT JOIN Tickets t ON a.ticket_id = t.id AND t.status_id NOT IN (4, 5) -- не выполнена и не отклонена
GROUP BY d.id, u.fio
ORDER BY active_tickets DESC;

CREATE VIEW deadline_report AS
SELECT t.id, t.title, u.fio AS requester, t.deadline,
       CASE 
           WHEN t.deadline < CURRENT_DATE AND t.status_id NOT IN (4, 5) THEN 'Просрочена'
           WHEN t.deadline >= CURRENT_DATE AND t.status_id = 4 THEN 'Выполнена в срок'
           ELSE 'В работе'
       END AS status_message
FROM Tickets t
JOIN Users u ON t.user_id = u.id;