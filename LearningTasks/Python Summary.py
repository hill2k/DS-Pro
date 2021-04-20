# создаем поле
board = list(range(1, 10))
# записываем в глобальную переменную выигрышные комбинации
win = [(1, 2, 3), (4, 5, 6), (7, 8, 9), (1, 4, 7), (2, 5, 8), (3, 6, 9), (1, 3, 9), (3, 5, 7)]


# определяем функцию вывода игрового поля
def display():
    print('......................')  # каждая ячейка будет пронумерована от 1 до 9
    for i in range(3):
        print(' | ', board[0 + i * 3], ' | ', board[1 + i * 3], ' | ', board[2 + i * 3], ' | ')
        print('......................')


# функция запроса на ввод координаты ячейки с проверкой на ошибки
def coord(p_token):
    while True:
        value = input('Введите координаты ячейки ')
        if not (value in '123456789'):
            print('Ошибка! Введите номер ячейки повторно ')
            continue
        value = int(value)
        if str(board[value - 1]) in "XO":
            print('Эта клетка занята! Повторите ввод.')
            continue
        board[value - 1] = p_token
        break


# определяем функцию выявления выигрышной комбинации
def check_win():
    for each in win:
        if (board[each[0] - 1]) == (board[each[1] - 1]) == (board[each[2] - 1]):
            return board[each[1] - 1]
        else:
            return False


# тело программы
cnt = 0
while True:
    display()
    cnt += 1
    if cnt % 2 == 0:  # решаем, что крестики ходят по нечетным ходам, а крестики по четным
        print('Ходит нолик')
        coord('0')
    else:
        print('Ходит крестик')
        coord('X')
    if cnt > 5:  # как только сыграно пять ходов - проверяем на выигрышную комбинацию
        winner = check_win()
        if winner:
            display()
            print(winner, 'Победитель!')  # объявляем победителя
            break
    if cnt == 9:  # если нет выигрышной комбинации за 9 ходов - ничья
        print('Ничья!')
        break
