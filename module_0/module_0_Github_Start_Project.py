import numpy as np

def score_game(game_core):
    '''Запускаем игру 1000 раз, чтобы узнать, как быстро игра угадывает число'''
    count_ls = []
    np.random.seed(1)  # фиксируем RANDOM SEED, чтобы ваш эксперимент был воспроизводим!
    random_array = np.random.randint(1, 101, size=(1000))
    for number in random_array:
        count_ls.append(game_core(number))
    score = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за {score} попыток")
    return (score)

def game_core_v3(number):
    '''Улучшаем алгоритм. Улучшение основано на сужении границ поиска'''
    c = 1  # вводим счетчик попыток
    upper_border = 100 # стартовая верхняя граница поиска
    lower_border = 1   # стартовая нижняя граница поиска
    predict = 1
    while predict != number: #цикл выполняется пока не будет найдено загаданное число
        c += 1 # увеличиваем счетчик на 1 каждую итерацию
        predict = (lower_border + upper_border) // 2 # предполагаемое число выбирается как середина диапазона
        if number > predict: # если число больше предполагаемого - изменяем нижнюю границу
            lower_border = predict + 1
        else: # если число меньше предполагаемого - изменяем верхнюю границу
            upper_border = predict - 1
    return c


print(score_game(game_core_v3)) # прогоняем нашу оптимизированную функцию через массив из 1000 чисел
## Вывод:
# Ваш алгоритм угадывает число в среднем за 6 попыток