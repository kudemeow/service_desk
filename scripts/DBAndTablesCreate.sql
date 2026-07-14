CREATE DATABASE service_desk TEMPLATE template0;

-- Таблица Users
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    fio VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) DEFAULT 'requester',
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Services
CREATE TABLE Services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    owner_id INTEGER REFERENCES Users(id)
);

-- Таблица Statuses
CREATE TABLE Statuses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_closed BOOLEAN DEFAULT FALSE
);

-- Таблица Priorities
CREATE TABLE Priorities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    level INTEGER CHECK (level BETWEEN 1 AND 4)
);

-- Таблица Tickets
CREATE TABLE Tickets (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP,
    user_id INTEGER REFERENCES Users(id),
    service_id INTEGER REFERENCES Services(id),
    status_id INTEGER REFERENCES Statuses(id) DEFAULT 1,
    priority_id INTEGER REFERENCES Priorities(id) DEFAULT 1
);

-- Таблица Developers
CREATE TABLE Developers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES Users(id),
    position VARCHAR(100),
    skill_level VARCHAR(50),
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Таблица Assignments
CREATE TABLE Assignments (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES Tickets(id) ON DELETE CASCADE,
    developer_id INTEGER REFERENCES Developers(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Таблица Comments
CREATE TABLE Comments (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES Tickets(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES Users(id),
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Attachments
CREATE TABLE Attachments (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES Tickets(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);