/*markdown
## Задание 4.1

База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:
*/

SELECT  a.city,
        COUNT(a.airport_code) ports_num
FROM dst_project.airports a
GROUP BY 1
ORDER BY 2 DESC

/*markdown
## Задание 4.2

#### Вопрос 1. 
Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?
*/

SELECT count(f.status) in_air
FROM dst_project.flights f
WHERE f.status = 'Departed'

/*markdown
#### Вопрос 2. 
Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»).
*/

SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.status = 'Departed'

/*markdown
#### Вопрос 3. 
Места определяют схему салона каждой модели. Сколько мест имеет самолет модели 773 (Boeing 777-300)?
*/

SELECT COUNT(s.seat_no)
FROM dst_project.seats s
WHERE s.aircraft_code = '773'

/*markdown
#### Вопрос 4.
Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?
*/

SELECT COUNT(f.flight_id) flight_num
FROM dst_project.flights f
WHERE (f.scheduled_arrival BETWEEN 'Apr 1 2017' AND 'Sep 1 2017')
    AND f.status IN ('Arrived')

/*markdown
## Задание 4.3
#### Вопрос 1. 
Сколько всего рейсов было отменено по данным базы?
*/

SELECT COUNT(f.flight_id) flight_cancel
FROM dst_project.flights f
WHERE f.status IN ('Cancelled')

/*markdown
#### Вопрос 2. 
Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?
*/

SELECT COUNT(a.model),
       'Boeing' aircraft_type
FROM dst_project.aircrafts a
WHERE a.model LIKE 'Boeing%'
UNION ALL
SELECT COUNT(a.model),
       'Airbus'
FROM dst_project.aircrafts a
WHERE a.model LIKE 'Airbus%'
UNION ALL
SELECT COUNT(a.model),
       'SSJ'
FROM dst_project.aircrafts a
WHERE a.model LIKE 'Sukhoi%'

/*markdown
#### Вопрос 4. 
У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id).
*/

SELECT f.flight_id, (f.actual_arrival - f.scheduled_arrival)
FROM dst_project.flights f
WHERE f.actual_arrival IS NOT NULL
ORDER BY 2 DESC

/*markdown
## Задание 4.4
#### Вопрос 1. 
Когда был запланирован самый первый вылет, сохраненный в базе данных?
*/

SELECT f.scheduled_departure
FROM dst_project.flights f
ORDER BY 1
LIMIT 1

/*markdown
#### Вопрос 2. 
Сколько минут составляет запланированное время полета в самом длительном рейсе?
#### Вопрос 3. 
Между какими аэропортами пролегает самый длительный по времени запланированный рейс?
*/

SELECT fv.departure_airport,
       fv.arrival_airport,
       ((EXTRACT(HOUR FROM fv.scheduled_duration)*60) + 
            (extract(MINUTE FROM fv.scheduled_duration))) mins
FROM dst_project.flights f
LEFT JOIN dst_project.flights_v fv ON f.flight_id = fv.flight_id
WHERE ((extract(HOUR FROM fv.scheduled_duration)*60) + 
            (extract(MINUTE FROM fv.scheduled_duration))) IS NOT NULL
ORDER BY 3 DESC
LIMIT 1

/*markdown
#### Вопрос 4. 
Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).
*/

SELECT avg((extract(HOUR FROM fv.actual_duration)*60) + 
            (extract(MINUTE FROM fv.actual_duration))) avg_dur
FROM dst_project.flights f
LEFT JOIN dst_project.flights_v fv ON f.flight_id = fv.flight_id
WHERE ((extract(HOUR FROM fv.actual_duration)*60) + 
            (extract(MINUTE FROM fv.actual_duration))) IS NOT NULL

/*markdown
## Задание 4.5
#### Вопрос 1. 
Мест какого класса у SU9 больше всего?
*/

SELECT s.fare_conditions,
       COUNT(s.fare_conditions)
FROM dst_project.seats s
WHERE s.aircraft_code = 'SU9'
GROUP BY 1

/*markdown
#### Вопрос 2. 
Какую самую минимальную стоимость составило бронирование за всю историю?
*/

SELECT b.total_amount
FROM dst_project.bookings b
ORDER BY 1
LIMIT 1

/*markdown
#### Вопрос 3. 
Какой номер места был у пассажира с id = 4313 788533?
*/

SELECT bp.seat_no
FROM dst_project.tickets t
LEFT JOIN dst_project.boarding_passes bp ON t.ticket_no = bp.ticket_no
WHERE t.passenger_id = '4313 788533'

/*markdown
## 5. Предварительный анализ
 Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?
*/

SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.arrival_airport = 'AAQ'
  AND f.status NOT IN ('Cancelled',
                       'Scheduled')
  AND EXTRACT(YEAR FROM 
      f.actual_arrival) = 2017

/*markdown
## Задание 5.1
#### Вопрос 1. 
Сколько рейсов из Анапы вылетело зимой 2017 года?
*/

SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.departure_airport = 'AAQ'
  AND f.status NOT IN ('Cancelled',
                       'Scheduled')
  AND date_trunc('MONTH', f.scheduled_departure) 
        IN ('2017-01-01',
            '2017-02-01',
            '2017-12-01')

/*markdown
#### Вопрос 2. 
Сколько рейсов из Анапы вылетело зимой 2017 года?
*/

SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.departure_airport = 'AAQ'
  AND f.status = 'Cancelled'

/*markdown
#### Вопрос 3. 
Посчитайте количество отмененных рейсов из Анапы за все время.
*/

SELECT COUNT(f.flight_id)
FROM dst_project.flights f
LEFT JOIN dst_project.airports ap ON ap.airport_code = f.arrival_airport
WHERE f.departure_airport = 'AAQ'
  AND ap.city NOT IN ('Moscow')

/*markdown
#### Вопрос 4. 
Сколько рейсов из Анапы не летают в Москву?
*/

SELECT COUNT(f.arrival_airport)
FROM dst_project.flights f
LEFT JOIN dst_project.airports a 
        ON a.airport_code = f.arrival_airport
WHERE f.departure_airport = 'AAQ'
  AND a.city NOT IN ('Moscow')

/*markdown
#### Вопрос 5. 
Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?
*/

SELECT a.model Aircraft_model,
    f.aircraft_code Model_code,
    COUNT(DISTINCT s.seat_no) Seats_number
FROM dst_project.flights f
    LEFT JOIN dst_project.seats s ON s.aircraft_code = f.aircraft_code
    LEFT JOIN dst_project.aircrafts a ON a.aircraft_code = f.aircraft_code
WHERE f.departure_airport = 'AAQ'
GROUP BY a.model, f.aircraft_code
ORDER BY 3 DESC
LIMIT 1


/*markdown
## 6. Переходим к реальной аналитике
*/

WITH tf AS
  (SELECT t.flight_id,
          SUM(t.amount) flight_amount,
          COUNT(DISTINCT t.ticket_no) sold_seats
   FROM dst_project.ticket_flights t
   GROUP BY t.flight_id),
     st AS
  (SELECT s.aircraft_code,
          COUNT(DISTINCT s.seat_no) seats_qty
   FROM dst_project.seats s
   GROUP BY s.aircraft_code)
SELECT f.flight_id,
       f.flight_no,
       f.arrival_airport,
       f.aircraft_code,
       tf.flight_amount,
       tf.sold_seats sold_seats,
       st.seats_qty total_ac_capacity,
       ((extract(HOUR
                 FROM (f.scheduled_arrival - f.scheduled_departure))*60) + (extract(MINUTE
                                                                                    FROM (f.scheduled_arrival - f.scheduled_departure)))) f_duration
FROM dst_project.flights f
FULL OUTER JOIN tf ON tf.flight_id = f.flight_id
JOIN st ON st.aircraft_code = f.aircraft_code
WHERE departure_airport = 'AAQ'
  AND (date_trunc('month', scheduled_departure) in ('2017-01-01',
                                                    '2017-02-01',
                                                    '2017-12-01'))
  AND status not in ('Cancelled')
GROUP BY f.flight_id,
         f.flight_no,
         f.aircraft_code,
         f.arrival_airport,
         tf.flight_amount,
         tf.sold_seats,
         st.seats_qty,
         f.scheduled_arrival,
         f.scheduled_departure
ORDER BY 5