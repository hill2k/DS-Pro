# создаем поле 3x3
board = [[" "] * 3 for i in range(0, 3)]


# вводим функцию вывода на экран
def display():
    print('  | 0 | 1 | 2 |')  # верхняя строка
    print('...............')
    for i in range(3):  # вывод строк значений
        print(f'{i} | {board[i][0]} | {board[i][1]} | {board[i][2]} |')
        print('...............')


def coord():  # вводим координаты хода
    while True:
        x, y = map(int, input('Введите координаты хода ').split())

        if 0 <= x <= 2 and 0 <= y <= 2:  # проверка координат
            if board[x][y] == " ":
                return x, y
            else:
                print('Клетка занята')
        else:
            print('Точка за пределами диапазона')


stp = 0  # Игра идет пока не выполнится 9 ходов
while True:
    stp += 1
    display()
    if stp % 2 == 1:  # крестик ходит первым - его ходы нечетные, у нолика четные
        print('Ход крестика')
    else:
        print('Ход нолика')

    x, y = coord()  # забираем координаты хода

    if stp % 2 == 1:
        board[x][y] = "X"
    else:
        board[x][y] = "0"
    if stp == 9:
        break
        print('Конец игры')
