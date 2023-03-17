
import os
import json
import sqlalchemy as sq
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

DATA_JSON_FILE = "tests_data.json"

Base = declarative_base()


class Publisher(Base):
    """
    Класс для работы с Издателем
    """
    __tablename__ = "publisher"

    id = sq.Column(sq.Integer, primary_key=True)
    name = sq.Column(sq.String(length=40), nullable=False, unique=True)


class Book(Base):
    """
    Класс для работы с книгой
    """
    __tablename__ = "book"

    id = sq.Column(sq.Integer, primary_key=True)
    title = sq.Column(sq.String(length=40), nullable=False)
    id_publisher = sq.Column(sq.Integer, sq.ForeignKey("publisher.id"), nullable=False)

    publisher = relationship(Publisher, back_populates="book")
#    publisher = relationship(Publisher, backref="book")

Publisher.book = relationship(Book, back_populates="publisher")

class Shop(Base):
    """
    Класс для работы с магазином
    """
    __tablename__ = "shop"

    id = sq.Column(sq.Integer, primary_key=True)
    name = sq.Column(sq.String(length=40), nullable=False)


class Stock(Base):
    """
    Класс для работы с наличием книги в магазине
    """
    __tablename__ = "stock"

    id = sq.Column(sq.Integer, primary_key=True)
    count = sq.Column(sq.Integer, nullable=False)
    id_shop = sq.Column(sq.Integer, sq.ForeignKey("shop.id"), nullable=False)
    id_book = sq.Column(sq.Integer, sq.ForeignKey("book.id"), nullable=False)

    shop = relationship(Shop, back_populates="stock")
    book = relationship(Book, back_populates="stock")

Book.stock = relationship(Stock, back_populates="book")
Shop.stock = relationship(Stock, back_populates="shop")


class Sale(Base):
    """
    Класс для работы с фактом продажи
    """
    __tablename__ = "sale"

    id = sq.Column(sq.Integer, primary_key=True)
    price = sq.Column(sq.Float, nullable=False)
    count = sq.Column(sq.Integer, nullable=False)
    date_sale = sq.Column(sq.Date, nullable=False)
    id_stock = sq.Column(sq.Integer, sq.ForeignKey("stock.id"), nullable=False)

    stock = relationship(Stock, back_populates="sale")

Stock.sale = relationship(Sale, back_populates="stock")


def create_tables(engine):
    """
    Пересооздаёт все таблицы в БД
    :param engine:
    :return:
    """
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)


def get_dsn():
    """
    Получает параметры подлключения к БД из переменных среды
    :return:
    Строку с DSN
    """
    if {"PSTGRS_USER", "PSTGRS_PASSWD", "PSTGRS_DB"} <= os.environ.keys():
        return f'postgresql://{os.environ["PSTGRS_USER"]}:{os.environ["PSTGRS_PASSWD"]}' + \
                f'@localhost:5432/{os.environ["PSTGRS_DB"]}'
    else:
        return None


def fill_dicts():
    """
    Функия загрузки тестовых данных из JSON в словари
    :return:
    Возвращает 5 списков словарей: publishers, books, shops, stocks, sales
    """
    try:
        with open(DATA_JSON_FILE, "r", encoding="utf-8") as f:
            json_list = json.load(f)
    except:
        print(f"Ошибка при чтении файла с данными: {DATA_JSON_FILE}")
        return None, None, None, None, None

    pub_dict, books_dict, shops_dict, stocks_dict, sales_dict = [], [], [], [], []
    for m in json_list:
        if m["model"] == "publisher":
            pub_dict.append({"id": m["pk"], "name": m["fields"]["name"]})
        elif m["model"] == "book":
            books_dict.append({"id": m["pk"], "title": m["fields"]["title"],
                          "id_publisher": m["fields"]["id_publisher"]})
        elif m["model"] == "shop":
            shops_dict.append({"id": m["pk"], "name": m["fields"]["name"]})
        elif m["model"] == "stock":
            stocks_dict.append({"id": m["pk"], "id_shop": m["fields"]["id_shop"],
                           "id_book": m["fields"]["id_book"], "count": m["fields"]["count"]})
        elif m["model"] == "sale":
            sales_dict.append({"id": m["pk"], "id_stock": m["fields"]["id_stock"],
                           "price": m["fields"]["price"], "date_sale": m["fields"]["date_sale"],
                           "count": m["fields"]["count"]})

    return pub_dict, books_dict, shops_dict, stocks_dict, sales_dict


def get_shops_by_pub(session, pub):
    """
    Возвращает множество названий магазинов продающих определённого издателя
    :param pub: Имя издателя
    :return: Множество названий магазинов
    """
    q = session.query(
        Publisher, Book, Stock, Shop
    ).filter(
        Publisher.id == Book.id_publisher
    ).filter(
        Book.id == Stock.id_book
    ).filter(
        Shop.id == Stock.id_shop
    ).filter(
        Publisher.name == pub
    )

    result = set()
    for s in q.all(): result = result.union({s.Shop.name})
    return result


def main():
    DSN = get_dsn()
    if not DSN:
        print("""
Необходимо задать параметры подключения к БД через переменные среды:
    PSTGRS_DB     - Имя базы данных
    PSTGRS_USER   - Имя пользователя
    PSTGRS_PASSWD - Пароль пользователя
""")
        return

    engine = sq.create_engine(DSN)
    create_tables(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    pub_dict, books_dict, shops_dict, stocks_dict, sales_dict = fill_dicts()
    if not pub_dict: return

    list_to_add = []

    for p in pub_dict: list_to_add.append(Publisher(**p))
    for b in books_dict: list_to_add.append(Book(**b))
    for sh in shops_dict: list_to_add.append(Shop(**sh))
    for st in stocks_dict: list_to_add.append(Stock(**st))
    for s in sales_dict: list_to_add.append(Sale(**s))

    session.add_all(list_to_add)
    session.commit()

    for pub in pub_dict:
        print(f'Издателя "{pub["name"]}" продают магазины: {get_shops_by_pub(session, pub["name"])}')

if __name__ == "__main__":
    main()