# Зачем и для кого
Для студентов и преподавателей при проверке 4 лабораторной работы.

## Фаззиг - что это?
Это когда набор данных для вашей программы генерируете не вы сами или преподаватели, а внешняя программка,
причем  соверашает несколько тысяч запусков в секунду с разными набороами данных.
Благодаря этому можно очень быстро и легко найти баг. 

## С чего начать?
Выполните команду
```
afl-clang-fast
```
Если нет ошибки и есть полноценный вывод, то переходите к разделу "Выполнение тестового примера"

Иначе - чиатем дальше.

## Если AFL++ не установлен

### Если вы сервере - то:

```
./install_afl.sh
```

### Если делаете на домашней системе, идем по ссылке на гайд
https://github.com/AFLplusplus/AFLplusplus/blob/stable/docs/INSTALL.md

И выполняем весь скрипт.

### После этого необходимо добавить переменную окружения, которая указывает путь до AFL

Например
```
export AFL_PATH=~/AFLplusplus/
```
Далее 

`make fuzz`

И все пойдет само.


## Выполнение тестового примера
В данном примере сделана мини 4 лабораторная работа.
В ней и будем искать ошибки. 

Выполним `make fuzz` и все пойдет дальше само:

Сначала выполянются стадия `make debug` - файлы основной программы и библиотеки собираются с инструментацией 
(санитайзером ASAN - это как валгринд, только красивее и "роняет" вашу программу сразу при обнаружении ошибки).

Далее для фаззера создается две папки **in** и **out** .

В **out** будет хранится наборы данных, которые обработал фаззер.

Там же в папке **crashes** будут наборы данных, которые привели к падению. 

Их можно посмотреть через команду **cat**

Для фаззинга вам нужен фаззер. 
У него есть собтсвенный компилятор.
К этому моменту он должен быть установлен, поэтому программа скомпилируется с нужным компилятором (`afl-clang-fast`) сама.

Далее запускается фаззинг командай `afl-fuzz -i in/ -o out -- ./bin_asan `

Если все круто, то увидете окошко фаззера. 

Если будут краши - появятся красные цифры около надписи **SAVED CRASHES**, как здесь.

![AFL crush!](/docks/afl.jpg "AFL")

В этом тестовом проекте будет найдено пару крашей.

## Свой запуск
В данном репозитории сделан тестовый проект. 
Скорее всего ваша лаба по структуре файлов похожа на этот проект.
Поэтому можете использовать make файл от данного проекта.

Собственно в папке **lib** должен лежать файлик с расширеним `.c` - это реализация ваших внешних функций библиотеки **string**

И файлик `main` в корне - там ваша основнная программа.

`make fuzz`

И все пойдет само.
