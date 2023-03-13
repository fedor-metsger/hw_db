
import psycopg2

DB_CONNECTION_FILENAME = "db_connection.txt"

def read_connection_data():
    db_name = user_name = user_password = None
    try:
        with open(DB_CONNECTION_FILENAME, "r", encoding="utf-8") as cf:
            db_name, user_name, user_password = cf.readline().split()
    except:
        print(f"Ошибка при чтении файла с параметрами БД: {DB_CONNECTION_FILENAME}")
    return db_name, user_name, user_password

#                 email VARCHAR(40) NOT NULL CHECK (email ~ '^[0-9a-z\._]+@[0-9a-z\._]+$'),
def create_db(conn):
    with conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS client (
                client_id SERIAL PRIMARY KEY,
                client_name VARCHAR(40) NOT NULL,
                email VARCHAR(40) NOT NULL CHECK (email ~ '^[0-9a-z\._]+@[0-9a-z\._]+$'),
                lastname VARCHAR(40) NOT NULL
            );        
        """)
        cur.execute("""
            CREATE TABLE IF NOT EXISTS phone (
                client_id SERIAL REFERENCES client(client_id),
                phone_number VARCHAR(40) NOT NULL CHECK (phone_number ~ '^[0-9]+$')
            );        
        """)
    conn.commit()


def add_client(conn, first_name, last_name, email, phones=None):
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO client (client_name, lastname, email) VALUES (%s, %s, %s) RETURNING client_id
        """, (first_name, last_name, email.lower()))
        client_id = cur.fetchone()[0]
        if phones:
            for num in phones:
                # cur.execute("""
                #     INSERT INTO phone (client_id, phone_number) VALUES (%s, %s)
                # """, (client_id, num))
                add_phone(conn, client_id, num)
#    conn.commit()
    return client_id

def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        if phone and client_id:
            cur.execute("""
                INSERT INTO phone (client_id, phone_number) VALUES (%s, %s)
            """, (client_id, phone))

def change_last_name(conn, client_id, last_name):
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE client SET lastname = %s WHERE client_id = %s
        """, (last_name, client_id))

def change_first_name(conn, client_id, first_name):
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE client SET client_name = %s WHERE client_id = %s
        """, (first_name, client_id))

def change_email(conn, client_id, email):
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE client SET email = %s WHERE client_id = %s
        """, (email, client_id))

def change_phones(conn, client_id, phones):
    with conn.cursor() as cur:
        if client_id:
            cur.execute("""
                DELETE FROM phone WHERE client_id = %s
            """, (client_id,))
    if phones:
        for num in phones:
            # cur.execute("""
            #     INSERT INTO phone (client_id, phone_number) VALUES (%s, %s)
            # """, (client_id, num))
            add_phone(conn, client_id, num)

def change_client(conn, client_id, first_name=None, last_name=None, email=None, phones=None):
    if not client_id:
        return
    if first_name:
        change_first_name(conn, client_id, first_name)
    if last_name:
        change_last_name(conn, client_id, last_name)
    if email:
        change_email(conn, client_id, email)
    if phones:
        change_phones(conn, client_id, phones)

def delete_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        if phone and client_id:
            cur.execute("""
                DELETE FROM phone WHERE client_id = %s AND phone_number = %s
            """, (client_id, phone))
def delete_client(conn, client_id):
    with conn.cursor() as cur:
        if client_id:
            cur.execute("""
                DELETE FROM phone WHERE client_id = %s
            """, (client_id,))

            cur.execute("""
                DELETE FROM client WHERE client_id = %s
            """, (client_id,))

def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    pass


def main():
    db_name, user_name, user_password = read_connection_data()

    if not user_password:
        return

    with psycopg2.connect(database=db_name, user=user_name, password=user_password) as conn:
        create_db(conn)
        semenov_id = add_client(conn, "Семён", "Семёнов", "semen.semenov@email.com", ["79998888888"])
        ivanov_id = add_client(conn, "Иван", "Иванов", "ivan.ivanov@email.com", ["79991234567"])
        petrov_id = add_client(conn, "Пётр", "Петров", "petr.petrov@email.com", ["79872349870"])
        mironov_id = add_client(conn, "Мирон", "Миронов", "miron.mironov@email.com")
        stepanov_id = add_client(conn, "Степан", "Степанов", "stepan.stepanov@email.com",
            ["79120987654", "79234567890", "79341236789"])
        conn.commit()
        try:
            add_client(conn, "Error", "Error", "Error")
        except psycopg2.errors.CheckViolation as cv:
            print(cv)
            conn.rollback()
        try:
            add_client(conn, "Error", "Error", "error@error", "error")
        except psycopg2.errors.CheckViolation as cv:
            print(cv)
            conn.rollback()

        delete_phone(conn, semenov_id, "79998888888")
        conn.commit()

        delete_client(conn, ivanov_id)
        conn.commit()

        change_client(conn, petrov_id, first_name="Николай")
        change_client(conn, mironov_id, last_name="Николаев")
        change_client(conn, stepanov_id, email="updated@email.com")
        change_client(conn, petrov_id, phones = ["79572347889", "72345678901"])
        conn.commit()
    conn.close()

if __name__ == "__main__":
    main()