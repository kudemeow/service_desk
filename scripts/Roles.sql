-- Создаём функцию, которая возвращает ID текущего пользователя
-- Она читает значение из сессионной переменной myapp.user_id,
-- которую приложение должно устанавливать перед каждым запросом
CREATE OR REPLACE FUNCTION current_user_id() RETURNS INTEGER AS $$
BEGIN
    RETURN current_setting('myapp.user_id', true)::int;
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql STABLE;

-- Создание ролей
CREATE ROLE requester;
CREATE ROLE developer;
CREATE ROLE manager;
CREATE ROLE admin;

-- Права для заявителя
GRANT INSERT, SELECT, UPDATE ON Tickets TO requester;
GRANT INSERT, SELECT ON Comments TO requester;

-- Права для разработчика
GRANT SELECT, UPDATE ON Tickets TO developer;
GRANT INSERT, SELECT ON Comments TO developer;
GRANT SELECT ON Users, Services, Statuses, Priorities TO developer;

-- Права для руководителя
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO manager;

-- Ограничение: заявитель видит только свои заявки (через политики RLS)
ALTER TABLE Tickets ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_tickets ON Tickets FOR SELECT TO requester
    USING (user_id = current_user_id());
